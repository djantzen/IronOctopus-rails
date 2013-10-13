module Admin
  class PageHandler
  include Ferret

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

    PATTERN = "(?<!<span>)(?:[\s>])(KEYWORDS)(?!<\/span>)"
    REGION_SYNONYMS = { "Arm Flexors" => "Biceps", "Arm Extensors" => "Triceps",
                        "Gluteals" => "Glutes", "Thigh Flexors" => "Hamstrings", "Quadriceps" => "Quads",
                        "Dorsal Muscles" => "Lats", "Abdominals" => "Abs" }
    REGIONS = BodyPart.all_regions.inject({}) do |hash, region|
      keywords = REGION_SYNONYMS[region] ? region + "|" + REGION_SYNONYMS[region] : region
      hash[region] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end
    BODY_PARTS = BodyPart.all.inject({}) do |hash, body_part|
      skip_words = ["Long", "Short", "Head", "Lateral", "Medial", "Lower", "Upper", "Middle"]
      keywords = body_part.name.split(" ").reject { |name| skip_words.include? name }.join("|")
      hash[body_part.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end
    IMPLEMENTS = Implement.all.inject({}) do |hash, implement|
      hash[implement.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", implement.name)})/i)
      hash
    end
    ACTIVITY_ATTRIBUTES = ActivityAttribute.all.inject({}) do |hash, activity_attribute|
      skip_words = ["utility", "impact", "high", "low"]
      keywords = activity_attribute.name.split(" ").reject { |name| skip_words.include? name }.join("|")
      hash[activity_attribute.name] = Regexp.new(/(#{PATTERN.gsub("KEYWORDS", keywords)})/i)
      hash
    end

    def generate_keyword_list(list_identifier, regex_list, text)
      index_list = Nokogiri::XML::Node.new("ol", @page)
      index_list[:id] = list_identifier
      regex_list.each do |region, regexp|
        if text.match(regexp)
          item = Nokogiri::XML::Node.new("li", @page)
          item.content = region
          index_list.add_child(item)
        end
      end
      index_list
    end

    def grep_keywords
      @page.search("text()").each do |text_node|
        the_text = text_node.text()
        REGIONS.each do |region, regexp|
          the_text.gsub!(regexp,
                         "<span class='region-match' identifier='#{region.to_identifier}' style='color:red;font-size:120%;'><span>"  +
                         '\1</span></span>')
        end
        BODY_PARTS.each do |body_part, regexp|
          the_text.gsub!(regexp,
                         "<span class='body-part-match' identifier='#{body_part.to_identifier}' style='color:purple;font-size:120%;'><span>" +
                         '\1</span></span>')
        end
        ACTIVITY_ATTRIBUTES.each do |activity_attribute, regexp|
          the_text.gsub!(regexp,
                         "<span class='activity-attribute-match' identifier='#{activity_attribute.to_identifier}' style='color:orange;font-size:120%;'><span>" +
                         '\1</span></span>')
        end
        IMPLEMENTS.each do |implement, regexp|
          the_text.gsub!(regexp,
                         "<span class='implement-match' identifier='#{implement.to_identifier}' style='color:green;font-size:120%;'><span>" +
                         '\1</span></span>')
        end
        text_node.replace(the_text)
      end
    end

    def grep_keywords2
      index_node = Nokogiri::XML::Node.new("div", @page)
      index_node[:id] = "activity-indexes"
      text = @page.text()
      index_node.add_child(generate_keyword_list("body-regions", REGIONS, text))
      index_node.add_child(generate_keyword_list("body-parts", BODY_PARTS, text))
      index_node.add_child(generate_keyword_list("activity-attributes", ACTIVITY_ATTRIBUTES, text))
      index_node.add_child(generate_keyword_list("implements", IMPLEMENTS, text))

      @page.at_css("html").children.first.add_previous_sibling(index_node)

    end
    #def highlight_keywords
    #  index = Index::Index.new
    #  index << { :content => @page.text }
    #  query = Ferret::Search::MultiTermQuery.new(:content)
    #  BODY_PARTS.each do |region, regex|
    #    query.add_term(region.downcase)
    #  end
    #  index.search_each(query) do | id, score |
    #    Rails.logger.warn("searching")
    #
    #    highlights = index.highlight(query, id, :field => :content, :pre_tag => "<strong>",
    #                                        :post_tag => "</strong>", :num_excerpts => 15, :excerpt_length => 80)
    #    Rails.logger.warn("highlighting")
    #    puts highlights
    #    return highlights.join('')#.gsub(/[^\w]/, '')
    #  end
    #end

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