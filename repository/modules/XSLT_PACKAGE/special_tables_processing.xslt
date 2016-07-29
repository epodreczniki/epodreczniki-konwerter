<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 0.4 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:epconvert="http://epodreczniki.pl/convert" exclude-result-prefixes="w epconvert">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:function name="epconvert:process_special_table_attributes" as="element()">
		<xsl:param name="table" as="element()"/>
		<xsl:param name="position"/>
		<xsl:variable name="attributes" as="node()*">
			<xsl:for-each select="$table/descendant::w:sdt">
				<xsl:variable name="tag" select="w:sdtPr/w:tag/@w:val"/>
				<xsl:element name="attribute">
					<xsl:attribute name="tag" select="$tag"/>
					<xsl:choose>
						<xsl:when test="descendant::w:dropDownList">
							<xsl:value-of select="w:sdtPr/w:dropDownList/w:listItem[@w:displayText=string-join((ancestor::w:sdt/w:sdtContent/descendant::w:t/text(),''),'')]/@w:value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="w:sdtContent/descendant::m:oMath">
									<xsl:apply-templates select="w:sdtContent/*" mode="TEXTBOX_WITH_MATHML"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="value" select="w:sdtContent/descendant::w:t[not(preceding-sibling::w:rPr) or not(preceding-sibling::w:rPr/w:rStyle) or not(some $x in $MS_WORD_STYLES/style[@key='substitute_text']/name/text() satisfies preceding-sibling::w:rPr/w:rStyle/@w:val=$x)]/text()"/>
									<xsl:if test="'     '!=$value">
										<xsl:value-of select="$value"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="tag" select="$table/w:tblPr/w:tblDescription/@w:val"/>
		<xsl:variable name="special_table_descriptor" select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@tag=$tag]"/>
		<xsl:variable name="exact_fields">
			<xsl:for-each select="$special_table_descriptor/field[@type='exact']">
				<xsl:variable name="field" select="."/>
				<xsl:variable name="tag" select="@tag"/>
				<xsl:variable name="attribute" as="node()*">
					<xsl:copy-of select="$attributes[@tag=$tag]"/>
				</xsl:variable>
				<xsl:variable name="validators" as="node()*">
					<xsl:copy-of select="validator"/>
				</xsl:variable>
				<xsl:variable name="errors" select="epconvert:validate_special_table_attribute($validators,$attribute,$field)"/>
				<xsl:choose>
					<xsl:when test="0=count($errors)">
						<xsl:copy-of select="epconvert:emit_special_table_attribute($attribute,$field,$field/@tag)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$errors"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="pattern_fields">
			<xsl:for-each-group select="$attributes" group-by="@tag">
				<xsl:variable name="attribute" select="current-group()"/>
				<xsl:for-each select="$special_table_descriptor/field[@type='pattern']">
					<xsl:variable name="field" select="."/>
					<xsl:variable name="pattern" select="@tag"/>
					<xsl:analyze-string select="$attribute[1]/@tag" regex="{$pattern}">
						<xsl:matching-substring>
							<xsl:variable name="validators" as="node()*">
								<xsl:copy-of select="$field/validator"/>
							</xsl:variable>
							<xsl:variable name="errors" select="epconvert:validate_special_table_attribute($validators,$attribute,$field)"/>
							<xsl:choose>
								<xsl:when test="0=count($errors)">
									<xsl:variable name="emitted_attribute" select="epconvert:emit_special_table_attribute($attribute,$field,$attribute[1]/@tag)"/>
									<xsl:element name="attribute">
										<xsl:attribute name="name" select="regex-group($field/@name_at)"/>
										<xsl:choose>
											<xsl:when test="$field/@id">
												<xsl:attribute name="id" select="$field/@id"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="id" select="regex-group($field/@id_at)"/>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:for-each select="1 to $field/@groups">
											<xsl:attribute name="group_{.}" select="regex-group(.)"/>
										</xsl:for-each>
										<xsl:copy-of select="$emitted_attribute/@*"/>
										<xsl:copy-of select="$emitted_attribute/node()"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$errors">
										<xsl:element name="error">
											<xsl:copy-of select="@*"/>
											<xsl:choose>
												<xsl:when test="$field/@id">
													<xsl:attribute name="id" select="$field/@id"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="id" select="regex-group($field/@id_at)"/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:copy-of select="node()"/>
										</xsl:element>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:for-each>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="grouped_pattern_fields">
			<xsl:for-each-group select="$pattern_fields/element()[some $x in ('attribute','error') satisfies $x=local-name()]" group-by="@id">
				<xsl:element name="element">
					<xsl:attribute name="id" select="current-grouping-key()"/>
					<xsl:copy-of select="current-group()"/>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:element name="special_table">
			<xsl:attribute name="position" select="$position"/>
			<xsl:attribute name="tag" select="$tag"/>
			<xsl:attribute name="type" select="$special_table_descriptor/@type"/>
			<xsl:if test="$special_table_descriptor/@subtype">
				<xsl:attribute name="subtype" select="$special_table_descriptor/@subtype"/>
			</xsl:if>
			<xsl:copy-of select="$special_table_descriptor/constants/element()" exclude-result-prefixes="w"/>
			<xsl:copy-of select="$exact_fields"/>
			<xsl:copy-of select="$grouped_pattern_fields"/>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:validate_special_table_attribute" as="node()*">
		<xsl:param name="validators" as="node()*"/>
		<xsl:param name="attribute" as="node()*"/>
		<xsl:param name="field" as="element()"/>
		<xsl:for-each select="$validators">
			<xsl:variable name="validator" select="."/>
			<xsl:choose>
				<xsl:when test="@type='option'">
					<xsl:for-each select="$attribute">
						<xsl:variable name="value" select="text()"/>
						<xsl:if test="not($field/map/entry[@key=$value])">
							<xsl:variable name="nodes">
								<xsl:element name="value">
									<xsl:value-of select="$value"/>
								</xsl:element>
							</xsl:variable>
							<xsl:copy-of select="epconvert:emit_special_table_processing_error($validator,$field,$nodes)"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="@type='required'">
					<xsl:for-each select="$attribute">
						<xsl:if test="not(normalize-space(text()))">
							<xsl:copy-of select="epconvert:emit_special_table_processing_error($validator,$field,())"/>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="0 = count($attribute)">
						<xsl:copy-of select="epconvert:emit_special_table_processing_error($validator,$field,())"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@type='single'">
					<xsl:if test="1 &lt; count($attribute)">
						<xsl:copy-of select="epconvert:emit_special_table_processing_error(.,$field,())"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="@type='unique'">
					<xsl:for-each-group select="$attribute" group-by="text()">
						<xsl:if test="1 &lt; count(current-group())">
							<xsl:copy-of select="epconvert:emit_special_table_processing_error($validator,$field,())"/>
						</xsl:if>
					</xsl:for-each-group>
				</xsl:when>
				<xsl:when test="@type='pattern'">
					<xsl:for-each select="$attribute">
						<xsl:if test="normalize-space(text())">
							<xsl:analyze-string select="text()" regex="{$validator/@regexp}">
								<xsl:non-matching-substring>
									<xsl:variable name="nodes">
										<xsl:element name="value">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:variable>
									<xsl:copy-of select="epconvert:emit_special_table_processing_error($validator,$field,$nodes)"/>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:emit_special_table_attribute" as="node()*">
		<xsl:param name="attribute" as="node()*"/>
		<xsl:param name="field" as="element()"/>
		<xsl:param name="tag" as="xs:string"/>
		<xsl:variable name="multiple_value" select="$field/@type='pattern' and 1 &lt; count($attribute)"/>
		<xsl:for-each select="$attribute">
			<xsl:variable name="value" select="text()"/>
			<xsl:variable name="value_with_elements" select="node()"/>
			<xsl:element name="attribute">
				<xsl:attribute name="tag" select="$tag"/>
				<xsl:attribute name="key" select="$field/@key"/>
				<xsl:if test="$multiple_value">
					<xsl:attribute name="multiple_value" select="true()"/>
				</xsl:if>
				<xsl:variable name="emitted_value">
					<xsl:choose>
						<xsl:when test="$field/map">
							<xsl:value-of select="$field/map/entry[@key=$value]/text()"/>
						</xsl:when>
						<xsl:when test="$field/validator[@pattern='true']">
							<xsl:if test="normalize-space(text())">
								<xsl:analyze-string select="text()" regex="{$field/validator[@pattern='true']/@regexp}">
									<xsl:matching-substring>
										<xsl:value-of select="regex-group(1)"/>
									</xsl:matching-substring>
								</xsl:analyze-string>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$value_with_elements[element()]">
									<xsl:copy-of select="$value_with_elements"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$value"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$multiple_value">
						<xsl:element name="value">
							<xsl:copy-of select="$emitted_value"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="''!=$emitted_value">
						<xsl:copy-of select="$emitted_value"/>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:emit_special_table_processing_error" as="element()">
		<xsl:param name="validator" as="element()"/>
		<xsl:param name="field" as="element()"/>
		<xsl:param name="nodes" as="node()*"/>
		<xsl:element name="error">
			<xsl:attribute name="type" select="$validator/@error_key"/>
			<xsl:copy-of select="$nodes"/>
			<xsl:element name="field_name">
				<xsl:value-of select="$field/name/text()"/>
			</xsl:element>
			<xsl:copy-of select="$validator/element()" copy-namespaces="no"/>
		</xsl:element>
	</xsl:function>
	<xsl:template match="w:tc|w:p" mode="TEXTBOX_WITH_MATHML">
		<xsl:apply-templates select="node()" mode="TEXTBOX_WITH_MATHML"/>
	</xsl:template>
	<xsl:template match="w:t[not(preceding-sibling::w:rPr) or not(preceding-sibling::w:rPr/w:rStyle) or not(some $x in $MS_WORD_STYLES/style[@key='substitute_text']/name/text() satisfies preceding-sibling::w:rPr/w:rStyle/@w:val=$x)]" mode="TEXTBOX_WITH_MATHML">
		<xsl:value-of select="text()"/>
	</xsl:template>
	<xsl:template match="m:oMath" mode="TEXTBOX_WITH_MATHML">
		<xsl:apply-templates select="." mode="EPXML_OUTPUT">
			<xsl:with-param name="para_context">
				<dummy>
					<w:t>dummy</w:t>
				</dummy>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
