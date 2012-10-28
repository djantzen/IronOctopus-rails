namespace :erb do
  namespace :to do
    desc "Converts all .html.erb files to .html.haml"
    task :haml do
      print "looking for erb views..\n"
      files = `find ./app/views -name *.html.erb`
      files.each_line do |file|
        file.strip!
        print "parsing file: #{file}\n"
        `html2haml #{file} | cat > #{file.gsub(/\.erb$/, ".haml")}`
        `git rm #{file}`
      end
    end
  end
end