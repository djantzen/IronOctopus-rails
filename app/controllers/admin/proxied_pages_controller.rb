class Admin::ProxiedPagesController < ApplicationController

  respond_to :html
  #before_filter :authenticate_user

  def get
    #url = URI::decode(params[:url])
    url = open(params[:url])
    protocol = url.base_uri.scheme
    host = url.base_uri.host
    url_root = "#{protocol}://#{host}"

    proxied_doc = Nokogiri::HTML(url)

    handler =
      if proxied_doc.css("#ires").size() > 0
        GooglePageHandler.new(url_root, proxied_doc)
      else
        PageHandler.new(url_root, proxied_doc)
      end

    render :text => handler.handle(), :layout => false
  end

  class PageHandler
    def initialize(url_root, page)
      @url_root = url_root
      @page = page
      #@page.css("script").remove
      @page.css("link").remove
      @page.css("meta").remove
      @page.css("style").remove
    end
    def generate_link(proxied_url)
      return if proxied_url.nil? or proxied_url =~ /^#/
      #return @url_root + proxied_url if proxied_url =~ /^\//
      #return @url_root + "/" + proxied_url if proxied_url =~ /\./
      proxied_url
    end
    def handle
      @page.css("a").each do |a|
        proxied_url = a.attr("href")
        a["href"] = generate_link(proxied_url)
      end
      @page.to_html
    end
  end

  class GooglePageHandler < PageHandler
    def handle
      results_div = @page.css("#ires")
      results_div.css("a").each do |a|
        original_href = a.attr("href")
        original_href.match(/q=(.*?)&/)
        proxied_url = $1
        if proxied_url
          #a["href"] = generate_link(proxied_url)
          a["href"] = generate_link(URI::decode(proxied_url))
        else
          Rails.logger.warn("Couldn't parse " + original_href)
        end
      end
      results_div.to_html
    end
  end

end
