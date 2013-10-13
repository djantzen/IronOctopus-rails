class Admin::ProxiedPagesController < ApplicationController

  require "socksify/http"

  respond_to :html
  before_filter :validate_caller
  before_filter :ensure_anonymity
  AGENT = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36"
  TOR_HOST = "127.0.0.1"
  TOR_PORT = 9050
  DIRECT_DOMAINS = ["www.youtube.com"]
  ALLOWED_CALLERS = ["localhost", "127.0.0.1", "www.ironoctop.us", "ironoctop.us"]

  def validate_caller
    raise "Illegal usage from #{request.host}" unless ALLOWED_CALLERS.include? request.host
  end

  def ensure_anonymity
    unless Tor.running?
      raise "Start Tor!"
    end
  end

  def direct_request?(url_string)
    DIRECT_DOMAINS.each do |domain|
      return true if url_string =~ /#{domain}/
    end
    false
  end

  def get
    url_string = params[:url]
    url = URI.parse(url_string)
    host = url.host
    scheme = url.scheme
    proxied_doc =
      if scheme == "https" # Unable to route SSL through the SOCKS proxy
        Net::HTTP.start(host, url.port, :use_ssl => true) do |https|
          https.use_ssl = true
          https.verify_mode = OpenSSL::SSL::VERIFY_NONE
          # Google chokes on the user agent? WTF?
          response = https.get(url.request_uri) # , { "User-Agent" => AGENT })
          Nokogiri::HTML(response.body)
        end
      elsif direct_request?(url_string)
        Net::HTTP.start(host, url.port, :use_ssl => false) do |http|
          response = http.get(url.request_uri) # , { "User-Agent" => AGENT })
          Nokogiri::HTML(response.body)
        end
      elsif url.request_uri.match(/\.jpeg|\.jpg|\.png$/)
        Net::HTTP.SOCKSProxy(TOR_HOST, TOR_PORT).start(host, url.port) do |http|
          response = http.get(url.request_uri, { "User-Agent" => AGENT })
          send_data(response.body, :type => response.header["content-type"], :disposition => 'inline')
          return
        end
      else
        Net::HTTP.SOCKSProxy(TOR_HOST, TOR_PORT).start(host, url.port) do |http|
          response = http.get(url.request_uri, { "User-Agent" => AGENT })
          Nokogiri::HTML(response.body)
        end
      end
    url_root = "#{scheme}://#{host}"

    handler =
      if proxied_doc.css("#ires").size() > 0
        Admin::GooglePageHandler.new(url_root, proxied_doc)
      else
        Admin::PageHandler.new(url_root, proxied_doc)
      end

    render :text => handler.handle(), :layout => false
  end

end
