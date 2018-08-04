require 'nokogiri'

class Parser
  # It is possible to use *args here, but in this particular case i'd like to use key-value arguments
  def initialize(original_html:, another_html:, id:'make-everything-ok-button')
    @original_html = original_html
    @another_html = another_html
    @element_id = id
  end

  def get_element_xpath()
    read_html(@original_html)
    set_original_element_data()
    read_html(@another_html)
    search_for_element_in_another_html()
  end

  private
    def read_html(html)
      @html_doc = Nokogiri::HTML(open(html))
    end

    def set_original_element_data()
      original_element = @html_doc.xpath("//a[@id='#{@element_id}']").first
      @element_class = original_element.attr('class')
      @element_title = original_element.attr('title')
      puts 'Original button\'s xpath: ' + original_element.css_path
    end

    def search_for_element_in_another_html()
      puts "In 75% of diff cases there are the same css classes"
      another_element = @html_doc.xpath("//a[@class='#{@element_class}']").first
      if another_element.nil?
        puts "In other 75% of diff cases there is the same title"
        @html_doc.xpath("//a[@title='#{@element_title}']").first
      end
      puts 'Another button\'s xpath: ' + another_element.css_path rescue puts 'Crap cant find by class nor by title'
    end
end

parser = Parser.new(original_html: ARGV[0], another_html: ARGV[1], id: ARGV[2])

parser.get_element_xpath()

