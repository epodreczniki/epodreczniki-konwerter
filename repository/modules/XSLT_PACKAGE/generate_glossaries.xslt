<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 1.1 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:db="http://docbook.org/ns/docbook" xmlns:cnxml="http://cnx.rice.edu/cnxml" xmlns:md="http://cnx.rice.edu/mdml" xmlns:q="http://cnx.rice.edu/qml/1.0" xmlns:bib="http://bibtexml.sf.net/" xmlns:ep="http://epodreczniki.pl/" xmlns:epconvert="http://epodreczniki.pl/convert" exclude-result-prefixes="epconvert xs fn db">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="mode" select="'DOCBOOK'"/>
	<xsl:param name="type" select="'bibliography'"/>
	<xsl:param name="id" select="'NOWE_ID'"/>
	<xsl:variable name="REPO_DOMAIN" select="document('config.xml')/config/repoDomain/text()"/>
	<xsl:variable name="L" as="element()">
		<locales>
			<GLOSSARY_TITLE>Słowniczek</GLOSSARY_TITLE>
			<CONCEPT_TITLE>Pojęcia</CONCEPT_TITLE>
			<BIOGRAPHY_TITLE>Biogramy</BIOGRAPHY_TITLE>
			<EVENT_TITLE>Wydarzenia</EVENT_TITLE>
			<BIBLIOGRAPHY_TITLE>Bibliografia</BIBLIOGRAPHY_TITLE>
		</locales>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$mode='DOCBOOK'">
				<xsl:variable name="content">
					<xsl:apply-templates select="referencable" mode="DOCBOOK_OUTPUT"/>
				</xsl:variable>
				<xsl:apply-templates select="$content" mode="ADD_PROCESSING_INSTRUCTIONS"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="referencable" mode="EPXML_OUTPUT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="referencable" mode="EPXML_OUTPUT">
		<document xmlns:cnxml="http://cnx.rice.edu/cnxml" xmlns:md="http://cnx.rice.edu/mdml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:q="http://cnx.rice.edu/qml/1.0" xmlns:bib="http://bibtexml.sf.net/" xmlns:ep="http://epodreczniki.pl/" xmlns="http://cnx.rice.edu/cnxml" xmlns:mml="http://www.w3.org/1998/Math/MathML" id="{$id}" module-id="{$id}" cnxml-version="0.7">
			<title>
				<xsl:value-of select="$L/element()[local-name()=concat(upper-case($type),'_TITLE')]"/>
			</title>
			<metadata mdml-version="0.5">
				<md:content-id>
					<xsl:value-of select="$id"/>
				</md:content-id>
				<md:repository>https://<xsl:value-of select="$REPO_DOMAIN"/>/</md:repository>
				<md:version>1</md:version>
				<md:created>
					<xsl:value-of select="format-dateTime(adjust-dateTime-to-timezone(current-dateTime(),timezone-from-dateTime(current-dateTime())),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
				</md:created>
				<md:revised>
					<xsl:value-of select="format-dateTime(adjust-dateTime-to-timezone(current-dateTime(),timezone-from-dateTime(current-dateTime())),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
				</md:revised>
				<md:title>
					<xsl:value-of select="$L/element()[local-name()=concat(upper-case($type),'_TITLE')]"/>
				</md:title>
				<md:language>pl-PL</md:language>
				<md:license url="http://creativecommons.org/licenses/by/3.0/pl/legalcode">CC BY 3.0</md:license>
				<ep:e-textbook-module ep:version="1.5" ep:recipient="student" ep:content-status="canon">
					<ep:generated-type>
						<xsl:value-of select="$type"/>
					</ep:generated-type>
					<ep:presentation>
						<ep:numbering>skip</ep:numbering>
						<ep:type>EP_technical_module_<xsl:value-of select="$type"/>
						</ep:type>
						<ep:template>linear</ep:template>
					</ep:presentation>
				</ep:e-textbook-module>
			</metadata>
			<xsl:choose>
				<xsl:when test="some $x in ('glossary','biography','event','concept') satisfies $type=$x">
					<content>
						<section id="{concat($id,'_ms')}">
							<xsl:variable name="sorted_elements" as="element()">
								<sorted_elements>
									<xsl:choose>
										<xsl:when test="$type='glossary'">
											<xsl:for-each select="//definition[@global-id]|//rule[@global-id]">
												<xsl:sort select="string-join(text(),'')" lang="pl"/>
												<xsl:copy-of select="."/>
											</xsl:for-each>
										</xsl:when>
										<xsl:when test="$type='concept'">
											<xsl:for-each select="//concept[@global-id]">
												<xsl:sort select="string-join(text(),'')" lang="pl"/>
												<xsl:copy-of select="."/>
											</xsl:for-each>
										</xsl:when>
										<xsl:when test="$type='biography'">
											<xsl:for-each select="//biography[@global-id]">
												<xsl:sort select="@sorting-key" lang="pl"/>
												<xsl:copy-of select="."/>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="//event[@global-id]">
												<xsl:sort select="string-join(text(),'')" lang="pl"/>
												<xsl:copy-of select="."/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</sorted_elements>
							</xsl:variable>
							<xsl:variable name="modules" as="element()">
								<modules>
									<xsl:for-each select="//module[descendant::element()[some $x in ($sorted_elements/element()/@global-id) satisfies $x=@global-id]]">
										<xsl:copy-of select="document(concat(working_path/text(),'/ooxml2epxml.xml'))"/>
									</xsl:for-each>
								</modules>
							</xsl:variable>
							<xsl:variable name="sorted_content">
								<xsl:for-each select="$sorted_elements/element()">
									<xsl:variable name="id" select="@local-id"/>
									<xsl:variable name="element" select="$modules//element()[(@id=$id or @ep:id=$id) and not(ends-with(local-name(),'reference'))]"/>
									<xsl:element name="epconvert:container">
										<xsl:attribute name="epconvert:origin" select="$element/ancestor::cnxml:document/@module-id"/>
										<xsl:copy-of select="$element"/>
									</xsl:element>
									<xsl:message terminate="no">EPK_ENTRY;;;<xsl:value-of select="text()"/>
									</xsl:message>
								</xsl:for-each>
							</xsl:variable>
							<xsl:apply-templates select="$sorted_content" mode="EPXML_OUTPUT_REINDEX_ID">
								<xsl:with-param name="prefix" tunnel="yes" select="concat($type,'_')"/>
							</xsl:apply-templates>
						</section>
					</content>
				</xsl:when>
				<xsl:otherwise>
					<content/>
					<bib:file>
						<xsl:variable name="content" as="element()">
							<content>
								<xsl:for-each select="//module[descendant::bibliography]">
									<xsl:copy-of select="document(concat(working_path/text(),'/BIBLIOGRAPHY.xml'))//bib:entry"/>
								</xsl:for-each>
							</content>
						</xsl:variable>
						<xsl:for-each select="$content/element()">
							<xsl:sort select="string-join((descendant::bib:booktitle/text(),descendant::bib:title/text()),'')" lang="pl"/>
							<xsl:copy-of select="."/>
							<xsl:message terminate="no">EPK_ENTRY;;;<xsl:value-of select="ep:target-name"/>
							</xsl:message>
						</xsl:for-each>
					</bib:file>
				</xsl:otherwise>
			</xsl:choose>
		</document>
	</xsl:template>
	<xsl:template match="cnxml:link" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:element name="link" namespace="{namespace-uri()}">
			<xsl:if test="not(@document)">
				<xsl:attribute name="document" select="ancestor::epconvert:container/@epconvert:origin"/>
			</xsl:if>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="node()" mode="EPXML_OUTPUT_REINDEX_ID"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="element()" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:apply-templates select="@*|node()" mode="EPXML_OUTPUT_REINDEX_ID"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="epconvert:container" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:apply-templates select="node()" mode="EPXML_OUTPUT_REINDEX_ID"/>
	</xsl:template>
	<xsl:template match="ep:biography-reference|ep:event-reference|ep:glossary-reference|ep:concept-reference|ep:bibliography-reference" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:param name="prefix" tunnel="yes"/>
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:choose>
				<xsl:when test="starts-with(local-name(),$type)">
					<xsl:choose>
						<xsl:when test="starts-with(@ep:id,$type)">
							<xsl:copy-of select="@ep:id"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ep:id" select="concat($prefix,@ep:id)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="ep:local-reference" select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="reference_type" select="substring-before(local-name(),'-reference')"/>
					<xsl:choose>
						<xsl:when test="starts-with(@ep:id,$reference_type)">
							<xsl:copy-of select="@ep:id"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ep:id" select="concat($reference_type,'_',@ep:id)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="ep:local-reference" select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@*[not(some $x in ('id','local-reference') satisfies local-name()=$x)]" mode="EPXML_OUTPUT_REINDEX_ID"/>
			<xsl:apply-templates select="node()" mode="EPXML_OUTPUT_REINDEX_ID"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:param name="prefix" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="local-name()='id' or name()='ep:instance-id'">
				<xsl:choose>
					<xsl:when test="local-name(parent::element())!='reference' or name()='ep:instance-id'">
						<xsl:attribute name="{name()}" select="concat($prefix,.)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()" mode="EPXML_OUTPUT_REINDEX_ID">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="referencable" mode="DOCBOOK_OUTPUT" exclude-result-prefixes="bib cnxml ep fn md q xs epconvert">
		<article lang="pl">
			<title>
				<xsl:value-of select="$L/element()[local-name()=concat(upper-case($type),'_TITLE')]"/>
			</title>
			<epconvert:PROC>dbfo-need  height="6in"</epconvert:PROC>
			<para/>
			<section role="NIT">
				<title>Właściwości modułu treści e-podręcznika</title>
				<para>
					<table rowheader="firstcol">
						<tgroup cols="2">
							<colspec colname="c1" colwidth="1*"/>
							<colspec colname="c2" colwidth="3*"/>
							<tbody>
								<row>
									<entry namest="c1" nameend="c2" align="center">
										<epconvert:PROC>dbfo bgcolor="#00DDDD"</epconvert:PROC>MODUŁ SŁOWNIKOWY WYGENEROWANY PODCZAS KONWERSJI E-PODRĘCZNIKA</entry>
								</row>
								<row>
									<entry namest="c1" nameend="c2" align="center">
										<epconvert:PROC>dbfo bgcolor="#DDDDDD"</epconvert:PROC>Informacje podstawowe</entry>
								</row>
								<row>
									<entry>Tytuł modułu: </entry>
									<entry>
										<xsl:value-of select="$L/element()[local-name()=concat(upper-case($type),'_TITLE')]"/>
									</entry>
								</row>
								<row>
									<entry>Licencja: </entry>
									<entry>
										<ulink url="http://creativecommons.org/licenses/by/3.0/pl/legalcode">Uznanie autorstwa (CC BY 3.0)</ulink>
									</entry>
								</row>
								<row>
									<entry>Data oraz czas przetworzenia: </entry>
									<entry>
										<xsl:value-of select="format-dateTime(adjust-dateTime-to-timezone(current-dateTime(),timezone-from-dateTime(current-dateTime())),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
									</entry>
								</row>
							</tbody>
						</tgroup>
					</table>
				</para>
				<epconvert:PROC>dbfo-need  height="5in"</epconvert:PROC>
			</section>
			<section role="NIT">
				<xsl:variable name="sorted_elements" as="element()">
					<sorted_elements>
						<xsl:choose>
							<xsl:when test="$type='glossary'">
								<xsl:for-each select="//definition[@global-id]|//rule[@global-id]">
									<xsl:sort select="string-join(text(),'')" lang="pl"/>
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$type='concept'">
								<xsl:for-each select="//concept[@global-id]">
									<xsl:sort select="string-join(text(),'')" lang="pl"/>
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$type='bibliography'">
								<xsl:for-each select="//bibliography">
									<xsl:sort select="string-join(@booktitle,@title)" lang="pl"/>
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="$type='biography'">
								<xsl:for-each select="//biography[@global-id]">
									<xsl:sort select="@sorting-key" lang="pl"/>
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="//event[@global-id]">
									<xsl:sort select="string-join(text(),'')" lang="pl"/>
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</sorted_elements>
				</xsl:variable>
				<xsl:variable name="modules" as="element()">
					<modules>
						<xsl:for-each select="//module[descendant::element()[some $x in ($sorted_elements/element()/@global-id) satisfies $x=@global-id]]">
							<xsl:copy-of select="document(concat(working_path/text(),'/ooxml2docbook.xml.bak'))"/>
						</xsl:for-each>
					</modules>
				</xsl:variable>
				<xsl:variable name="sorted_content">
					<xsl:for-each select="$sorted_elements/element()">
						<xsl:variable name="id" select="@local-id"/>
						<xsl:copy-of select="$modules//table[tgroup/tbody/row/entry/para/@id=$id]"/>
						<xsl:message terminate="no">EPK_ENTRY;;;<xsl:value-of select="text()"/>
						</xsl:message>
					</xsl:for-each>
				</xsl:variable>
				<xsl:apply-templates select="$sorted_content" mode="DOCBOOK_OUTPUT_REINDEX_ID">
					<xsl:with-param name="prefix" tunnel="yes" select="concat($type,'_')"/>
				</xsl:apply-templates>
			</section>
		</article>
	</xsl:template>
	<xsl:template match="link|ulink" mode="DOCBOOK_OUTPUT_REINDEX_ID">
		<xsl:apply-templates select="node()" mode="DOCBOOK_OUTPUT_REINDEX_ID"/>
	</xsl:template>
	<xsl:template match="element()" mode="DOCBOOK_OUTPUT_REINDEX_ID">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:apply-templates select="@*|node()" mode="DOCBOOK_OUTPUT_REINDEX_ID"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*" mode="DOCBOOK_OUTPUT_REINDEX_ID">
		<xsl:param name="prefix" tunnel="yes"/>
		<xsl:choose>
			<xsl:when test="local-name()='id' and local-name(parent::element())='para'">
				<xsl:attribute name="{name()}" select="concat($prefix,.)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()" mode="DOCBOOK_OUTPUT_REINDEX_ID">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="processing-instruction()" mode="DOCBOOK_OUTPUT_REINDEX_ID">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="epconvert:PROC" mode="ADD_PROCESSING_INSTRUCTIONS">
		<xsl:text disable-output-escaping="yes">&lt;?</xsl:text>
		<xsl:value-of select="text()"/>
		<xsl:text disable-output-escaping="yes">?&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="element()" mode="ADD_PROCESSING_INSTRUCTIONS">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*|node()" mode="ADD_PROCESSING_INSTRUCTIONS"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*|text()" mode="ADD_PROCESSING_INSTRUCTIONS">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="processing-instruction()" mode="ADD_PROCESSING_INSTRUCTIONS">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>
