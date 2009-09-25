require_dependency 'figure'

# Converts a page's contents into HTML.
class HtmlEngine
  
  # Transform the given text and return it in HTML format.
  def self.transform(txt)
    engine = new( txt )
    return engine.transform
  end

  # Create a new instance of an HtmlEngine for processing the given text.
  def initialize( text )
    @text = text.to_s
  end

  # Transform the engine's text and return it in HTML format.
  def transform
    return "" if @text.empty?
        
    extract_figures
    convert_to_html
    process_figures

    @text
  end

  private

    # Extract all figures out and replace them with some token that will
    # survive the RedCloth transformation.
    def extract_figures
      @figures = []
      @text = @text.gsub( /\r\n/, "\n" )
      @text = @text.gsub( /^\{\{\{(.*?)\n(.*?)\n\}\}\}$/m ) do
        body = $2
        # the following magic takes a string of name=value pairs,
        # comma-delimited, and turns it into a hash. Duplicates are lost.
        opts = Hash[*$1.strip.split(/,/).map { |i| i.split(/=/,2) }.flatten]
        @figures << Figure.for_options( opts ).new( body, opts )
        "!!!#{@figures.length-1}"
      end
    end
  
    # Transform the text with RedCloth.
    def convert_to_html
      @text = RedCloth.new(@text).to_html
    end

    # Process the extracted figures and replace them in the converted
    # output.
    def process_figures
      # Revisit the extracted figures, looking for the tokens and processing
      # each figure in turn, replacing the place-holder tokens with the result.
      @text.gsub!( /<p>!!!(\d+)<\/p>/ ) do
        figure_index = $1.to_i
        @figures[ figure_index ].to_html
      end
    end

end

