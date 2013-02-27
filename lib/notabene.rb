require 'redcarpet'

class CustomMarkdownFormatter < Redcarpet::Render::HTML
  
  def header(text, header_level)
    Notabene.current_file_parser.title = text if header_level == 1
    "<h#{header_level}>#{text}</h#{header_level}>"
  end
end

class FileParser
  attr_writer :title 
  attr_reader :title, :html, :filename, :output_filename

  def initialize(filename)
    # HACK: can't figure out a way to get the info back from the custom formatter otherwise
    Notabene.current_file_parser = self
    @filename = filename
    @output_filename = self.filename.gsub('.md', '.html').gsub('.markdown', '.html')  
    @title = "<No title>"

    markdown = Redcarpet::Markdown.new(CustomMarkdownFormatter, :autolink => true, :space_after_headers => true)
    @html = markdown.render(File.read(filename))
  end

  def render_to_file
    File.open("./output/" + self.output_filename, 'w') do |file|  
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

    File.open("./output/_nav.html", 'w') do |file|  
      file.puts "<html><body><ul>"
      
      @entries.each do |e|
        file.puts "<li><a href='#{e.output_filename}' target='rhs'>#{e.title}</a></li>"
      end
      
      file.puts "</ul></body></html>"
    end

    File.open("./output/index.html", "w") do |file|
      file.puts '<frameset cols="25%,*">'
      file.puts '<frame src="_nav.html">'
      file.puts '<frame src="about:blank" id="rhs">'
      file.puts '</frameset>'
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
