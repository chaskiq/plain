# app/models/document.rb
class Plain::Document
  include ActiveModel::Model

  attr_accessor :title, :path, :content, :menu_position, :current_path

  validates :title, presence: true
  validates :path, presence: true
  validate :file_does_not_exist

  def save
    return false unless valid?

    # Ensure the directory exists
    FileUtils.mkdir_p(File.dirname(file_path))

    # Write to the file
    File.open(file_path, 'w') do |file|
      file.write("---\n")
      file.write("title: #{title}\n")
      file.write("menu_position: #{menu_position}\n")
      file.write("---\n\n")
      file.write(self.content)
    end

    true
  rescue
    false
  end


  private

  def sanitized_path
    sp = path.gsub(' ', '')
    sp += ".md" unless sp.end_with?('.md')
    sp
  end

  def file_path
    Rails.root.join('docs', sanitized_path)
  end

  def file_does_not_exist
    errors.add(:path, "File already exists") if File.exist?(file_path) && self.path != self.current_path
  end


end
