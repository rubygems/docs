require_dependency 'syntax/convertors/html'

# The base class for all figures. A "figure" in this sense is a visual aid for
# documentation, such as a block of code, or a chart, or graph, or such. Each
# type of figure should subclass this. Currently, Figure::for_options needs
# to be edited for each new type of figure to allow the subclass to be found
# based on the set of options given to it.
class Figure
  # the unformatted body of the figure
  attr_reader :body

  # the hash of options for this figure
  attr_reader :opts

  # A factory method for returning the appropriate figure subclass for the
  # given set of options.
  def self.for_options( options )
    if options["lang"]
      CodeFigure
    else
      Figure
    end
  end

  # Create a new Figure with the given body and hash of options.
  def initialize( body, opts )
    @body = body
    @opts = opts
  end

  # A convenience for accessing the options of the figure.
  def []( name )
    @opts[ name ]
  end

  # Returns the caption for this figure. If no caption was given, it defaults
  # to "Figure".
  def caption
    @opts["caption"] || "Figure"
  end

  # Convert this figure to html. If the parameter is non-nil, it will be used
  # as the body of the figure. (This allows subclasses to perform partial
  # formatting of the body and pass the result back up the inheritance chain.)
  def to_html( body=nil )
    body ||= @body

    style=""

    if opts["align"]
      style << "align: #{opts["align"]};"
    elsif opts["float"]
      style << "float: #{opts["float"]};"
    end

    "<div class='figure'" +
      ( style.empty? ? "" : " style='#{style}'" ) + ">\n" +
    "<span class='caption'>#{caption}</span>\n" +
    "<div class='body'>#{body}</div>\n" +
    "</div>"
  end

end

# Any textual figure should inherit from this, including code blocks and
# (heaven forbid) ascii art.
class TextualFigure < Figure

  # Returns the result of the "number" options, and should be treated as
  # a boolean indicating whether or not line numbers should be displayed for
  # this figure. (Note that subclasses must add the pre tag themselves if they
  # wish the text to be preformatted.)
  def number?
    @opts["number"]
  end

  # Check to see if line numbers should be applied, and apply them if so. Then
  # call the ancestor's #to_html method.
  def to_html( body=nil )
    body ||= @body

    # If "number" is set, then each line of the figure should be numbered.
    if number?
      line = 1
      numbers = ""
      body.each_line { numbers << "#{line}<br />"; line += 1 }
      body = "<table border='0' cellpadding='0' cellspacing='0'>" +
             "<tr><td class='lineno'>#{numbers}</td>" +
             "<td width='100%'>#{body}</td></tr></table>"
    end

    super body
  end

end

# Represents a figure that contains a block of code in some syntax. It will be
# syntax highlighted if the underlying highlighter understands the syntax
# requested.
class CodeFigure < TextualFigure

  # Returns the name of the syntax that the code uses. This should never
  # return +nil+.
  def lang
    @opts["lang"]
  end

  # Appends the name of the requested syntax to the caption given by the
  # superclass.
  def caption
    super + " [#{lang}]"
  end

  # Applies syntax highlighting to the body of the figure and passes the
  # result up the inheritance chain.
  def to_html( body=nil )
    body ||= @body

    convertor = for_syntax( lang )
    body = "<link rel='stylesheet' type='text/css' " +
           "href='/stylesheets/#{lang}.css' />" +
           "<div class='#{lang}'>" +
           convertor.convert( body ) +
           "</div>"

    super body
  end

  private

    # For returning the syntax translator for the named language. (This
    # is for unit testing purposes, so that the convertor may be replaced
    # with a mock object.)
    def for_syntax( lang )
      Syntax::Convertors::HTML.for_syntax( lang )
    end

end
