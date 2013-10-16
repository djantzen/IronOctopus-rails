module Admin
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
      if proxied_url =~ /^\/\//
        "http:#{proxied_url}"
      elsif proxied_url =~ /^\//
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
        img["src"] = generate_link(proxied_url)
      end
      wrap_images()
      wrap_videos()
      grep_keywords()
      @page.to_html
    end

    PATTERN = "(?<!<span>)(KEYWORDS)(?!<\/span>)"
    REGION_SYNONYMS = { "Arm Flexors" => "Biceps", "Arm Extensors" => "Triceps",
                        "Gluteals" => "Glutes", "Thigh Flexors" => "Hamstrings", "Quadriceps" => "Quads",
                        "Dorsal Muscles" => "Lats", "Abdominals" => "Abs", "Scapulae Fixers" => "Rhomboids"}
    REGIONS = BodyPart.all_regions.inject({}) do |hash, region|
      keywords = REGION_SYNONYMS[region] ? region + "|" + REGION_SYNONYMS[region] : region
      hash[region] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end
    BODY_PARTS = BodyPart.order(:name).all.inject({}) do |hash, body_part|
      skip_words = ["Long", "Short", "Head", "Lateral", "Medial", "Lower", "Upper", "Middle", "Major", "Minor"]
      keywords = body_part.name + "|" + body_part.name.split(" ").reject { |name| skip_words.include? name }.join("|")
      hash[body_part.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end
    IMPLEMENTS = Implement.all.inject({}) do |hash, implement|
      hash[implement.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", implement.name)})/i)
      hash
    end
    ACTIVITY_ATTRIBUTE_SYNONYMS = { "Pushing" => "Push", "Pulling" => "Pull" }
    ACTIVITY_ATTRIBUTES = ActivityAttribute.all.inject({}) do |hash, activity_attribute|
      skip_words = ["Utility", "Impact", "High", "Low", "Mechanics", "Force"]
      split_keywords = activity_attribute.name.split(" ").reject { |name| skip_words.include? name }.join("|")
      keywords = split_keywords.blank? ? activity_attribute.name : activity_attribute.name + "|" + split_keywords
      hash[activity_attribute.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end

    def substitute_keywords!(the_text, keyword, regexp, color, keyword_type)
      the_text.gsub!(regexp,
                     "<span class='keyword-match has-tooltip-right' identifier='#{keyword.to_identifier.reverse}'" +
                       "style='color:#{color};font-size:120%;' title='#{keyword_type}: #{keyword.reverse}'>" +
                       "<i class='add-keyword icon-plus-sign'/><span>"  +
                       '\1</span></span>')
    end

    def grep_keywords
      @page.search("text()").each do |text_node|
        the_text = text_node.text()
        REGIONS.each do |region, regexp|
          substitute_keywords!(the_text, region, regexp, "red", "Body Region")
        end
        BODY_PARTS.each do |body_part, regexp|
          substitute_keywords!(the_text, body_part, regexp, "purple", "Muscle")
        end
        ACTIVITY_ATTRIBUTES.each do |activity_attribute, regexp|
          substitute_keywords!(the_text, activity_attribute, regexp, "orange", "Attribute")
        end
        IMPLEMENTS.each do |implement, regexp|
          substitute_keywords!(the_text, implement, regexp, "green", "Equipment")
        end
        the_text.scan(/identifier='(.*?)'/).each do |match|
          the_text.gsub!(match[0], match[0].reverse)
        end
        the_text.scan(/title='.*?: (.*?)'/).each do |match|
          the_text.gsub!(match[0], match[0].reverse)
        end

        text_node.replace(the_text)
      end
    end

    def image_wrapper
      wrapper = <<-EOT
        <span class='image-wrapper'>
          <button class='btn btn-primary btn-small' onclick='event.preventDefault(); return false;'>
            Choose Image
          </button>
        </span>"
      EOT
      wrapper
    end

    def video_wrapper
      wrapper = <<-EOT
        <span class='video-wrapper'>
          <button class='btn btn-primary btn-small' onclick='event.preventDefault(); return false;'>
            Choose Video
          </button>
        </span>"
      EOT
      wrapper
    end

    def wrap_images
      @page.xpath("//a[img]").wrap(image_wrapper)
      @page.xpath("//img[not(ancestor::a)]").wrap(image_wrapper) # need to filter out images inside of a tags
      #@page.css("img").wrap(image_wrapper) # need to filter out images inside of a tags
    end

    def wrap_videos
      @page.css("a[href^='http://www.youtube.com/watch']").wrap(video_wrapper)
    end

  end
end