#!/usr/bin/ruby

# file: polyrex-xslt.rb

class PolyrexXSLT
  
  attr_accessor :schema, :xslt_schema

  def initialize(options={})
    o = {schema: '', xslt_schema: ''}.merge(options)
    @schema, @xslt_schema = o.values
  end

  def to_xslt()

header =<<HEADER
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes" />

HEADER

    a_element = @schema.split('/').map{|x| x[/\w+/]}

    a_html = @xslt_schema.split('/').map do |x|
     
      name = x[/\w+/]
      children = ($')[/^\[([^\]]+)\]$/,1]
      list = children.split(',').map {|y| y.split(':') } if children

      [name, list]
    end

    a = a_element.zip(a_html).map.with_index do |a,i|
      out = []
      tag = a.shift
      field = i > 0 ? 'records/' + tag : tag
      out << "<xsl:template match='#{field}'>" + "\n"
      a.flatten!(1)
      if a.last.is_a? Array then

        out << scan_e(a, tag) 
        out << "</xsl:template>\n\n"
      else
        out << "  <%s>\n" % a.first
        out << "    <xsl:apply-templates select='summary'/>\n"
        out << "    <xsl:apply-templates select='records'/>\n"
        out << "  <\\%s>\n" % a.first
        out << "</xsl:template>\n\n"
        out << "<xsl:template match='%s/summary'>\n" % [tag]
        out << "</xsl:template>\n\n"
      end
      
      out
    end

    header + a.flatten.join + "</xsl:stylesheet>"
  end

  private

  def scan_e(a, prev_tag='', indent='  ')

    out = []

    unless a.first.is_a? Array then
      tag = a.shift
      out << indent + "<%s>\n" % tag
      out << indent + "  <xsl:apply-templates select='summary'/>\n"
      out << indent + "<\\%s>\n" % tag
      out << "</xsl:template>\n\n"
      out << "<xsl:template match='%s/summary'>\n" % [prev_tag]

      a.flatten!(1)
      if a.last.is_a? Array then
        out << scan_e(a, tag, indent + '  ') 
      else
        out << indent + '  ' + a.first + "\n"
      end

    else
      a.map do |x| 
        out << indent + "<%s><xsl:value-of select='%s'/></%s>\n" % [x[0],x[-1],x[0]]
      end
    end

    out
  end
  
end
