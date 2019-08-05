#!/usr/bin/ruby

# file: polyrex-xslt.rb

require 'rexle'
require 'rexle-builder'


class PolyrexXSLT

  def initialize(schema: '', xslt_schema: '', debug: false)

    @schema, @xslt_schema, @debug = schema, xslt_schema, debug

  end

  def to_xslt()

    a_element = @schema.split('/').map{|x| x[/\w+/]}

    @xslt_schema = build_xslt_schema(@schema) if @xslt_schema.empty?
    puts ('@xslt_schema: ' + @xslt_schema.inspect).debug if @debug

    a_html = @xslt_schema.split('/').map do |x|

      result = x.match(/([\w\>]+)(?:[\(\[]([^\]\)]+)[\]\)])?(.*)/)
      name, children, remaining = result.captures if result

      list = children.split(/ *, */).map {|y| y.split(':',2)} if children        

      [name, list]
    end

    puts ('a_html: ' + a_html.inspect).debug if @debug

    a = a_element.zip(a_html)

    xml = RexleBuilder.new
    raw_a = xml.xsl_stylesheet(xmlns_xsl: \
                     "http://www.w3.org/1999/XSL/Transform", version: "1.0") do
      xml.xsl_output(method: "xml", indent: "yes", \
                                              :"omit-xml-declaration" => "yes")

      a.each_cons(2).with_index do |x,i|

        x1, x2 =  x
        puts 'x1: '  + x1.inspect if @debug
        build(xml, x1, x2)
        build(xml, x2) if x2

      end

    end

    xml2 = Rexle.new(raw_a).xml(pretty: true).gsub('xsl_apply_templates',\
        'xsl:apply-templates').gsub('xsl_value_of','xsl:value-of').\
        gsub('xsl_template','xsl:template').gsub('xsl_','xsl:').\
        gsub('xmlns_xsl','xmlns:xsl')
    
    
  end

  private

  def build(xml, a1, a2=nil)

    xml.xsl_template(match: a1[1][0]) do

      xml.send a1[0].to_sym do

        xml.summary do

          if a1[1][1] then

            a1[1][1].each do |source, target|
            
              xml.xsl_element(name: target) do
                xml.xsl_value_of(select: source)  
              end

            end

          end

        end        

        xml.records do
          xml.xsl_apply_templates(select:  a2[1][0]) if a2
        end
      end 
    end

  end

end
