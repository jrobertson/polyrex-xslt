# Introducing the Polyrex-XSLT gem

## Usage

    require 'polyrex-xslt'

    schema = 'entries/entry[title]'
    xslt_schema = 'tree/item[@title:title, @qty:qty]'

    pxsl = PolyrexXSLT.new schema: schema, xslt_schema: xslt_schema
    puts pxsl.to_xslt

## Output

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'&gt;
  &lt;xsl:output method='xml' indent='yes' omit-xml-declaration='yes'/&gt;
  &lt;xsl:template match='tree'&gt;
    &lt;entries&gt;
      &lt;summary/&gt;
      &lt;records&gt;
        &lt;xsl:apply-templates select='item'/&gt;
      &lt;/records&gt;
    &lt;/entries&gt;
  &lt;/xsl:template&gt;
  &lt;xsl:template match='item'&gt;
    &lt;entry&gt;
      &lt;summary&gt;
        &lt;xsl:element name='title'&gt;
          &lt;xsl:value-of select='@title'/&gt;
        &lt;/xsl:element&gt;
        &lt;xsl:element name='qty'&gt;
          &lt;xsl:value-of select='@qty'/&gt;
        &lt;/xsl:element&gt;
      &lt;/summary&gt;
      &lt;records/&gt;
    &lt;/entry&gt;
  &lt;/xsl:template&gt;
&lt;/xsl:stylesheet&gt;
</pre>

## Resources

* polyrex-xslt https://rubygems.org/gems/polyrex-xslt

xslt polyrex_xslt gem polyrex
