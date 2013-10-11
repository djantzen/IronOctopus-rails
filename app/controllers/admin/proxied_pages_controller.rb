class Admin::ProxiedPagesController < ApplicationController

  require "socksify/http"

  respond_to :html
  #before_filter :authenticate_user
  before_filter :ensure_anonymity
  AGENT = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.17 Safari/537.36"
  TOR_HOST = "127.0.0.1"
  TOR_PORT = 9050
  DIRECT_DOMAINS = ["www.youtube.com"]

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
      elsif direct_request?(url_string) #
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
      unless url_root =~ /youtube\.com/
        @page.css("script").remove
        @page.css("head").remove
      end
      @page.css("link").remove
      @page.css("meta").remove
      @page.css("style").remove
    end

    def generate_link(proxied_url)
      return proxied_url if proxied_url.nil? or proxied_url =~ /^#/
      proxied_url.gsub!(/\.\.?\//, "/")
      if proxied_url =~ /^\//
        return @url_root + proxied_url
      end
      proxied_url
    end

    def handle
      @page.css("a").each do |a|
        proxied_url = a.attr("href")
        a["href"] = generate_link(proxied_url)
      end
      @page.css("img").each do |img|
        proxied_url = img.attr("src")
        img["src"] = "/admin/proxied_pages?url=" + generate_link(proxied_url)
      end
      wrap_images()
      wrap_videos()
      #wrap_body_parts()
      @page.to_html
    end

    def traverse_doc(node = @doc.css("html"))
      unless node.is_a?(Nokogiri::XML::Text)
        # recurse for children and collect all the returned
        # nodes into an array
        children = node.children.inject([]) { |acc, child|
          acc += number_words(child, counter)
        }
        # replace the node's children
        node.children = Nokogiri::XML::NodeSet.new(doc, children)
        return [node]
      end
    end

    def wrap_body_parts
      BodyPart.all.each do |body_part|
        @doc.css("p").each do |p|
          p.text().gsub!(/(#{body_part.region})/i, "<body-part-region>#{$1}</body-part-region")
          @text.gsub!(/(#{body_part.name})/i, "<body-part>#{$1}</body-part")
          @text.gsub!(/(The)/i, "<body-part>#{$1}</body-part")
        end
      end
    end

    def wrap_images
      button = <<-EOT
        <span class='image-wrapper'>
          <button class='btn btn-primary btn-small' onclick='event.preventDefault(); return false;'>
            Choose Image
          </button>
        </span>"
      EOT
      @page.xpath("//a[img]").wrap(button)
    end

    def wrap_videos
      button = <<-EOT
        <span class='video-wrapper'>
          <button class='btn btn-primary btn-small' onclick='event.preventDefault(); return false;'>
            Choose Video
          </button>
        </span>"
      EOT
      @page.css("a[href^='http://www.youtube.com/watch']").wrap(button)
    end

  end

  class GooglePageHandler < PageHandler
    def extract_proxied_url(original)
      if original.match(/q=(.*?)&/)
        $1
      #http://www.google.com/imgres?imgurl=http://www.thetotaltoner.com/shapefit-pics/quadriceps-exercises-hack-squats.gif&imgrefurl=http://www.shapefit.com/quadriceps-exercises-hack-squats.html&h=240&w=320&sz=96&tbnid=swR3_Vk8069PaM:&tbnh=83&tbnw=111&zoom=1&usg=__c4VbrwBIdyrfmL0zFi5Uc6kp6PU=&sa=X&ei=q4lVUvy8F-2JiwL5n4CwBA&ved=0CEMQ9QEwCg
      elsif original.match(/imgurl=(.*?)&/)
        $1
      end
    end

    def handle
      results_div = @page.css("#ires")
      results_div.css("a").each do |a|
        original_href = a.attr("href")
        proxied_url = extract_proxied_url(original_href)
        if proxied_url
          #a["href"] = generate_link(proxied_url)
          a["href"] = generate_link(URI::decode(proxied_url))
        else
          Rails.logger.warn("Couldn't parse " + original_href)
        end
      end
      #results_div.xpath("//a[img]").each do |a|
      #  proxied_url = a.attr("href")
      #  a["src"] = "/admin/proxied_pages?url=" + generate_link(proxied_url)
      #end
      #results_div.css("img").each do |img|
      #  proxied_url = img.attr("src")
      #  img["src"] = "/admin/proxied_pages?url=" + URI::encode(generate_link(proxied_url))
      #end

      wrap_images()
      wrap_videos()
      results_div.to_html
    end
  end

end
