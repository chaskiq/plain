require 'front_matter_parser'

class Plain::DocsService
  DEFAULT_POSITION = 999

  def self.get_structure
    # Get markdown files at root directory
    root_files = get_files('docs', true)
    {
      name: 'docs',
      type: 'directory',
      children: root_files[:children] + parse_main_sections  # Add root files to children array
    }
  end

  def self.parse_section_items
    config = self.config
    main_sections = config['sections']
  end

  def self.config
    file_path = Rails.root.join('docs', 'config.yml')
    return {} if !File.exist?(file_path) 
    config = YAML.safe_load(File.read(file_path)) || {}
  end
  
  def self.parse_main_sections
    #file_path = Rails.root.join('docs', 'config.yml')
    #config = YAML.safe_load(File.read(file_path)) || {}
    main_sections = config['sections'] || []
  
    # Get all directories under 'docs'
    all_sections = Dir.children(Rails.root.join('docs')).select do |entry|
      File.directory?(Rails.root.join('docs', entry))
    end.map do |dir|
      section = get_files(File.join('docs', dir))  # Get children here
      section[:name] = dir
      section[:position] = DEFAULT_POSITION
      section
    end
  
    # Overwrite positions with those found in config.yml
    main_sections.each do |section|
      matching_section = all_sections.find { |s| s[:name] == section['name'] }
      if matching_section
        matching_section[:position] = section['position']
      end
    end
  
    # Sort by position and return children
    all_sections.sort_by { |section| section[:position] }
  end

  def self.get_markdown(file_path)
    parsed = FrontMatterParser::Parser.parse_file(Rails.root.join('docs', "#{file_path}.md"))
    parsed
  end
  
  def self.get_content(file_path)
    parsed = self.get_markdown(file_path)
   
    # markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    # markdown.render(parsed.content).html_safe
    # binding.pry
    Plain::AiDocs.convert_markdown(parsed.content)
  end

  #def self.parse_main_sections
  #  file_path = Rails.root.join('docs', 'config.yml')
  #  config = YAML.load_file(file_path)
  #  main_sections = config['sections']
  #end

  private

  def self.get_files(directory, only_files_at_root = false)
    FileUtils.mkdir_p(Rails.root.join(directory))
    Dir.entries(Rails.root.join(directory)).sort.each_with_object({ name: directory.split('/').last, type: 'directory', children: [], position: 999 }) do |entry, parent|
      next if ['.', '..'].include?(entry)
  
      path = "#{directory}/#{entry}"
      path_in_root = Rails.root.join(path)
      
      if entry == 'config.yml' && File.exist?(path_in_root)
        config = YAML.load_file(path_in_root)
        parent[:position] = config['position'] || 999
      elsif File.directory?(path_in_root)
        # Skip directories if only_files_at_root is true
        parent[:children] << get_files(path_in_root) unless only_files_at_root
      else
        parsed = FrontMatterParser::Parser.parse_file(path_in_root)
        parent[:children] << { name: parsed.front_matter['title'] || entry.sub('.md', ''), type: 'file', path: path.sub('docs/', '').sub('.md', ''), position: parsed.front_matter['menu_position'] || 999 }
      end
  
      # After adding all children and before returning, sort them by position and assign prev and next links
      sorted_children = parent[:children].sort_by { |child| child[:position] }
      
      sorted_children.each_with_index do |child, index|
        if index > 0
          child[:prev] = {name: sorted_children[index - 1][:name], path: sorted_children[index - 1][:path]}
        end
        if index < sorted_children.size - 1
          child[:next] = {name: sorted_children[index + 1][:name], path: sorted_children[index + 1][:path]}
        end
      end
      
      parent[:children] = sorted_children
    end
  end
  
  def self.assign_position_from_config(parent, path)
    config = YAML.load_file(path)
    parent[:position] = config&.fetch('position', DEFAULT_POSITION)
  end

  def self.add_child_from_file(parent, path)
    parsed = FrontMatterParser::Parser.parse_file(path)
    parent[:children] << { name: parsed.front_matter['title'] || File.basename(path, '.md'), type: 'file', path: path.sub('docs/', '').sub('.md', ''), position: parsed.front_matter['menu_position'] || DEFAULT_POSITION }
  end

  def self.sort_children(parent)
    parent[:children] = parent[:children].sort_by { |child| child[:position] }

    parent[:children].each_with_index do |child, index|
      child[:prev] = parent[:children][index - 1] if index > 0
      child[:next] = parent[:children][index + 1] if index < parent[:children].size - 1
    end
  end

end
