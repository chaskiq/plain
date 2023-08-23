namespace :plain do
  desc "Indexes the contents"
  task :load => :environment do
    puts "loading contents of the project"
    Plain::AiDocs.new.load_all
    puts "contents indexed"
  end


  desc "Build the tailwind css"
  task :tailwind_engine_watch do
    require "tailwindcss-rails"
    # NOTE: tailwindcss-rails is an engine
    Dir.chdir(Plain::Engine.root.to_s) do
      system "tailwindcss \
            -i #{Plain::Engine.root.join("app/assets/stylesheets/plain/application.tailwind.css")} \
            -o #{Plain::Engine.root.join("app/assets/builds/plain.css")} \
            -c #{Plain::Engine.root.join("tailwind.config.js")} \
            --minify -w"
    end
  end

  namespace :site do
    desc "Compile site"
    task compile: :environment do
      require 'rack/static'
      require 'fileutils'
  
      # Ensure public/docs directory exists
      FileUtils.mkdir_p(Rails.root.join('public', 'docs'))
  
      # Get the structure from the DocsService class
      structure = Plain::DocsService.get_structure
  
      # Get all files from the structure
      files = Plain::DocsService.get_all_files(structure)

      # Generate the proper paths and compile the files
      files.each do |file|
        path = file[:path]
        content = Plain::DocsService.get_content(path)
  
        # Create necessary directories
        FileUtils.mkdir_p(File.dirname(Rails.root.join('public', 'static-plain/docs', "#{path}.html")))
  
        response = Rails.application.call( 'PATH_INFO' => "/plain/docs/#{path}",'HTTP_HOST' => 'localhost', 'HTTP_PORT' => "3000",'REQUEST_METHOD' => 'GET', 'QUERY_STRING' => 'static=true', 'rack.input' => StringIO.new)
        
        if response.first == 200
          html = response[2].first

          html.gsub!(/href="\/plain\/docs\/([^"]*)"/, 'href="/static-plain/docs/\1.html"')

          # Save compiled file to public/docs directory
          File.open(Rails.root.join('public', 'static-plain/docs', "#{path}.html"), 'w') do |f|
            f.write(html)
          end
        end
      end
    end
  end
end