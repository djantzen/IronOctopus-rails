module Admin
  class GooglePageHandler < PageHandler
    def extract_proxied_url(original)
      if original.match(/q=(.*?)&/)
        $1
        #http://www.google.com/imgres?imgurl=http://www.thetotaltoner.com/shapefit-pics/quadriceps-exercises-hack-squats.gif&imgrefurl=http://www.shapefit.com/quadriceps-exercises-hack-squats.html&h=240&w=320&sz=96&tbnid=swR3_Vk8069PaM:&tbnh=83&tbnw=111&zoom=1&usg=__c4VbrwBIdyrfmL0zFi5Uc6kp6PU=&sa=X&ei=q4lVUvy8F-2JiwL5n4CwBA&ved=0CEMQ9QEwCg
      elsif original.match(/imgurl=(.*?)&/)
        $1
      end
    end

    #def wrap_images
    #  @page.xpath("//a[img]").wrap(image_wrapper)
    #end

    def handle
      results_div = @page.css("#ires")
      results_div.css("a").each do |a|
        original_href = a.attr("href")
        proxied_url = extract_proxied_url(original_href)
        if proxied_url
          a["href"] = generate_link(URI::decode(proxied_url))
        else
          Rails.logger.warn("Couldn't parse " + original_href)
        end
      end
      wrap_images()
      wrap_videos()
      results_div.to_html
    end
  end

end