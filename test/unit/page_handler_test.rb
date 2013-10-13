require 'test_helper'
#require 'ferret'
class PageHandlerTest < ActiveSupport::TestCase
  include Ferret

  test "wikipedia" do
    doc = Nokogiri::HTML(open(File.dirname(__FILE__) + "/../data/wikipedia_bench_press.html"))

    #doc = Nokogiri::HTML.parse("<html><div>Here's some stuff</div><p>and some other stuff</p></html>")
    #doc = "<html><div>Here's some stuff</div><p>and some other stuff</p></html>"
    index = Index::Index.new()
    index << doc.to_html
    ##puts index.search("stuff")
    #
    #index.search_each("stuff") do |id, score|
    #  highlights = index.highlight("stuff", id, :pre_tag => "<div>", :post_tag=>"</div>")
    #  puts highlights
    #end

    index = Index::Index.new()
    index << {:content => doc.to_html}
    query = Ferret::Search::MultiTermQuery.new(:content)
    query.add_term("chest")
    query.add_term("pectoral*")
        index.search_each(query) do | id, score |
          puts "ID #{id}"
          # put highlights into a copy of the content field
          # by way of <strong> HTML tags
          highlights = index.highlight(query,
                                       id,
                                       :field => :content,
                                       :pre_tag => "<strong>",
                                       :post_tag => "</strong>")

          puts highlights
        end

  end

  test "ugh" do
    doc = Nokogiri::HTML(open(File.dirname(__FILE__) + "/../data/wikipedia_bench_press.html"))

    handler = Admin::PageHandler.new("root", doc)
    text = handler.handle()

    puts text

  end
end
