require 'redcarpet'

class CustomMarkdownFormatter < Redcarpet::Render::HTML
  
  def header(text, header_level)
    Notabene.current_file_parser.title = text if header_level == 1
    "<h#{header_level}>#{text}</h#{header_level}>"
  end
end

class FileParser
  attr_writer :title 
  attr_reader :title, :html, :filename

  def initialize(filename)
    Notabene.current_file_parser = self
    @filename = filename
    @title = "<No title>"

    markdown = Redcarpet::Markdown.new(CustomMarkdownFormatter, :autolink => true, :space_after_headers => true)
    @html = markdown.render(File.read(filename))
  end

  def render_to_file
    File.open("./output/" + self.filename.gsub('md', 'html'), 'w') do |file|  
      file.puts make_header
      file.puts self.html
      file.puts make_footer
    end   
  end

  private
  def make_header
    "<html><head><title>#{self.title}</title></head><body>"
  end

  def make_footer
    "</body></html>"
  end
end

class NavigationBuilder

  def initialize
    @entries = []
  end

  def add_entry(parser)
    @entries.push(parser)
  end

  def generate
    files = Dir.glob("*.{md, markdown}")

    files.each do |f|
      self.add_entry FileParser.new(f)
    end

    @entries.each do |e|
      puts "#{e.title} in #{e.filename}"
      
      e.render_to_file
    end
  end
end

class Notabene

  def self.current_file_parser=(new_parser)
    @@current_parser = new_parser
  end

  def self.current_file_parser
    @@current_parser
  end

  def run
    nav_builder = NavigationBuilder.new()

    puts "About to run in #{Dir.pwd}..."

    nav_builder.generate

    puts 'Done'
  end

end
