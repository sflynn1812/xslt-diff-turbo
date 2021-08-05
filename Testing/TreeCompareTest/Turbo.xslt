<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
extension-element-prefixes="exsl"
  >
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
	<!-- change this variable to the file to compare against -->
	<xsl:variable name="file2" >
		<configuration>
			<configSections>
				<section name="MyConfiguration" requirePermission="false" type="System.Configuration.NameValueSectionHandler,System,Version=1.0.3300.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" />
			</configSections>
			<MyConfiguration>
				<add key="ApplicationName" value="Configuration Tests" />
				<add key="DebugMode" value="Default" />
				<add key="MaxDisplayListItems" value="15" />
				<add key="SendAdminEmailConfirmations" value="False" />
				
				<add key="needle" value="inAHayStack"/>
				
				<add key="MailServer" value="mail.MyWickedServer.com:334" />
				<add key="MailServerPassword" value="seekrity" />
			</MyConfiguration>
		</configuration>
	</xsl:variable>
	<xsl:template match="comment()"/>
	<!-- Entry point into transform: file loading and processing occurs here -->
	<xsl:template  match="/">
		<xsl:variable name="IDs2" select="exsl:node-set($file2)/." />
		<xsl:variable name="output">
			<xsl:call-template name="procedure">
				<xsl:with-param name="tree" select="exsl:node-set(.)/*"/>
				<xsl:with-param name="comparer" select="exsl:node-set($IDs2)/*"></xsl:with-param>
			</xsl:call-template>
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
			<!-- to do sort linearization then compare branches forward and backward to solve twinning problem (duplicate leaf elements) -->
			<xsl:variable name="linear-comparer-unsorted">
				<xsl:call-template name="linearization">
					<xsl:with-param name="tree" select="exsl:node-set($comparer)/."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="linear-comparer">
			<xsl:call-template name="sortLinearization">
			
			</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="linear-tree-unsorted">
				<xsl:call-template name="linearization">
					<xsl:with-param name="tree" select="exsl:node-set($tree)/."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="linear-comparer">
				<xsl:call-template name="sortLinearization">
					<xsl:with-param name="list" select="exsl:node-set($linear-comparer-unsorted)/*" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="linear-tree">
				<xsl:call-template name="sortLinearization">
					<xsl:with-param name="list" select="exsl:node-set($linear-tree-unsorted)/*" />
				</xsl:call-template>
			</xsl:variable>
			<left-not-in-right>
				<xsl:call-template name="linearBranchLoop">
					<xsl:with-param name="node" select="exsl:node-set($linear-comparer)/*"/>
					<xsl:with-param name="list" select="exsl:node-set($linear-tree)/*" />
				</xsl:call-template>
			</left-not-in-right>
			<right-not-in-left>
				<xsl:call-template name="linearBranchLoop">
					<xsl:with-param name="node" select="exsl:node-set($linear-tree)/*"/>
					<xsl:with-param name="list" select="exsl:node-set($linear-comparer)/*" />
				</xsl:call-template>
			</right-not-in-left>
		</root>
	</xsl:template>
	<xsl:template name="linearBranchLoop">
		<xsl:param name="node"></xsl:param>
		<xsl:param name="list"></xsl:param>
		<xsl:for-each select="exsl:node-set($node)/*">
			<xsl:call-template name="divideAndConquer">
				<xsl:with-param name="node" select="." />
				<xsl:with-param name="list" select="exsl:node-set($list)/*"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="sortLinearization">
		<xsl:param name="list"></xsl:param>
			<xsl:for-each select="exsl:node-set($list)/*">
				<xsl:sort select="*|@*"/>
				<xsl:copy-of select="exsl:node-set(.|./@*)"/>
			</xsl:for-each>
	</xsl:template>
	<xsl:template name="divideAndConquer">
		<xsl:param name="node"></xsl:param>
		<xsl:param name="list"></xsl:param>
		<xsl:if test="count(exsl:node-set($list)) = 1">
			<xsl:call-template name="branchToChildMatch">
				<xsl:with-param name="nodeLeft" select="exsl:node-set($node)"></xsl:with-param>
				<xsl:with-param name="nodeRight" select="exsl:node-set($list)"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(exsl:node-set($list)) > 1">
			<xsl:variable name="elsewhere2">
				<xsl:variable name="elsewhere1">
					<xsl:if test="exsl:node-set($list)[not((position()) > (count(exsl:node-set($list)) div 3))]">
						<xsl:call-template name="divideAndConquer">
							<xsl:with-param name="node" select="exsl:node-set($node)" />
							<xsl:with-param name="list" select="exsl:node-set($list)[not(position() > (count(exsl:node-set($list)) div 3))]"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="exsl:node-set($elsewhere1)//match/*">
					<!-- twin of branch to leaf checking -->
					<xsl:variable name="theFollowingSiblingIsDuplicate">
						<xsl:call-template name="branchToChildMatch">
							<xsl:with-param name="nodeLeft" select="exsl:node-set($node)/following-sibling::*" />
							<xsl:with-param name="nodeRight" select="exsl:node-set($list)" />
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="theFollowingSiblingOfTheMatchBranchIsDuplicate">
						<xsl:call-template name="branchToChildMatch">
							<xsl:with-param name="nodeLeft" select="exsl:node-set($node)/following-sibling::*" />
							<xsl:with-param name="nodeRight" select="exsl:node-set($list)/following-sibling::*" />
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="exsl:node-set($theFollowingSiblingIsDuplicate)//match and not(exsl:node-set($theFollowingSiblingOfTheMatchBranchIsDuplicate)//match)">
						<mismatch>
								<xsl:copy-of select="exsl:node-set($list)/following-sibling::(* | @*)"/>
						</mismatch>
					</xsl:if>
					<match>
						<xsl:copy-of select="exsl:node-set($node | @*)"/>
					</match>				
				</xsl:if>
				<xsl:if test="not(exsl:node-set($elsewhere1)//match/*) and not(exsl:node-set($list)[position() > (count(exsl:node-set($list)) div 3) and not((position()) > (count(exsl:node-set($list)) div (3 div 2)))])">
					<mismatch>
						<xsl:copy-of select="exsl:node-set($node | @*)"/>
					</mismatch>
				</xsl:if>
				<xsl:if test="not(exsl:node-set($elsewhere1)//match/*) and exsl:node-set($list)[position() > (count(exsl:node-set($list)) div 3) and not((position()) > (count(exsl:node-set($list)) div (3 div 2)))]">
					<xsl:call-template name="divideAndConquer">
						<xsl:with-param name="node" select="exsl:node-set($node)" />
						<xsl:with-param name="list" select="exsl:node-set($list)[position() > (count(exsl:node-set($list)) div 3) and not((position()) > (count(exsl:node-set($list)) div (3 div 2)))]"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<xsl:if test="exsl:node-set($elsewhere2)//match/*">
				<!-- twin of branch to leaf checking -->
				<xsl:variable name="theFollowingSiblingIsDuplicate">
						<xsl:call-template name="branchToChildMatch">
							<xsl:with-param name="nodeLeft" select="exsl:node-set($node)/following-sibling::*" />
							<xsl:with-param name="nodeRight" select="exsl:node-set($list)" />
						</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="theFollowingSiblingOfTheMatchBranchIsDuplicate">
						<xsl:call-template name="branchToChildMatch">
							<xsl:with-param name="nodeLeft" select="exsl:node-set($node)/following-sibling::*" />
							<xsl:with-param name="nodeRight" select="exsl:node-set($list)/following-sibling::*" />
						</xsl:call-template>
				</xsl:variable>
				<xsl:if test="exsl:node-set($theFollowingSiblingIsDuplicate)//match and not(exsl:node-set($theFollowingSiblingOfTheMatchBranchIsDuplicate)//match)">
						<mismatch>
								<xsl:copy-of select="exsl:node-set($list)/following-sibling::(* | @*)"/>
						</mismatch>
				</xsl:if>
				<match>
					<xsl:copy-of select="exsl:node-set($node | @*)"/>
				</match>
			</xsl:if>
			<xsl:if test="not(exsl:node-set($elsewhere2)//match/*) and not(exsl:node-set($list)[position() > (count(exsl:node-set($list)) div (3 div 2))])">
				<mismatch>
					<xsl:copy-of select="exsl:node-set($node | @*)"/>
				</mismatch>
			</xsl:if>			
			<xsl:if test="not(exsl:node-set($elsewhere2)//match/*) and exsl:node-set($list)[position() > (count(exsl:node-set($list)) div (3 div 2))]">
				<xsl:call-template name="divideAndConquer">
					<xsl:with-param name="node" select="exsl:node-set($node)" />
					<xsl:with-param name="list" select="exsl:node-set($list)[position() > (count(exsl:node-set($list)) div (3 div 2))]"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="branchToChildMatch">
		<xsl:param name="nodeLeft"></xsl:param>
		<xsl:param name="nodeRight"></xsl:param>
		<xsl:variable name="isMatch">
			<xsl:call-template name="match-node">
				<xsl:with-param name="node1" select="exsl:node-set($nodeLeft)/."/>
				<xsl:with-param name="node2" select="exsl:node-set($nodeRight)/."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="exsl:node-set($isMatch)//match/*">
			<xsl:if test="exsl:node-set($nodeLeft)/*">
				<xsl:if test="exsl:node-set($nodeRight)/*">
					<xsl:variable name="branchToChildMatch">
						<xsl:call-template name="branchToChildMatch">
							<xsl:with-param name="nodeLeft" select="exsl:node-set($nodeLeft)/*"/>
							<xsl:with-param name="nodeRight" select="exsl:node-set($nodeRight)/*"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="exsl:node-set($branchToChildMatch)//match/*">
						<match>
							<xsl:copy-of select="exsl:node-set($nodeLeft | @*)" />
						</match>
					</xsl:if>
					<xsl:if test="not(exsl:node-set($branchToChildMatch)//match/*)">
						<mismatch>
							<xsl:copy-of select="exsl:node-set($nodeLeft | @*)" />
						</mismatch>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(exsl:node-set($nodeRight)/*)">
					<mismatch>
						<xsl:copy-of select="exsl:node-set($nodeLeft | @*)"/>
					</mismatch>
				</xsl:if>
			</xsl:if>
			<xsl:if test="not(exsl:node-set($nodeLeft)/*) and not(exsl:node-set($nodeRight)/*)">
				<match>
					<xsl:copy-of select="exsl:node-set($nodeLeft | @*)" />
				</match>
			</xsl:if>
		</xsl:if>
		<xsl:if test="not(exsl:node-set($isMatch)//match/*)">
			<mismatch>
				<xsl:copy-of select="exsl:node-set($nodeLeft | @*)" />
			</mismatch>
		</xsl:if>
	</xsl:template>
	<!-- The linearization function basically outputs a list of nodes that trace from the leaf back to the root, which is a better expression to compare against  -->
	<xsl:template name="linearization">
		<xsl:param name="tree"/>
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
						<xsl:for-each select="exsl:node-set($tree)/@*">
							<xsl:attribute name="{name(.)}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
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
			<xsl:if test="count(exsl:node-set($attribute-mismatch)//attribute) > 0">
				<xsl:if test="(not(translate(normalize-space(exsl:node-set($node1)/text()),'&#xa;', '')) and not(translate(normalize-space(exsl:node-set($node2)/text()),'&#xa;', ''))) or (translate(normalize-space(exsl:node-set($node1)/text()),'&#xa;', '') = translate(normalize-space(exsl:node-set($node2)/text()),'&#xa;', ''))">
					<match>
						<xsl:copy-of select="$node1 | @*"></xsl:copy-of>
					</match>
				</xsl:if>
				<xsl:if test="not((not(translate(normalize-space(exsl:node-set($node1)/text()),'&#xa;', '')) and not(translate(normalize-space(exsl:node-set($node2)/text()),'&#xa;', ''))) or (translate(normalize-space(exsl:node-set($node1)/text()),'&#xa;', '') = translate(normalize-space(exsl:node-set($node2)/text()),'&#xa;', '')))">
					<mismatch>
						<xsl:copy-of select="$node1 | @*"></xsl:copy-of>
					</mismatch>
				</xsl:if>
			</xsl:if>
			<xsl:if test="count(exsl:node-set($attribute-mismatch)//not-matched-name) > 0">
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
			<xsl:if test="(count($attributes1) = 0 and count($attributes2) = 0)">
				<attribute/>
			</xsl:if>
			<xsl:if test="(count($attributes1) != count($attributes2))">
				<not-matched-name/>
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
					<xsl:if test="count(exsl:node-set($result)//not-matched-name) = (count(exsl:node-set($attributes2)) - 1)">
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
		<xsl:copy-of select="$Array[position() > $StartIndex and not(position() > $EndIndex)] | @*" />
	</xsl:template>
</xsl:stylesheet>
