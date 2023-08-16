module Plain
  class DocsController < ApplicationController

    def show
      #@docs_structure = directory_hash(Rails.root.join('docs'))
      #render_markdown(params[:file_path])
      @docs_structure = DocsService.get_structure
      @config = DocsService.config
  
      if params[:file_path].blank?
        @content = nil
        @main_config = DocsService.parse_section_items
        render "show" and return
      end
  
      if params[:file_path].ends_with?('/')
        @content = DocsService.get_content("#{params[:file_path]}README")
      else
        @content = DocsService.get_content(params[:file_path])
      end
  
      @file = find_file(@docs_structure, params[:file_path])
    end
  
    private
  
    def find_file(directory, file_path)
      directory[:children].each do |child|
        if child[:type] == 'file' && child[:path] == file_path
          return child
        elsif child[:type] == 'directory'
          found_file = find_file(child, file_path)
          return found_file if found_file
        end
      end
      nil
    end
  
    def render_markdown(file_path)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      file = File.read(Rails.root.join('docs', "#{file_path}.md"))
      @content = markdown.render(file).html_safe
    rescue Errno::ENOENT
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  
    def directory_hash(path, name=nil)
      data = {name: (name || path)}
      data[:type] = File.directory?(path) ? 'directory' : 'file'
      data[:children] = children = []
      Dir.foreach(path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          children << directory_hash(full_path, entry)
        else
          children << { name: entry, type: 'file' }
        end
      end
      data
    end
  end
end
