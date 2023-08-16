namespace :plain do
  desc "Indexes the contents"
  task :load => :environment do
    puts "loading contents of the project"
    Plain::AiDocs.new.load_all
    puts "contents indexed"
  end


  task :tailwind_engine_watch do
    require "tailwindcss-rails"
    # NOTE: tailwindcss-rails is an engine
    Dir.chdir(Plain::Engine.root.to_s) do
      system "#{Tailwindcss::Engine.root.join("exe/tailwindcss")} \
            -i #{Plain::Engine.root.join("app/assets/stylesheets/plain/application.tailwind.css")} \
            -o #{Plain::Engine.root.join("app/assets/builds/plain.css")} \
            -c #{Plain::Engine.root.join("tailwind.config.js")} \
            --minify -w"
    end
  end
end