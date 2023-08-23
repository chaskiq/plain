module Plain
  class DocsController < ApplicationController

    def show
      get_docs
    end

    def edit
      get_docs
      @action = "edit"
      @markdown = DocsService.get_markdown(@file_path)
      @document = Plain::Document.new
      @document.title = @markdown.front_matter["title"]
      @document.menu_position = @markdown.front_matter["menu_position"]
      @document.content = @markdown.content
      @document.path = @file_path
    end

    def update
      get_docs
      @action = "edit"
      doc_params = params.require(:document).permit(:path, :content, :menu_position, :title)

      @markdown = DocsService.get_markdown(@file_path)
      @document = Plain::Document.new
      @document.title = doc_params["title"]
      @document.menu_position = doc_params["menu_position"]
      @document.content = doc_params["content"]
      @document.path = doc_params["path"]
      @document.current_path = @file_path

      puts @document.valid?
      if @document.save
        redirect_to docs_path(@file_path)
      else
        render "edit"
      end
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

    def get_docs
      @docs_structure = DocsService.get_structure
      @config = DocsService.config
  
      if params[:file_path].blank?
        @content = nil
        @main_config = DocsService.parse_section_items
        render "show" and return
      end
  
      if params[:file_path].ends_with?('/')
        @file_path = "#{params[:file_path]}README"
      else
        @file_path = "#{params[:file_path]}"
      end

      @content = DocsService.get_content(@file_path)
      @file = find_file(@docs_structure, @file_path)
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
