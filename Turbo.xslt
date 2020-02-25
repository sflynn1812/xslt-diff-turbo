<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
  >
  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
  <xsl:variable name="file2" select="document('C:\Users\Default User.DESKTOP-N6N13D5\Desktop\xslt-diff-turbo-master\compareAgainst.xml')" />
  <xsl:template match="comment()"/>
  <!-- Entry point into transform: file loading and processing occurs here -->
  <xsl:template  match="/">
    <xsl:variable name="IDs2" select="$file2/." />
    <xsl:variable name="output">
      <xsl:call-template name="procedure">
        <xsl:with-param name="tree" select="exsl:node-set(.)/*"/>
        <xsl:with-param name="comparer" select="exsl:node-set($IDs2/.)/*"></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="output-remove">
      <compare-result>
        <xsl:copy-of select="exsl:node-set($output)//mismatch"/>
      </compare-result>
    </xsl:variable>
    <root>
      <xsl:copy-of select="exsl:node-set($output)"/>
    </root>
  </xsl:template>
  <!-- Main recursive looping algorithm through nodes or leaves in current branch -->
  <xsl:template name="procedure" >
    <xsl:param name="comparer"/>
    <xsl:param name="tree"/>
    <root>
      <xsl:variable name="linear-comparer">
            <xsl:call-template name="linearization">
              <xsl:with-param name="tree" select="exsl:node-set($comparer)/."/>
            </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="linear-tree">
        <xsl:call-template name="linearization">
          <xsl:with-param name="tree" select="exsl:node-set($tree)/."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:for-each select="exsl:node-set($linear-comparer)">
        <xsl:call-template name="splitter">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="list" select="exsl:node-set($comparer)/*" />
        </xsl:call-template>
      </xsl:for-each>
    </root>
  </xsl:template>
  <xsl:template name="splitter">
    <xsl:param name="node"></xsl:param>
    <xsl:param name="list"></xsl:param>
    <xsl:variable name="is-match">
      <xsl:call-template name="match-node">
        <xsl:with-param name="node1" select="exsl:node-set($node)"/>
        <xsl:with-param name="node2" select="exsl:node-set($list)[0]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="exsl:node-set($is-match)//match">
        <xsl:if test="exsl:node-set($node)/* and exsl:node-set($list)[0]/*">
          <xsl:variable name="children-match">
            <xsl:call-template name="splitter">
              <xsl:with-param name="node" select="exsl:node-set($node)/*"></xsl:with-param>
              <xsl:with-param name="list" select="exsl:node-set($list)[0]/*"></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:if test="not(exsl:node-set($is-match)//mismatch/*)">
            <match>
              <xsl:copy-of select="exsl:node-set($node)"/>
            </match>
          </xsl:if>
          <xsl:if test="not(exsl:node-set($is-match)//match/*)">
            <mismatch>
              <xsl:copy-of select="exsl:node-set($node)"/>
            </mismatch>
          </xsl:if>
        </xsl:if>
        <xsl:if test="not(exsl:node-set($node)/*)">
          <xsl:if test="not(exsl:node-set($is-match)//mismatch/*)">
            <match>
              <xsl:copy-of select="exsl:node-set($node)"/>
            </match>
          </xsl:if>
          <xsl:if test="exsl:node-set($is-match)//mismatch/*">
            <mismatch>
              <xsl:copy-of select="exsl:node-set($node)"/>
            </mismatch>
          </xsl:if>
        </xsl:if>
      </xsl:if>
      <xsl:if test="count(exsl:node-set($list)) > 1 and not(exsl:node-set($is-match)//mismatch/*)">
        <xsl:call-template name="splitter">
          <xsl:with-param name="node" select="exsl:node-set($node)" />
          <xsl:with-param name="list" select="exsl:node-set($list)[position() > 1 and not(position() > count(exsl:node-set($list)))]"/>
        </xsl:call-template>
      </xsl:if>
  </xsl:template>
  <xsl:template name="linearization">
    <xsl:param name="tree"/>
      <xsl:if test="exsl:node-set($tree)/@*">
          <xsl:for-each select="exsl:node-set($tree)/@*">
            <xsl:call-template name="convert-attribute-to-xml"></xsl:call-template>
          </xsl:for-each>  
      </xsl:if>    
      <xsl:if test="exsl:node-set($tree)/*">
        <xsl:variable name="surround"  select="name(exsl:node-set($tree))"/>
        <xsl:for-each select="exsl:node-set($tree)/*">
          <xsl:variable name="recurse-leaf">
                <xsl:call-template name="linearization">
                  <xsl:with-param name="tree" select="."></xsl:with-param>
                </xsl:call-template>
          </xsl:variable>          
            <xsl:for-each select="exsl:node-set($recurse-leaf)/*"> 
                        <xsl:element name="{$surround}">
                          <xsl:copy-of select="."/>
                        </xsl:element>            
            </xsl:for-each>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="not(exsl:node-set($tree)/*)">
        <xsl:copy-of select="exsl:node-set($tree)"/>
      </xsl:if>
  </xsl:template>
  <xsl:template name="convert-attribute-to-xml">
    <data-attrtibute-data>
        <xsl:element name="{local-name()}">
          <xsl:value-of select="."/>
        </xsl:element>      
    </data-attrtibute-data>
  </xsl:template>
  <!-- sub function for matching single nodes -->
  <xsl:template name="match-node">
    <xsl:param name="node1"></xsl:param>
    <xsl:param name="node2"></xsl:param>
    <xsl:if test="name($node1) = name($node2)">
      <xsl:variable name="attribute-mismatch">
        <xsl:call-template name="attribute-value-mismatch">
          <xsl:with-param name="attributes1" select="$node1/@*"></xsl:with-param>
          <xsl:with-param name="attributes2" select="$node2/@*"></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="count(exsl:node-set($attribute-mismatch)//attribute) = 0">
        <xsl:if test="(not(exsl:node-set(translate(normalize-space($node1/text()),'&#xa;', ''))) and not(exsl:node-set(translate(normalize-space($node2/text()),'&#xa;', '')))) or (translate(normalize-space($node1/text()),'&#xa;', '') = translate(normalize-space($node2/text()),'&#xa;', ''))">
          <match>
            <xsl:copy-of select="$node1 | @*"></xsl:copy-of>
          </match>
        </xsl:if>
        <xsl:if test="not((not(exsl:node-set(translate(normalize-space($node1/text()),'&#xa;', ''))) and not(exsl:node-set(translate(normalize-space($node2/text()),'&#xa;', '')))) or (translate(normalize-space($node1/text()),'&#xa;', '') = translate(normalize-space($node2/text()),'&#xa;', '')))">
          <mismatch>
            <xsl:copy-of select="$node1 | @*"></xsl:copy-of>
          </mismatch>
        </xsl:if>
      </xsl:if>
      <xsl:if test="count(exsl:node-set($attribute-mismatch)//attribute) > 0">
        <mismatch>
          <xsl:apply-templates mode="copy-no-namespaces" select="$node1 | @*" />
        </mismatch>
      </xsl:if>
    </xsl:if>
    <xsl:if test="name($node1) != name($node2)">
      <mismatch>
        <xsl:apply-templates mode="copy-no-namespaces" select="$node1 | @*" />
      </mismatch>
    </xsl:if>
  </xsl:template>
  <!-- sub function for matching attributes in two nodes - outputs an attribute node only when an attibute mismatches -->
  <xsl:template name="attribute-value-mismatch">
    <xsl:param name="attributes1" />
    <xsl:param name="attributes2" />
    <attribute-match>
      <xsl:if test="(count($attributes1) != count($attributes2))">
        <attribute />
      </xsl:if>
      <xsl:if test="(count($attributes1) = count($attributes2))">
        <xsl:for-each select="$attributes1">
          <xsl:variable name="attribute1" select="."/>
          <xsl:variable name="result">
            <attroot>
              <xsl:for-each select="$attributes2">
                <xsl:if test="name(.) = name($attribute1/.)">
                  <xsl:if test="not(. = $attribute1/.)">
                    <not-matched-name/>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="name(.) != name($attribute1/.)">
                  <not-matched-name/>
                </xsl:if>
              </xsl:for-each>
            </attroot>
          </xsl:variable>
          <xsl:if test="count(exsl:node-set($result)//not-matched-name) = count(exsl:node-set($attributes2))">
            <attribute />
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </attribute-match>
  </xsl:template>
  <xsl:template match="*" mode="copy-no-namespaces">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="copy-no-namespaces"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="comment()| processing-instruction()" mode="copy-no-namespaces">
    <xsl:copy/>
  </xsl:template>
  <xsl:template name="Range">
    <xsl:param name="Array" />
    <xsl:param name="StartIndex"/>
    <xsl:param name="EndIndex"/>
    <xsl:copy-of select="$Array[position() > $StartIndex and not(position() > $EndIndex)]" />
  </xsl:template>
</xsl:stylesheet>
