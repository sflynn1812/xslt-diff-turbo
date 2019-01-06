<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
  >
  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
  <xsl:variable name="file2" select="document('b.xml')" />
  <xsl:template match="comment()"/>
  <!-- Entry point into transform: file loading and processing occurs here -->
  <xsl:template  match="/">
    <xsl:variable name="IDs2" select="$file2/." />
        <xsl:variable name="output">
          <xsl:call-template name="splitter">
          <xsl:with-param name="tree" select="*"/>
          <xsl:with-param name="comparer" select="$IDs2/*"></xsl:with-param>
          <xsl:with-param name="comparer-original" select="$IDs2/*"></xsl:with-param>
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
  <xsl:template name="splitter" >
    <xsl:param name="comparer"/>
    <xsl:param name="tree"/>
    <result>
    <xsl:if test="count(exsl:node-set($comparer)) = 1">
      <xsl:if test="count(exsl:node-set($tree)) = 1">
        <xsl:variable name="isMatch">
          <xsl:call-template name="match-node">
            <xsl:with-param name="node1" select="exsl:node-set($comparer)/."></xsl:with-param> 
            <xsl:with-param name="node2" select="exsl:node-set($tree)/."></xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="exsl:node-set($isMatch)//mismatch">
          <comparer>
            <mismatch>
              <xsl:copy-of select="exsl:node-set($comparer)/."/>
            </mismatch>
          </comparer>
          <tree>
            <mismatch>
              <xsl:copy-of select="exsl:node-set($tree)/."/>
            </mismatch>
          </tree>
        </xsl:if>
      <xsl:if test="not(exsl:node-set($isMatch)//mismatch)">
        <xsl:if test="exsl:node-set($comparer)/* and exsl:node-set($tree)/*">
            <xsl:variable name="child-recurse">
                <xsl:call-template name="splitter">
                  <xsl:with-param name="comparer" select="exsl:node-set($comparer)/*"/>
                  <xsl:with-param name="tree" select="exsl:node-set($comparer)/*"/>
                </xsl:call-template>
            </xsl:variable>
            <!-- post process child recurse on single node (post process function?) -->
        </xsl:if>
      </xsl:if>
      <xsl:if test="count(exsl:node-set($tree)) > 1">
	<xsl:variable name="range-left">
	   <xsl:call-template name="Range">
              <xsl:with-param name="Array" select="exsl:node-set($tree)/."/>
              <xsl:with-param name="StartIndex" select="0" />
              <xsl:with-param name="EndIndex" select="count(exsl:node-set($tree)/.) / 2" />
           </xsl:call-template>
        </xsl:variable>	
	<xsl:variable name="range-right">
	   <xsl:call-template name="Range">
              <xsl:with-param name="Array" select="exsl:node-set($tree)/."/>
              <xsl:with-param name="StartIndex" select="count(exsl:node-set($tree)/.) / 2" />
              <xsl:with-param name="EndIndex" select="count(exsl:node-set($tree)/.)" />
           </xsl:call-template>
        </xsl:variable>	
<xsl:variable name="result-left">
        <xsl:call-template name="splitter">
            <xsl:with-param name="comparer" select="exsl:node-set($range-left)/*"/>
            <xsl:with-param name="tree" select="exsl:node-set($comparer)/*"/>   
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="result-right">
        <xsl:call-template name="splitter">
            <xsl:with-param name="comparer" select="exsl:node-set($range-right)/*"/>
            <xsl:with-param name="tree" select="exsl:node-set($comparer)/*"/>   
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="combine-mismatch">
   <root>
      <tree>
	<xsl:copy-of select="exsl:node-set($result-left)//mismatch-tree/*"/>
        <xsl:copy-of select="exsl:node-set($result-right)//mismatch-tree/*"/>
      </tree>
      <compare>
	<xsl:copy-of select="exsl:node-set($result-left)//mismatch-compare/*"/>
        <xsl:copy-of select="exsl:node-set($result-right)//mismatch-compare/*"/>
      </compare>
   </root>
</xsl:variable>
<xsl:variable name="recurse-mismatches">
        <xsl:call-template name="splitter">
            <xsl:with-param name="comparer" select="exsl:node-set($combine-mismatch)/compare"/>
            <xsl:with-param name="tree" select="exsl:node-set($comparer)/tree"/>   
	</xsl:call-template>
</xsl:variable>
      </xsl:if>
      </xsl:if>
    </xsl:if>
    <xsl:if>
       
    </xsl:if>
    </result>
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
          <xsl:if test="not(not(exsl:node-set(translate(normalize-space($node1/text()),'&#xa;', ''))) and not(exsl:node-set(translate(normalize-space($node2/text()),'&#xa;', '')))) or (translate(normalize-space($node1/text()),'&#xa;', '') = translate(normalize-space($node2/text()),'&#xa;', ''))">
            <mismatch>
        <xsl:apply-templates mode="copy-no-namespaces" select="$node1 | @*" />
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
  <!-- sub function: exclude node from branch -->
  <xsl:template name="excludeNodeFromTree">
    <xsl:param name="branch-layer"></xsl:param>
    <xsl:param name="node"></xsl:param>
    <xsl:if test="name(exsl:node-set($branch-layer)[1]) = name($node)">
      <xsl:variable name="attribute-value-mismatch-count-exclude">
        <xsl:call-template name="attribute-value-mismatch">
          <xsl:with-param name="attributes1" select="$branch-layer[1]/@*"/>
          <xsl:with-param name="attributes2" select="$node/@*"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="count(exsl:node-set($attribute-value-mismatch-count-exclude)/attribute-match/attribute) = 0">
        <sub-tree>
          <xsl:for-each select="exsl:node-set($branch-layer[1])/preceding-sibling::*">
            <xsl:copy-of select="."/>
          </xsl:for-each>
          <xsl:for-each select="exsl:node-set($branch-layer[1])/following-sibling::*">
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </sub-tree>
      </xsl:if>
      <xsl:if test="count(exsl:node-set($attribute-value-mismatch-count-exclude)/attribute-match/attribute) > 0">
        <xsl:call-template name="excludeNodeFromTree">
          <xsl:with-param name="branch-layer" select="$branch-layer[1]/following-sibling::*"></xsl:with-param>
          <xsl:with-param name="node" select="$node"></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
    <xsl:if test="name($branch-layer[1]) != name($node) and exsl:node-set($branch-layer)[1]/following-sibling::*">
      <xsl:call-template name="excludeNodeFromTree">
        <xsl:with-param name="branch-layer" select="$branch-layer[1]/following-sibling::*"/>
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="not(exsl:node-set($branch-layer)[1]/following-sibling::*)">
      <sub-tree>
      </sub-tree>
    </xsl:if>
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
    <root>
      <xsl:copy-of select="$Array[position() > $StartIndex and not(position() > $EndIndex)]" />
    </root>
</xsl:template>
</xsl:stylesheet>
