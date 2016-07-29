<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 1.1.3 -->
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:svg="http://www.w3.org/2000/svg" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:db="http://docbook.org/ns/docbook" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:epconvert="http://epodreczniki.pl/convert" xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:cnxml="http://cnx.rice.edu/cnxml" xmlns:md="http://cnx.rice.edu/mdml" xmlns:q="http://cnx.rice.edu/qml/1.0" xmlns:bib="http://bibtexml.sf.net/" xmlns:ep="http://epodreczniki.pl/" exclude-result-prefixes="m w pic a r rels wp xlink xi svg db html epconvert cp dc dcterms dcmitype xs">
	<xsl:import href="{{OMML2MML.XSL}}"/>
	<xsl:import href="xslt/locales_and_maps.xslt"/>
	<xsl:import href="xslt/special_tables_processing.xslt"/>
	<xsl:param name="docxm_name"/>
	<xsl:param name="docxm_map_path"/>
	<xsl:param name="aggregated_referencable_elements_path" required="no"/>
	<xsl:param name="core_curriculum_map_path"/>
	<xsl:param name="docxm_working_dir_path"/>
	<xsl:param name="docxm_processing_mode"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" name="xml"/>
	<xsl:variable name="REPO_DOMAIN" select="document('xslt/config.xml')/config/repoDomain/text()"/>
	<xsl:variable name="DOCXM_MAP" select="document($docxm_map_path)"/>
	<xsl:variable name="DOCXM_MAP_MY_ENTRY" select="$DOCXM_MAP/docxm_map/entry[filename/text()=$docxm_name]"/>
	<xsl:variable name="CORE_CURRICULUM_MAP" select="document($core_curriculum_map_path)"/>
	<xsl:variable name="TEMPLATE_MAPPINGS" select="document('xslt/templateMappings.xml')/templateMappings" as="element()"/>
	<xsl:variable name="SPECIAL_TABLES_DESCRIPTORS" select="document('xslt/special_tables_descriptors.xml')/special_tables_descriptors" as="element()"/>
	<xsl:variable name="RELS" select="document(concat($docxm_working_dir_path,'/word/_rels/document.xml.rels'))"/>
	<xsl:variable name="CORE" select="document(concat($docxm_working_dir_path,'/docProps/core.xml'))"/>
	<xsl:variable name="COMMENTS_MAP" as="element()">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:copy-of select="document(concat($docxm_working_dir_path,'/../COMMENTS_MAP.xml'))/comments-map"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="comments-map">
					<xsl:apply-templates mode="COMMENTS_MAP">
						<xsl:with-param name="comments" select="document(concat($docxm_working_dir_path,'/word/comments.xml'))"/>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="PARAGRAPHS_MAP_FLAT" as="element()">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:copy-of select="document(concat($docxm_working_dir_path,'/../PARAGRAPHS_MAP_FLAT.xml'))/map"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="map">
					<xsl:apply-templates mode="PARAGRAPHS_MAP"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="GLOBAL_METADATA" as="element()">
		<global_metadata>
			<xsl:for-each select="('md:license','ep:type','ep:recipient','ep:status','md:language','ep:template','ep:grid-width','ep:grid-height','md:abstract')">
				<xsl:variable name="key" select="."/>
				<xsl:element name="{$key}">
					<xsl:copy-of select="$PARAGRAPHS_MAP_FLAT/descendant::special_table[@type='global_metadata'][1]/attribute[@key=$key]/node()"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="subtype">
				<xsl:value-of select="$PARAGRAPHS_MAP_FLAT/descendant::special_table[@type='global_metadata'][1]/@subtype"/>
			</xsl:element>
		</global_metadata>
	</xsl:variable>
	<xsl:variable name="INLINE_MARKS" select="true()"/>
	<xsl:variable name="PARAGRAPHS_MAP">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:copy-of select="document(concat($docxm_working_dir_path,'/../PARAGRAPHS_MAP.xml'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="PM">
					<xsl:copy-of select="epconvert:core-curriculum_refs_2_entries(epconvert:check_metadata_top(epconvert:map_old_core-curriculum_top(epconvert:clean_meanings_styles_top(epconvert:remove_orphan_comment_ends(epconvert:bubble_bookmarks(epconvert:check_meanings_sequences_top(epconvert:check_meanings_nesting_top(epconvert:apply_meanings_top(epconvert:apply_scopes(epconvert:group_listitems(epconvert:stick_tables_to_listitems(epconvert:check_for_empty_sections(epconvert:clear_separators(epconvert:introduct_sections(epconvert:merge_section_headers($PARAGRAPHS_MAP_FLAT))))))))))))))))"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="LISTS_MAP">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:copy-of select="document(concat($docxm_working_dir_path,'/../LISTS_MAP.xml'))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document(concat($docxm_working_dir_path,'/word/numbering.xml'))" mode="LISTS_MAP"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="REFERENCABLE_ELEMENTS" as="element()">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:element name="empty"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="referencable">
					<xsl:element name="tooltips">
						<xsl:for-each select="$PARAGRAPHS_MAP//tooltip">
							<xsl:element name="tooltip">
								<xsl:attribute name="local-id" select="epconvert:generate-id(.)"/>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="rules">
						<xsl:for-each select="$PARAGRAPHS_MAP//rule">
							<xsl:variable name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="rule">
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:if test="@glossary-declaration='true'">
									<xsl:attribute name="global-id" select="concat('glossary_',$id)"/>
								</xsl:if>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="definitions">
						<xsl:for-each select="$PARAGRAPHS_MAP//definition">
							<xsl:variable name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="definition">
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:if test="@glossary-declaration='true'">
									<xsl:attribute name="global-id" select="concat('glossary_',$id)"/>
								</xsl:if>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="concepts">
						<xsl:for-each select="$PARAGRAPHS_MAP//concept">
							<xsl:variable name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="concept">
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:if test="@glossary-declaration='true'">
									<xsl:attribute name="global-id" select="concat('concept_',$id)"/>
								</xsl:if>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="biographies">
						<xsl:for-each select="$PARAGRAPHS_MAP//biography">
							<xsl:variable name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="biography">
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:if test="@ep:glossary='true'">
									<xsl:attribute name="global-id" select="concat('biography_',$id)"/>
								</xsl:if>
								<xsl:attribute name="sorting-key"><xsl:choose><xsl:when test="@ep:sorting-key and not(''=@ep:sorting-key)"><xsl:value-of select="@ep:sorting-key"/></xsl:when><xsl:otherwise><xsl:value-of select="epconvert:select_text_for_element(name/para)"/></xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="events">
						<xsl:for-each select="$PARAGRAPHS_MAP//event">
							<xsl:variable name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="event">
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:if test="@ep:glossary='true'">
									<xsl:attribute name="global-id" select="concat('event_',$id)"/>
								</xsl:if>
								<xsl:value-of select="epconvert:select_text_for_element(name/para)"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					<xsl:element name="bibliographies">
						<xsl:for-each select="$PARAGRAPHS_MAP//special_table[@type='bibliography_entry']">
							<xsl:variable name="id" select="epconvert:generate-id(attribute[@key='id']/text())"/>
							<xsl:element name="bibliography">
								<xsl:if test="attribute[@key='display_in_module']/text()='true'">
									<xsl:attribute name="display-in-module" select="true()"/>
								</xsl:if>
								<xsl:attribute name="local-id" select="$id"/>
								<xsl:attribute name="global-id" select="concat('bibliography_',$id)"/>
								<xsl:attribute name="title" select="attribute[@key='title']/text()"/>
								<xsl:attribute name="booktitle" select="attribute[@key='booktitle']/text()"/>
								<xsl:value-of select="attribute[@key='id']/text()"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="AGGREGATED_REFERENCABLE_ELEMENTS" as="element()">
		<xsl:choose>
			<xsl:when test="some $x in ('EPXML','DOCBOOK') satisfies $docxm_processing_mode=$x">
				<xsl:copy-of select="document($aggregated_referencable_elements_path)/referencable"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="empty"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="INLINE_COMMENTS_MAP" as="element()">
		<xsl:choose>
			<xsl:when test="$docxm_processing_mode='EPXML'">
				<xsl:copy-of select="document(concat($docxm_working_dir_path,'/../INLINE_COMMENTS_MAP.xml'))/inline-comments-map"/>
			</xsl:when>
			<xsl:when test="$docxm_processing_mode='DOCBOOK'">
				<xsl:element name="inline-comments-map">
					<xsl:for-each select="$COMMENTS_MAP/comment[@INLINE_COMMENT_PROCESSING='true']">
						<xsl:choose>
							<xsl:when test="@tooltip-reference='true'">
								<xsl:variable name="name" select="tooltip-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-tooltip-id($name,())=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'tooltip_reference_to_non_existing_tooltip'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@glossary-reference='true'">
								<xsl:variable name="name" select="glossary-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-glossary-id($name)=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'glossary_reference_to_non_existing_element'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@concept-reference='true'">
								<xsl:variable name="name" select="concept-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-concept-id($name)=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'concept_reference_to_non_existing_concept'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@event-reference='true'">
								<xsl:variable name="name" select="event-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-event-id($name)=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'event_reference_to_non_existing_event'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@biography-reference='true'">
								<xsl:variable name="name" select="biography-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-biography-id($name)=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'biography_reference_to_non_existing_biography'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@bibliography-reference='true'">
								<xsl:variable name="name" select="bibliography-reference/text()"/>
								<xsl:choose>
									<xsl:when test="epconvert:resolve-bibliography-id($name)=''">
										<xsl:element name="comment">
											<xsl:copy-of select="@*"/>
											<xsl:element name="error">
												<xsl:attribute name="type" select="'bibliography_reference_to_non_existing_bibliography'"/>
												<xsl:value-of select="$name"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="empty"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="OUTPUT_MODES">
		<epconvert:DOCBOOK_OUTPUT/>
		<epconvert:EPXML_OUTPUT/>
	</xsl:variable>
	<xsl:variable name="ROOT" select="/"/>
	<xsl:template match="/">
		<xsl:if test="$docxm_processing_mode='MODEL'">
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../COMMENTS_MAP.xml')}" format="xml">
				<xsl:copy-of select="$COMMENTS_MAP"/>
			</xsl:result-document>
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../PARAGRAPHS_MAP_FLAT.xml')}" format="xml">
				<xsl:copy-of select="$PARAGRAPHS_MAP_FLAT"/>
			</xsl:result-document>
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../PARAGRAPHS_MAP.xml')}" format="xml">
				<xsl:copy-of select="$PARAGRAPHS_MAP"/>
			</xsl:result-document>
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../LISTS_MAP.xml')}" format="xml">
				<xsl:copy-of select="$LISTS_MAP"/>
			</xsl:result-document>
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../REFERENCABLE_ELEMENTS.xml')}" format="xml">
				<xsl:copy-of select="$REFERENCABLE_ELEMENTS"/>
			</xsl:result-document>
		</xsl:if>
		<xsl:if test="$docxm_processing_mode='DOCBOOK'">
			<xsl:result-document href="{concat($docxm_working_dir_path,'/../INLINE_COMMENTS_MAP.xml')}" format="xml">
				<xsl:copy-of select="$INLINE_COMMENTS_MAP"/>
			</xsl:result-document>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$docxm_processing_mode='DOCBOOK'">
				<xsl:apply-templates select="epconvert:process($PARAGRAPHS_MAP/element(),'DOCBOOK_OUTPUT')" mode="ADD_PROCESSING_INSTRUCTIONS" exclude-result-prefixes="cnxml md q ep"/>
			</xsl:when>
			<xsl:when test="$docxm_processing_mode='EPXML'">
				<xsl:copy-of select="epconvert:process($PARAGRAPHS_MAP/element(),'EPXML_OUTPUT')" exclude-result-prefixes="db html"/>
				<xsl:if test="$PARAGRAPHS_MAP/descendant::special_table[@type='bibliography_entry']">
					<xsl:result-document href="{concat($docxm_working_dir_path,'/../BIBLIOGRAPHY.xml')}" format="xml">
						<xsl:element name="bib:file" namespace="http://bibtexml.sf.net/">
							<xsl:namespace name="ep" select="'http://epodreczniki.pl/'"/>
							<xsl:namespace name="bib" select="'http://bibtexml.sf.net/'"/>
							<xsl:apply-templates select="$PARAGRAPHS_MAP/descendant::special_table[@type='bibliography_entry']" mode="EPXML_OUTPUT">
								<xsl:with-param name="global-ids" tunnel="yes" select="true()"/>
							</xsl:apply-templates>
						</xsl:element>
					</xsl:result-document>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="empty"/>
			</xsl:otherwise>
		</xsl:choose>
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
	<xsl:function name="epconvert:process">
		<xsl:param name="element" as="element()"/>
		<xsl:param name="mode"/>
		<xsl:for-each-group select="$element/*" group-starting-with="separator">
			<xsl:choose>
				<xsl:when test="local-name(current-group()[1])='bookmark'">
					<xsl:apply-templates select="$OUTPUT_MODES/element()[local-name()=$mode]">
						<xsl:with-param name="elements" select="current-group()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="current-group()[@special_block='true' or (some $x in ('map','module','header1','header2','header3') satisfies local-name()=$x)]">
					<xsl:apply-templates select="$OUTPUT_MODES/element()[$mode=local-name()]">
						<xsl:with-param name="elements" select="current-group()"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="current-group()[some $x in ('para','table','WOMI','list','error','warn') satisfies local-name()=$x]">
					<xsl:variable name="group">
						<group>
							<xsl:copy-of select="current-group()"/>
						</group>
					</xsl:variable>
					<xsl:apply-templates select="$OUTPUT_MODES/element()[$mode=local-name()]">
						<xsl:with-param name="elements" select="$group"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="current-group()[local-name()='special_table']"/>
				<xsl:when test="current-group()[local-name()='global_errors']"/>
				<xsl:when test="1=count(current-group()) and current-group()[local-name()='separator']"/>
				<xsl:otherwise>
					<ERROR>
						<xsl:copy-of select="current-group()"/>
					</ERROR>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:function>
	<xsl:function name="epconvert:select_element_for_processing">
		<xsl:param name="number"/>
		<xsl:copy-of select="$ROOT/w:document/w:body/w:*[some $x in ('p','tbl') satisfies local-name()=$x][number($number)]"/>
	</xsl:function>
	<xsl:function name="epconvert:select_text_for_element">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="$element/@position_start">
				<xsl:for-each select="$element/@position_start to $element/@position_end">
					<xsl:copy-of select="epconvert:select_element_for_processing(.)//w:t[not(ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKomentarzedycyjny')]/text()"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$element/@position">
				<xsl:copy-of select="epconvert:select_element_for_processing($element/@position)//w:t[not(ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKomentarzedycyjny')]/text()"/>
			</xsl:when>
			<xsl:otherwise>
				<ERROR/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template match="epconvert:DOCBOOK_OUTPUT">
		<xsl:param name="elements" as="node()*"/>
		<xsl:apply-templates select="$elements" mode="DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template match="map" mode="DOCBOOK_OUTPUT" priority="1">
		<article lang="pl">
			<title>
				<xsl:if test="module[1]">
					<xsl:value-of select="epconvert:select_text_for_element(module[1])"/>
				</xsl:if>
			</title>
			<epconvert:PROC>dbfo-need  height="6in"</epconvert:PROC>
			<para/>
			<section role="NIT">
				<title>
					<xsl:value-of select="$L/MODULE_PROPERTIES_TITLE"/>
				</title>
				<para>
					<xsl:apply-templates select="global_errors/*" mode="DOCBOOK_OUTPUT"/>
					<xsl:call-template name="emit_base_module_info_table_DOCBOOK_OUTPUT"/>
				</para>
				<epconvert:PROC>dbfo-need  height="5in"</epconvert:PROC>
			</section>
			<xsl:if test="//special_table[@type='bibliography_entry']">
				<section role="NIT">
					<title>
						<xsl:value-of select="$L/BIBLIOGRAPHY_TITLE"/>
					</title>
					<para>
						<xsl:value-of select="$L/BIBLIOGRAPHY_CONTENT"/>
						<xsl:apply-templates select="//special_table[@type='bibliography_entry']" mode="DOCBOOK_OUTPUT"/>
					</para>
					<epconvert:PROC>dbfo-need  height="5in"</epconvert:PROC>
				</section>
			</xsl:if>
			<xsl:copy-of select="epconvert:process(.,'DOCBOOK_OUTPUT')"/>
		</article>
	</xsl:template>
	<xsl:template match="module" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:if test="element()[not(some $x in ('separator','header1') satisfies local-name()=$x)]">
			<xsl:element name="section">
				<xsl:attribute name="role" select="'NIT'"/>
				<xsl:variable name="group" as="element()">
					<xsl:element name="group">
						<xsl:copy-of select="element()[not(self::header1 or preceding-sibling::header1 or following-sibling::element()[1][local-name()='header1'])]"/>
					</xsl:element>
				</xsl:variable>
				<xsl:apply-templates select="special_table[starts-with(@type,'section_metadata_')]" mode="DOCBOOK_OUTPUT"/>
				<xsl:copy-of select="epconvert:process($group,'DOCBOOK_OUTPUT')"/>
			</xsl:element>
		</xsl:if>
		<xsl:apply-templates select="header1" mode="DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template match="header1|header2|header3" mode="DOCBOOK_OUTPUT" priority="1">
		<section>
			<title>
				<xsl:value-of select="epconvert:select_text_for_element(.)"/>
			</title>
			<xsl:apply-templates select="special_table[starts-with(@type,'section_metadata_')]" mode="DOCBOOK_OUTPUT"/>
			<xsl:copy-of select="epconvert:process(.,'DOCBOOK_OUTPUT')"/>
		</section>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_linear']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="emit_section_info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$L/SECTION_INFORMATION_TITLE_COLUMNS_TYPE"/>
			<xsl:with-param name="section_metadata" select="."/>
			<xsl:with-param name="entries">
				<row>
					<entry>
						<xsl:value-of select="$L/METADATA_SECTION_COLUMNS"/>
					</entry>
					<entry>
						<xsl:value-of select="attribute[@key='ep:columns']"/>
					</entry>
				</row>
				<xsl:if test="attribute[@key='hide-section-title']">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_HIDE_SECTION_TITLE"/>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="'true'=attribute[@key='hide-section-title']">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</row>
				</xsl:if>
				<xsl:if test="attribute[@key='ep:start-new-page']">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_START_NEW_PAGE"/>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="'true'=attribute[@key='ep:start-new-page']">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</row>
				</xsl:if>
				<xsl:if test="attribute[@key='ep:foldable']">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_FOLDABLE"/>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="'true'=attribute[@key='ep:foldable']">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</row>
				</xsl:if>
				<xsl:if test="attribute[@key='ep:recipient']/text()">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_SCOPE_RECIPIENT"/>
						</entry>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_SCOPE_RECIPIENT_TEACHER"/>
						</entry>
					</row>
				</xsl:if>
				<xsl:if test="attribute[@key='ep:status']/text()">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_SCOPE_STATUS"/>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="'expanding'=attribute[@key='ep:status']">
									<xsl:value-of select="$L/METADATA_SECTION_SCOPE_STATUS_EXPANDING"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/METADATA_SECTION_SCOPE_STATUS_SUPPLEMENTAL"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</row>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_linear_l2']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="emit_section_info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$L/SECTION_INFORMATION_TITLE_COLUMNS_TYPE_L2"/>
			<xsl:with-param name="section_metadata" select="."/>
			<xsl:with-param name="entries">
				<xsl:if test="attribute[@key='ep:width']">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_COLUMN_WIDTH"/>
						</entry>
						<entry>
							<xsl:value-of select="attribute[@key='ep:width']"/>
						</entry>
					</row>
				</xsl:if>
				<xsl:if test="attribute[@key='hide-section-title']">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_HIDE_SECTION_TITLE"/>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="'true'=attribute[@key='hide-section-title']">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</row>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_freeform']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="emit_section_info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$L/SECTION_INFORMATION_TITLE_FREEFORM_TYPE"/>
			<xsl:with-param name="section_metadata" select="."/>
			<xsl:with-param name="entries">
				<xsl:variable name="section_metadata" select="."/>
				<xsl:for-each select="('top','left','height','width')">
					<xsl:variable name="label_prefix" select="string-join(('METADATA_SECTION_FREEFORM', upper-case(.)),'_')"/>
					<xsl:variable name="field_name" select="string-join(('ep',.),':')"/>
					<xsl:if test="$section_metadata/attribute[@key=$field_name]">
						<row>
							<entry>
								<xsl:value-of select="$L/element()[local-name()=$label_prefix]"/>
							</entry>
							<entry>
								<xsl:value-of select="$section_metadata/attribute[@key=$field_name]"/>
							</entry>
						</row>
					</xsl:if>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_tile']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="emit_section_info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$L/SECTION_INFORMATION_TITLE_TILE_TYPE"/>
			<xsl:with-param name="section_metadata" select="."/>
			<xsl:with-param name="entries">
				<xsl:variable name="tile" select="attribute[@key='ep:tile']"/>
				<xsl:variable name="tile_name" select="$TEMPLATE_MAPPINGS/template[key=$GLOBAL_METADATA/ep:template]/tile[key=$tile]/name"/>
				<xsl:if test="$tile_name">
					<row>
						<entry>
							<xsl:value-of select="$L/METADATA_SECTION_TILE"/>
						</entry>
						<entry>
							<xsl:value-of select="$tile_name"/>
						</entry>
					</row>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="special_table[@type='bibliography_entry']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:param name="bibliography_entry" select="."/>
		<xsl:variable name="validate" select="$bibliography_entry/attribute[@key='validate']"/>
		<xsl:variable name="id" select="$bibliography_entry/attribute[@key='id']/text()"/>
		<xsl:variable name="local-id" select="epconvert:resolve-bibliography-id-local(.,preceding::special_table[@type='bibliography_entry'])"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//bibliography[@local-id=$local-id]/error" mode="DOCBOOK_OUTPUT"/>
		<table rowheader="firstcol">
			<tgroup cols="2">
				<colspec colname="c1" colwidth="1*"/>
				<colspec colname="c2" colwidth="3*"/>
				<tbody>
					<row>
						<entry namest="c1" nameend="c2" align="center">
							<para id="{$local-id}"/>
							<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
							<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY"/>
							<xsl:value-of select="$L/element()[local-name()=string-join(('BIBLIOGRAPHY_ENTRY_DISPLAY', upper-case($bibliography_entry/attribute[@key='display_in_module'])),'_')]"/>
						</entry>
					</row>
					<xsl:for-each select="$bibliography_entry/descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
						<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
							<xsl:with-param name="element" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<row>
						<entry>
							<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_TYPE"/>
						</entry>
						<entry>
							<xsl:value-of select="$L/element()[local-name()=string-join(('BIBLIOGRAPHY_ENTRY_TYPE', upper-case($validate)),'_')]"/>
						</entry>
					</row>
					<xsl:if test="$id">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_ID"/>
							</entry>
							<entry>
								<xsl:value-of select="$id"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="booktitle" select="$bibliography_entry/attribute[@key='booktitle']/text()"/>
					<xsl:if test="$booktitle">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_BOOKTITLE"/>
							</entry>
							<entry>
								<xsl:value-of select="$booktitle"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="organization" select="$bibliography_entry/attribute[@key='organization']/text()"/>
					<xsl:if test="$organization">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_ORGANIZATION"/>
							</entry>
							<entry>
								<xsl:value-of select="$organization"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="title" select="$bibliography_entry/attribute[@key='title']/text()"/>
					<xsl:if test="$title and not('book'=$validate)">
						<row>
							<entry>
								<xsl:value-of select="$L/element()[local-name()=string-join(('BIBLIOGRAPHY_ENTRY_TITLE', upper-case($validate)),'_')]"/>
							</entry>
							<entry>
								<xsl:value-of select="$title"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:if test="$bibliography_entry/element[@id='author'] and not($bibliography_entry/element[@id='author']/error)">
						<xsl:variable name="persons" select="$bibliography_entry/element[@id='author']"/>
						<xsl:variable name="multiple_values" select="if($persons/attribute[@multiple_value='true']) then true() else false()" as="xs:boolean"/>
						<row>
							<entry>
								<xsl:choose>
									<xsl:when test="$multiple_values">
										<xsl:value-of select="$L/BIBLIOGRAPHY_AUTHORS"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$L/BIBLIOGRAPHY_AUTHOR"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
							<entry>
								<xsl:choose>
									<xsl:when test="$multiple_values">
										<xsl:variable name="count" select="count($persons/attribute[@key='surname']/value)"/>
										<xsl:for-each select="1 to $count">
											<xsl:variable name="i" select="."/>
											<xsl:value-of select="$persons/attribute[@key='surname']/value[$i]"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="$persons/attribute[@key='name']/value[$i]"/>
											<xsl:if test=".!=$count">, </xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$persons/attribute[@key='surname']"/>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$persons/attribute[@key='name']"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</row>
					</xsl:if>
					<xsl:if test="$bibliography_entry/element[@id='editor'] and not($bibliography_entry/element[@id='editor']/error)">
						<xsl:variable name="persons" select="$bibliography_entry/element[@id='editor']"/>
						<xsl:variable name="multiple_values" select="if($persons/attribute[@multiple_value='true']) then true() else false()" as="xs:boolean"/>
						<row>
							<entry>
								<xsl:choose>
									<xsl:when test="$multiple_values">
										<xsl:value-of select="$L/BIBLIOGRAPHY_EDITORS"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$L/BIBLIOGRAPHY_EDITOR"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
							<entry>
								<xsl:choose>
									<xsl:when test="$multiple_values">
										<xsl:variable name="count" select="count($persons/attribute[@key='surname']/value)"/>
										<xsl:for-each select="1 to $count">
											<xsl:variable name="i" select="."/>
											<xsl:value-of select="$persons/attribute[@key='surname']/value[$i]"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="$persons/attribute[@key='name']/value[$i]"/>
											<xsl:if test=".!=$count">, </xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$persons/attribute[@key='surname']"/>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$persons/attribute[@key='name']"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="journal" select="$bibliography_entry/attribute[@key='journal']/text()"/>
					<xsl:if test="$journal">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_JOURNAL"/>
							</entry>
							<entry>
								<xsl:value-of select="$journal"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="series" select="$bibliography_entry/attribute[@key='series']/text()"/>
					<xsl:if test="$series">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_SERIES"/>
							</entry>
							<entry>
								<xsl:value-of select="$series"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="address" select="$bibliography_entry/attribute[@key='address']/text()"/>
					<xsl:if test="$address">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_ADDRESS"/>
							</entry>
							<entry>
								<xsl:value-of select="$address"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="number" select="$bibliography_entry/attribute[@key='number']/text()"/>
					<xsl:if test="$number">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_NUMBER"/>
							</entry>
							<entry>
								<xsl:value-of select="$number"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="year" select="$bibliography_entry/attribute[@key='year']/text()"/>
					<xsl:if test="$year">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_YEAR"/>
							</entry>
							<entry>
								<xsl:value-of select="$year"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="pages-start" select="$bibliography_entry/attribute[@key='pages-start']/text()"/>
					<xsl:variable name="pages-end" select="$bibliography_entry/attribute[@key='pages-end']/text()"/>
					<xsl:if test="$pages-start and $pages-end">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_PAGES"/>
							</entry>
							<entry>
								<xsl:value-of select="$pages-start"/> - <xsl:value-of select="$pages-end"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="howpublished" select="$bibliography_entry/attribute[@key='howpublished']/text()"/>
					<xsl:if test="$howpublished">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_HOWPUBLISHED"/>
							</entry>
							<entry>
								<ulink url="{$howpublished}">
									<xsl:value-of select="$howpublished"/>
								</ulink>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="key" select="$bibliography_entry/attribute[@key='key']/text()"/>
					<xsl:if test="$key">
						<row>
							<entry>
								<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_KEY"/>
							</entry>
							<entry>
								<xsl:value-of select="$key"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:variable name="edition" select="$bibliography_entry/attribute[@key='edition']/text()"/>
					<xsl:variable name="note" select="$bibliography_entry/attribute[@key='note']/text()"/>
					<xsl:if test="$edition or $note">
						<row>
							<entry>
								<xsl:choose>
									<xsl:when test="$edition">
										<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_EDITION"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$L/BIBLIOGRAPHY_ENTRY_NOTE"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
							<entry>
								<xsl:variable name="date">
									<xsl:choose>
										<xsl:when test="$edition">
											<xsl:value-of select="$edition"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$note"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:analyze-string select="$date" regex="^0?(\d\d?)/0?(\d\d?)/(\d\d\d\d)$">
									<xsl:matching-substring>
										<xsl:value-of select="regex-group(1)"/>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$L/element()[local-name()=string-join(('MONTH', regex-group(2)),'_')]"/>
										<xsl:text> </xsl:text>
										<xsl:value-of select="regex-group(3)"/>
									</xsl:matching-substring>
								</xsl:analyze-string>
							</entry>
						</row>
					</xsl:if>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>
	<xsl:template match="bookmark" mode="DOCBOOK_OUTPUT" priority="1">
		<para id="{@id}"/>
	</xsl:template>
	<xsl:template match="para|table|WOMI" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:apply-templates select="bookmark" mode="DOCBOOK_OUTPUT"/>
		<xsl:apply-templates select="epconvert:select_element_for_processing(@position)" mode="DOCBOOK_OUTPUT">
			<xsl:with-param name="context" select="node()"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="list[not(@special_block='true')]" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:apply-templates select="bookmark" mode="DOCBOOK_OUTPUT"/>
		<xsl:variable name="numId" select="list_item[1]/@numId"/>
		<xsl:variable name="ilvl" select="list_item[1]/@ilvl"/>
		<xsl:variable name="lp" select="$LISTS_MAP/lists-map/list[@numId=$numId]/lvl[@ilvl=$ilvl]"/>
		<xsl:apply-templates select="$lp/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:element name="{$lp/type/text()}">
			<xsl:if test="$lp/type/text()='itemizedlist' and $lp/mark">
				<xsl:attribute name="mark" select="'none'"/>
			</xsl:if>
			<xsl:if test="$lp/type/text()='orderedlist'">
				<xsl:attribute name="numeration" select="$lp/numeration/text()"/>
				<xsl:if test="1 &lt; $lp/start/text()">
					<epconvert:PROC>dbfo start="8"</epconvert:PROC>
				</xsl:if>
				<xsl:variable name="label_letters" select="if(ends-with($lp/numeration/text(),'roman')) then 3 + string-length($lp/prefix/text())+string-length($lp/postfix/text())+string-length(string($lp/start/text() + count(listitem))) else string-length($lp/prefix/text())+string-length($lp/postfix/text())+string-length(string($lp/start/text() + count(listitem)))"/>
				<xsl:variable name="label_width" select="if(2 &lt; $label_letters) then $label_letters * 0.08 else 0.15"/>
				<epconvert:PROC>dbfo label-width="<xsl:value-of select="$label_width"/>in"</epconvert:PROC>
			</xsl:if>
			<xsl:for-each select="element()">
				<xsl:apply-templates select="." mode="DOCBOOK_OUTPUT">
					<xsl:with-param name="mark" select="$lp/mark/text()"/>
					<xsl:with-param name="prefix" select="$lp/prefix/text()"/>
					<xsl:with-param name="postfix" select="$lp/postfix/text()"/>
					<xsl:with-param name="start">
						<xsl:if test="$lp/type/text()='orderedlist' and 1=position() and 1 &lt; $lp/start/text()">
							<xsl:value-of select="$lp/start/text()"/>
						</xsl:if>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="list_item" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:param name="mark"/>
		<xsl:param name="prefix"/>
		<xsl:param name="postfix"/>
		<xsl:param name="start"/>
		<xsl:element name="listitem">
			<xsl:if test="$prefix!=''">
				<xsl:attribute name="prefix" select="$prefix"/>
			</xsl:if>
			<xsl:if test="$postfix!=''">
				<xsl:attribute name="postfix" select="$postfix"/>
			</xsl:if>
			<xsl:if test="$start!=''">
				<xsl:attribute name="override" select="$start"/>
			</xsl:if>
			<xsl:element name="para">
				<xsl:if test="$mark!=''">
					<emphasis>
						<xsl:value-of select="$mark"/>
					</emphasis>
				</xsl:if>
				<xsl:apply-templates select="bookmark" mode="DOCBOOK_OUTPUT"/>
				<xsl:apply-templates select="epconvert:select_element_for_processing(@position)" mode="DOCBOOK_OUTPUT">
					<xsl:with-param name="context" select="node()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="element()[some $x in ('WOMI','table','para') satisfies $x=local-name()]" mode="DOCBOOK_OUTPUT"/>
				<xsl:if test="element()[local-name()='list_item']">
					<xsl:variable name="list">
						<xsl:element name="list">
							<xsl:copy-of select="element()[local-name()='list_item']"/>
						</xsl:element>
					</xsl:variable>
					<xsl:apply-templates select="$list" mode="DOCBOOK_OUTPUT"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="error|warn" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="type" select="@type"/>
		<xsl:variable name="entry" select="if($DI/entry[@key=$type]) then $DI/entry[@key=$type] else $DI/entry[@key='DEFAULT']"/>
		<xsl:variable name="tokens">
			<xsl:call-template name="get_issue_tokens">
				<xsl:with-param name="type">
					<xsl:value-of select="$entry/@key"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="$tokens/element()">
					<xsl:apply-templates select="$entry/PATTERN" mode="GENERATE_ISSUE_DESCRIPTION">
						<xsl:with-param name="tokens" select="$tokens"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$entry/PATTERN/node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="local-name()='error'">
				<xsl:call-template name="error_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:value-of select="$entry/TITLE"/>
					</xsl:with-param>
					<xsl:with-param name="text">
						<xsl:copy-of select="$description"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="warn_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:value-of select="$entry/TITLE"/>
					</xsl:with-param>
					<xsl:with-param name="text">
						<xsl:copy-of select="$description"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="epconvert:token" mode="GENERATE_ISSUE_DESCRIPTION" priority="1">
		<xsl:param name="tokens"/>
		<xsl:variable name="number" select="@number"/>
		<xsl:copy-of select="$tokens/element()[position() = $number]/(element()|text())"/>
	</xsl:template>
	<xsl:template match="emphasis" mode="GENERATE_ISSUE_DESCRIPTION" priority="1">
		<xsl:param name="tokens"/>
		<xsl:element name="emphasis">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="GENERATE_ISSUE_DESCRIPTION">
				<xsl:with-param name="tokens" select="$tokens"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="text()" mode="GENERATE_ISSUE_DESCRIPTION">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="element()[local-name()!='PATTERN']" mode="GENERATE_ISSUE_DESCRIPTION">
		<xsl:element name="{local-name()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="element()|text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="group" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="style" select="element()[not(some $x in ('','normal') satisfies @style=$x)]/@style"/>
		<xsl:choose>
			<xsl:when test="$style">
				<xsl:choose>
					<xsl:when test="some $x in ('EPNotatka-wskazwka','EPNotka-wskazwka') satisfies $style=$x">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/TIP_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="some $x in ('EPNotatka-ostrzeenie','EPNotka-ostrzeenie') satisfies $style=$x">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/WARNING_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="some $x in ('EPNotatka-wane','EPNotka-wane') satisfies $style=$x">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/IMPORTANT_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPNotka-ciekawostka'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/CURIOSITY_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPNotka-zapamitaj'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/REMEMBER_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPCytatakapit'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/CITE_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPKodakapit'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/CODE_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPKomentarztechniczny'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/TECHNICAL-REMARKS_TYPE"/>
							</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:copy-of select="$L/TECHNICAL-REMARKS_DESCRIPTION/node()"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPPrzykad'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/EXAMPLE_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPPolecenie'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/COMMAND_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPLead'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/LEAD_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPIntro'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/INTRO_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPPrzygotujprzedlekcj'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/PREREQUISITE_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPNauczyszsi'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/EFFECT_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPPrzypomnijsobie'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/REVISAL_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPOdziele'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/LITERARY-WORK-DESCRIPTION_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$style='EPStreszczenie'">
						<xsl:call-template name="simple_block_table_DOCBOOK_OUTPUT">
							<xsl:with-param name="type">
								<xsl:value-of select="$L/LITERARY-WORK-SUMMARY_TYPE"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<ERROR_STYLE type="{$style}">
							<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
						</ERROR_STYLE>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<para>
					<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
				</para>
				<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="multi_para_block_DOCBOOK_OUTPUT">
		<xsl:for-each select="element()">
			<xsl:apply-templates select="." mode="DOCBOOK_OUTPUT"/>
			<xsl:if test="local-name(.)='para' and not(position()=last()) and local-name(following-sibling::element()[1])='para'">
				<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="simple_block_table_DOCBOOK_OUTPUT">
		<xsl:param name="type"/>
		<xsl:param name="description" select="''"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="entries">
				<xsl:if test="'' != $description">
					<entry>
						<xsl:copy-of select="$description"/>
					</entry>
				</xsl:if>
				<entry>
					<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="homework" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/HOMEWORK_TYPE"/>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<entry>
					<xsl:copy-of select="epconvert:process(.,'DOCBOOK_OUTPUT')"/>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="definition" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="id" select="epconvert:resolve-glossary-id-local(.,preceding::definition,'definitions')"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//definition[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/DEFINITION_TYPE"/>
				<xsl:if test="@glossary-declaration='true'">
					(<xsl:value-of select="$L/GOES_TO_GLOSSARY"/>)
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<para id="{$id}"/>
								<xsl:copy-of select="$L/DEFINITION_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='meaning'">
							<entry>
								<xsl:copy-of select="$L/DEFINITION_MEANING/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='example'">
							<entry>
								<xsl:copy-of select="$L/DEFINITION_EXAMPLE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="concept" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="id" select="epconvert:resolve-concept-id-local(.,preceding::concept)"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//concept[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/CONCEPT_TYPE"/>
				<xsl:if test="@glossary-declaration='true'">
					(<xsl:value-of select="$L/GOES_TO_GLOSSARY"/>)
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<para id="{$id}"/>
								<xsl:copy-of select="$L/CONCEPT_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='meaning'">
							<entry>
								<xsl:copy-of select="$L/CONCEPT_MEANING/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='example'">
							<entry>
								<xsl:copy-of select="$L/CONCEPT_EXAMPLE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="cite" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="type" select="@type"/>
		<xsl:variable name="readability" select="@ep:readability"/>
		<xsl:variable name="start-numbering" select="@ep:start-numbering"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/CITE_TYPE"/>
				<xsl:if test="@ep:presentation='fold'">
					<xsl:value-of select="$L/CITE_LONG"/>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<xsl:if test="$type">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/CITE_TYPE_TYPE/*"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('CITE_TYPE', upper-case($type)),'_')]"/>
					</entry>
				</xsl:if>
				<xsl:if test="$start-numbering">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/CITE_START_NUMBERING/*"/>
						<xsl:value-of select="$start-numbering"/>
					</entry>
				</xsl:if>
				<xsl:if test="$readability">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/CITE_READABILITY/*"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('CITE_READABILITY', upper-case($readability)),'_')]"/>
					</entry>
				</xsl:if>
				<xsl:for-each select="element()[some $x in ('name','author') satisfies local-name()=$x]">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<xsl:copy-of select="$L/CITE_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='author'">
							<entry>
								<xsl:copy-of select="$L/CITE_AUTHOR/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<entry>
					<xsl:copy-of select="$L/CITE_QUOTE/node()"/>
					<xsl:for-each select="element()[local-name()='content']">
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</xsl:for-each>
				</entry>
				<xsl:if test="element()[local-name()='comment']">
					<entry>
						<xsl:copy-of select="$L/CITE_COMMENT/node()"/>
						<xsl:for-each select="element()[local-name()='comment']">
							<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
						</xsl:for-each>
					</entry>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="rule" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="id" select="epconvert:resolve-glossary-id-local(.,preceding::rule,'rules')"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//rule[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/RULE_TYPE"/>
				<xsl:if test="(@type and 'lack'!=@type) or @glossary-declaration='true'">
				(<xsl:if test="@type and 'lack'!=@type">
						<xsl:value-of select="@type"/>
					</xsl:if>
					<xsl:if test="@type and 'lack'!=@type and @glossary-declaration='true'"> / </xsl:if>
					<xsl:if test="@glossary-declaration='true'">
						<xsl:value-of select="$L/GOES_TO_GLOSSARY"/>
					</xsl:if>)
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<para id="{$id}"/>
								<xsl:copy-of select="$L/RULE_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='statement'">
							<entry>
								<xsl:copy-of select="$L/RULE_STATEMENT/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='proof'">
							<entry>
								<xsl:copy-of select="$L/RULE_PROOF/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='example'">
							<entry>
								<xsl:copy-of select="$L/RULE_EXAMPLE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="exercise" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:variable name="interactivity" select="@ep:interactivity"/>
		<xsl:variable name="alternative_WOMI" select="@alternative_WOMI"/>
		<xsl:variable name="exercise_subtype" select="@exercise_subtype"/>
		<xsl:variable name="effect-of-education" select="@effect-of-education"/>
		<xsl:variable name="on-paper" select="@ep:on-paper"/>
		<xsl:variable name="type" select="@type"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/EXERCISE_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/EXERCISE_CONTEXT_INDEPENDEND/*"/>
					<xsl:choose>
						<xsl:when test="$context-dependent='true'">
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<xsl:if test="'' != $interactivity">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/EXERCISE_INTERACTIVITY_LEVEL/*"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('EXERCISE_INTERACTIVITY_LEVEL', upper-case($interactivity)),'_')]"/>
					</entry>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$exercise_subtype='MAT'">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/EXERCISE_EFFECT_OF_EDUCATION/*"/>
							<xsl:value-of select="$effect-of-education"/>
						</entry>
						<xsl:if test="'' != $on-paper">
							<entry>
								<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
								<xsl:copy-of select="$L/EXERCISE_ON_PAPER/*"/>
								<xsl:choose>
									<xsl:when test="$on-paper='true'">
										<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$exercise_subtype='JPOL3'">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/EXERCISE_DIFFICULTY_LEVEL/*"/>
							<xsl:value-of select="$L/element()[local-name()=string-join(('EXERCISE_DIFFICULTY_LEVEL', upper-case($effect-of-education)),'_')]"/>
						</entry>
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/EXERCISE_TYPE_TYPE/*"/>
							<xsl:value-of select="$L/element()[local-name()=string-join(('EXERCISE_TYPE', upper-case($type)),'_')]"/>
						</entry>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$alternative_WOMI">
					<entry>
						<xsl:copy-of select="$L/EXERCISE_ALTERNATIVE_WOMI/*"/>
						<xsl:call-template name="womi_DOCBOOK_OUTPUT">
							<xsl:with-param name="title">
								<xsl:value-of select="$L/WOMI_ID"/>
								<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
									<xsl:with-param name="id" select="$alternative_WOMI"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="entries" as="element()">
								<entries>
									<entry>
										<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
										<xsl:value-of select="$L/WOMI_TYPE_OINT"/>
									</entry>
								</entries>
							</xsl:with-param>
						</xsl:call-template>
					</entry>
				</xsl:if>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='problem'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_PROBLEM/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='tip'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_TIP/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='solution'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_SOLUTION/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='commentary'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_COMMENTARY/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='example'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_EXAMPLE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="exercise_WOMI" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:variable name="exercise_subtype" select="@exercise_subtype"/>
		<xsl:variable name="effect-of-education" select="@effect-of-education"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/EXERCISE_WOMI_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/EXERCISE_CONTEXT_INDEPENDEND/*"/>
					<xsl:choose>
						<xsl:when test="$context-dependent='true'">
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<xsl:if test="$exercise_subtype='MAT'">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/EXERCISE_EFFECT_OF_EDUCATION/*"/>
						<xsl:value-of select="$effect-of-education"/>
					</entry>
				</xsl:if>
				<entry>
					<xsl:call-template name="womi_DOCBOOK_OUTPUT">
						<xsl:with-param name="title">
							<xsl:value-of select="$L/WOMI_ID"/>
							<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
								<xsl:with-param name="id" select="@WOMI_id"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="entries" as="element()">
							<entries>
								<entry>
									<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
									<xsl:value-of select="$L/WOMI_TYPE_OINT"/>
								</entry>
							</entries>
						</xsl:with-param>
					</xsl:call-template>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="exercise_set" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/EXERCISE_SET_TYPE"/>
			<xsl:with-param name="entries">
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='command'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_SET_COMMAND/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='WOMI_exercise'">
							<entry>
								<xsl:copy-of select="$L/EXERCISE_SET_WOMI_EXERCISE/node()"/>
								<xsl:call-template name="womi_DOCBOOK_OUTPUT">
									<xsl:with-param name="title">
										<xsl:value-of select="$L/WOMI_ID"/>
										<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
											<xsl:with-param name="id" select="@id"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="entries" as="element()">
										<entries>
											<entry>
												<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
												<xsl:value-of select="$L/WOMI_TYPE_OINT"/>
											</entry>
										</entries>
									</xsl:with-param>
								</xsl:call-template>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="command" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/COMMAND_TYPE"/>
			<xsl:with-param name="entries">
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='problem'">
							<entry>
								<xsl:copy-of select="$L/COMMAND_PROBLEM/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='note'">
							<xsl:variable name="type" select="@type"/>
							<entry>
								<xsl:copy-of select="$L/element()[local-name()=string-join(('COMMAND_NOTE',upper-case($type)),'_')]/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="list[@special_block='true']" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/LIST_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:copy-of select="$L/LIST_NAME/node()"/>
					<xsl:apply-templates select="element()[local-name()='name']/element()" mode="DOCBOOK_OUTPUT"/>
				</entry>
				<entry>
					<xsl:copy-of select="$L/LIST_LIST/node()"/>
					<xsl:variable name="list">
						<xsl:element name="list">
							<xsl:copy-of select="attribute()[local-name()!='special_block']"/>
							<xsl:copy-of select="element()"/>
						</xsl:element>
					</xsl:variable>
					<xsl:apply-templates select="$list" mode="DOCBOOK_OUTPUT"/>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="codeblock" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/CODEBLOCK_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:copy-of select="$L/CODEBLOCK_LANGUAGE/node()"/>
					<xsl:value-of select="@language"/>
				</entry>
				<xsl:if test="element()[local-name()='name']">
					<entry>
						<xsl:copy-of select="$L/CODEBLOCK_NAME/node()"/>
						<xsl:apply-templates select="element()[local-name()='name']/element()" mode="DOCBOOK_OUTPUT"/>
					</entry>
				</xsl:if>
				<entry>
					<xsl:copy-of select="$L/CODEBLOCK_CODE/node()"/>
					<xsl:for-each select="element()[not(local-name()='name')]">
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</xsl:for-each>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="tooltip" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="type" select="@ep:type"/>
		<xsl:variable name="id" select="epconvert:resolve-tooltip-id(epconvert:select_text_for_element(element()[local-name()='name']/para), preceding::tooltip)"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//tooltip[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/TOOLTIP_TYPE"/>
			<xsl:with-param name="entries">
				<xsl:if test="$type">
					<entry>
						<para id="{$id}"/>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/TOOLTIP_TYPE_TYPE/*"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('TOOLTIP_TYPE', upper-case($type)),'_')]"/>
					</entry>
				</xsl:if>
				<entry>
					<xsl:copy-of select="$L/TOOLTIP_NAME/node()"/>
					<xsl:apply-templates select="element()[local-name()='name']/element()" mode="DOCBOOK_OUTPUT"/>
				</entry>
				<entry>
					<xsl:copy-of select="$L/TOOLTIP_CONTENT/node()"/>
					<xsl:for-each select="content">
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</xsl:for-each>
				</entry>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="procedure-instructions" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/PROCEDURE-INSTRUCTIONS_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:copy-of select="$L/PROCEDURE-INSTRUCTIONS_NAME/node()"/>
					<xsl:apply-templates select="element()[local-name()='name']/element()" mode="DOCBOOK_OUTPUT"/>
				</entry>
				<xsl:for-each select="element()[not(local-name()='name')]">
					<entry>
						<xsl:copy-of select="$L/PROCEDURE-INSTRUCTIONS_STEP/node()"/>
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</entry>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="quiz" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="quiz_type" select="@quiz_type"/>
		<xsl:variable name="quiz_variant" select="@quiz_variant"/>
		<xsl:variable name="behaviour" select="@ep:behaviour"/>
		<xsl:variable name="presented-answers" select="@ep:presented-answers"/>
		<xsl:variable name="correct-in-set-min" select="@ep:correct-in-set-min"/>
		<xsl:variable name="correct-in-set-max" select="@ep:correct-in-set-max"/>
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:variable name="alternative_WOMI" select="@alternative_WOMI"/>
		<xsl:variable name="quiz_subtype" select="@quiz_subtype"/>
		<xsl:variable name="effect-of-education" select="@effect-of-education"/>
		<xsl:variable name="type" select="@type"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/QUIZ_TYPE"/>
				(<xsl:value-of select="$L/element()[local-name()=string-join(('QUIZ_TYPE', upper-case($quiz_type)),'_')]"/>
				<xsl:if test="''!=$quiz_variant">
					<xsl:value-of select="$L/QUIZ_TYPE_RANDOM"/>
				</xsl:if>)
			</xsl:with-param>
			<xsl:with-param name="entries">
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/QUIZ_CONTEXT_INDEPENDEND/*"/>
					<xsl:choose>
						<xsl:when test="$context-dependent='true'">
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<xsl:choose>
					<xsl:when test="$quiz_subtype='MAT'">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/QUIZ_EFFECT_OF_EDUCATION/*"/>
							<xsl:value-of select="$effect-of-education"/>
						</entry>
					</xsl:when>
					<xsl:when test="$quiz_subtype='JPOL3'">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/QUIZ_DIFFICULTY_LEVEL/*"/>
							<xsl:value-of select="$L/element()[local-name()=string-join(('QUIZ_DIFFICULTY_LEVEL', upper-case($effect-of-education)),'_')]"/>
						</entry>
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/QUIZ_TYPE_TYPE/*"/>
							<xsl:value-of select="$L/element()[local-name()=string-join(('QUIZ_TYPE', upper-case($type)),'_')]"/>
						</entry>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$alternative_WOMI">
					<entry>
						<xsl:copy-of select="$L/QUIZ_ALTERNATIVE_WOMI/*"/>
						<xsl:call-template name="womi_DOCBOOK_OUTPUT">
							<xsl:with-param name="title">
								<xsl:value-of select="$L/WOMI_ID"/>
								<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
									<xsl:with-param name="id" select="$alternative_WOMI"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="entries" as="element()">
								<entries>
									<entry>
										<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
										<xsl:value-of select="$L/WOMI_TYPE_OINT"/>
									</entry>
								</entries>
							</xsl:with-param>
						</xsl:call-template>
					</entry>
				</xsl:if>
				<xsl:if test="some $x in ('ZJ-1','ZW-1','ZW-2') satisfies $x=$quiz_variant">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/QUIZ_VARIANT/node()"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('QUIZ_VARIANT',upper-case($quiz_variant)),'_')]"/>
					</entry>
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/QUIZ_BEHAVIOUR/node()"/>
						<xsl:value-of select="$L/element()[local-name()=string-join(('QUIZ_BEHAVIOUR',upper-case($behaviour)),'_')]"/>
					</entry>
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/PRESENTED_ANSERS/node()"/>
						<xsl:value-of select="$presented-answers"/>
					</entry>
					<xsl:if test="'randomize'=$behaviour and 'ZJ-1'!=$quiz_variant">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/CORRECT_ANSERS/node()"/>
							<xsl:choose>
								<xsl:when test="$correct-in-set-min=$correct-in-set-max">
									<xsl:value-of select="$correct-in-set-min"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$correct-in-set-min"/> - <xsl:value-of select="$correct-in-set-max"/>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</xsl:if>
				</xsl:if>
				<xsl:if test="name">
					<entry>
						<xsl:copy-of select="$L/QUIZ_NAME/node()"/>
						<xsl:apply-templates select="name/element()" mode="DOCBOOK_OUTPUT"/>
					</entry>
				</xsl:if>
				<entry>
					<xsl:copy-of select="$L/QUIZ_QUESTION/node()"/>
					<xsl:for-each select="question">
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</xsl:for-each>
				</entry>
				<xsl:if test="some $x in ('ZJ-1','ZW-1','ZW-2') satisfies $x=$quiz_variant">
					<entry>
						<xsl:copy-of select="$L/QUIZ_ANSWERS/node()"/>
						<xsl:choose>
							<xsl:when test="answer-set">
								<xsl:choose>
									<xsl:when test="'randomize-sets'=$behaviour">
										<xsl:call-template name="answer-set_DOCBOOK_OUTPUT">
											<xsl:with-param name="answers" select="answer-set[1]/*"/>
											<xsl:with-param name="title" select="$L/QUIZ_ANSWERS_SET_STATIC/node()"/>
										</xsl:call-template>
										<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
										<xsl:for-each select="answer-set">
											<xsl:call-template name="answer-set_DOCBOOK_OUTPUT">
												<xsl:with-param name="answers" select="./*"/>
												<xsl:with-param name="title">
													<xsl:copy-of select="$L/QUIZ_ANSWERS_SET_DYNAMIC/node()"/>
													<xsl:value-of select="@ep:in-set"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
										<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="answer-set">
											<xsl:call-template name="answer-set_DOCBOOK_OUTPUT">
												<xsl:with-param name="answers" select="./*"/>
												<xsl:with-param name="title">
													<xsl:copy-of select="$L/QUIZ_ANSWERS_SET_ALL/node()"/>
													<xsl:value-of select="@ep:in-set"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
										<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="presented-answers" select="@ep:presented-answers"/>
								<xsl:call-template name="answer-set_DOCBOOK_OUTPUT">
									<xsl:with-param name="answers" select="answer-group[position() &lt;= $presented-answers]"/>
									<xsl:with-param name="title" select="$L/QUIZ_ANSWERS_SET_STATIC/node()"/>
								</xsl:call-template>
								<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
								<xsl:call-template name="answer-set_DOCBOOK_OUTPUT">
									<xsl:with-param name="answers" select="answer-group"/>
									<xsl:with-param name="title" select="$L/QUIZ_ANSWERS_POLL/node()"/>
								</xsl:call-template>
								<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
							</xsl:otherwise>
						</xsl:choose>
					</entry>
				</xsl:if>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='answer'">
							<entry>
								<xsl:copy-of select="$L/QUIZ_ANSWER/node()"/>
								<xsl:choose>
									<xsl:when test="@correct='true'">
										<xsl:copy-of select="$L/QUIZ_ANSWER_CORRECT/node()"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$L/QUIZ_ANSWER_INCORRECT/node()"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='hint'">
							<entry>
								<xsl:copy-of select="$L/QUIZ_HINT/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='feedback'">
							<entry>
								<xsl:copy-of select="$L/QUIZ_FEEDBACK/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='feedback_correct'">
							<entry>
								<xsl:copy-of select="$L/QUIZ_FEEDBACK_CORRECT/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='feedback_incorrect'">
							<entry>
								<xsl:copy-of select="$L/QUIZ_FEEDBACK_INCORRECT/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="answer-set_DOCBOOK_OUTPUT">
		<xsl:param name="answers" as="node()*"/>
		<xsl:param name="title"/>
		<xsl:element name="table">
			<tgroup cols="1">
				<colspec colname="c1" colwidth="1*"/>
				<xsl:if test="''!=$title">
					<thead>
						<row>
							<entry>
								<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
								<xsl:copy-of select="$title"/>
							</entry>
						</row>
					</thead>
				</xsl:if>
				<tbody>
					<xsl:for-each select="$answers[local-name()='answer-group']">
						<row>
							<xsl:call-template name="answer-group_DOCBOOK_OUTPUT"/>
						</row>
					</xsl:for-each>
				</tbody>
			</tgroup>
		</xsl:element>
	</xsl:template>
	<xsl:template name="answer-group_DOCBOOK_OUTPUT">
		<entry>
			<xsl:copy-of select="$L/QUIZ_ANSWER/node()"/>
			<xsl:choose>
				<xsl:when test="@correct='true'">
					<xsl:copy-of select="$L/QUIZ_ANSWER_CORRECT/node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$L/QUIZ_ANSWER_INCORRECT/node()"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="answer">
				<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
			</xsl:for-each>
			<xsl:for-each select="hint">
				<xsl:call-template name="br_DOCBOOK_OUTPUT"/>
				<xsl:copy-of select="$L/QUIZ_ANSWER_HINT/node()"/>
				<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
			</xsl:for-each>
		</entry>
	</xsl:template>
	<xsl:template match="experiment" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="supervised" select="@ep:supervised"/>
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/EXPERIMENT_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/EXPERIMENT_SUPERVISED/*"/>
					<xsl:choose>
						<xsl:when test="$supervised='true'">
							<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/EXPERIMENT_CONTEXT_INDEPENDEND/*"/>
					<xsl:choose>
						<xsl:when test="$context-dependent='true'">
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='problem'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_PROBLEM/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='hypothesis'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_HYPOTHESIS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='objective'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_OBJECTIVE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='instruments'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_INSTRUMENTS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='instructions'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_INSTRUCTIONS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='conclusions'">
							<entry>
								<xsl:copy-of select="$L/EXPERIMENT_CONCLUSIONS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='note'">
							<xsl:variable name="type" select="@type"/>
							<entry>
								<xsl:copy-of select="$L/element()[local-name()=string-join(('EXPERIMENT_NOTE',upper-case($type)),'_')]/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="observation" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="supervised" select="@ep:supervised"/>
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type" select="$L/OBSERVATION_TYPE"/>
			<xsl:with-param name="entries">
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/OBSERVATION_SUPERVISED/*"/>
					<xsl:choose>
						<xsl:when test="$supervised='true'">
							<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<entry>
					<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
					<xsl:copy-of select="$L/OBSERVATION_CONTEXT_INDEPENDEND/*"/>
					<xsl:choose>
						<xsl:when test="$context-dependent='true'">
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_TRUE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$L/CONTEXT_DEPENDEND_FALSE"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='name'">
							<entry>
								<xsl:copy-of select="$L/OBSERVATION_NAME/node()"/>
								<xsl:apply-templates select="element()" mode="DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='objective'">
							<entry>
								<xsl:copy-of select="$L/OBSERVATION_OBJECTIVE/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='instruments'">
							<entry>
								<xsl:copy-of select="$L/OBSERVATION_INSTRUMENTS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='instructions'">
							<entry>
								<xsl:copy-of select="$L/OBSERVATION_INSTRUCTIONS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='conclusions'">
							<entry>
								<xsl:copy-of select="$L/OBSERVATION_CONCLUSIONS/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:when test="local-name()='note'">
							<xsl:variable name="type" select="@type"/>
							<entry>
								<xsl:copy-of select="$L/element()[local-name()=string-join(('OBSERVATION_NOTE',upper-case($type)),'_')]/node()"/>
								<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
							</entry>
						</xsl:when>
						<xsl:otherwise>
							<entry>
								<ERROR/>
							</entry>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="biography" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="biography" select="."/>
		<xsl:variable name="glossary" select="@ep:glossary"/>
		<xsl:variable name="id" select="epconvert:resolve-biography-id-local(.,preceding::biography)"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//biography[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/BIOGRAPHY_TYPE"/>
				<xsl:if test="@glossary='true'">
					(<xsl:value-of select="$L/GOES_TO_GLOSSARY"/>)
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<entry>
					<para id="{$id}"/>
					<xsl:copy-of select="$L/BIOGRAPHY_NAME/node()"/>
					<xsl:apply-templates select="name/element()" mode="DOCBOOK_OUTPUT"/>
				</entry>
				<xsl:if test="@ep:sorting-key and not(''=@ep:sorting-key)">
					<entry>
						<xsl:copy-of select="$L/BIOGRAPHY_SORTING_KEY/node()"/>
						<xsl:value-of select="@ep:sorting-key"/>
					</entry>
				</xsl:if>
				<xsl:for-each select="special_table">
					<xsl:for-each select="birth">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/BIOGRAPHY_BIRTH/*"/>
						</entry>
						<xsl:for-each select="date">
							<entry>
								<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_DATE_FORMAT/node()"/>
								<xsl:value-of select="$L/element()[local-name()=string-join(('BIOGRAPHY_BIRTH_DATE_FORMAT',upper-case($biography/@ep:birth_date_type)),'_')]/node()"/>
							</entry>
							<xsl:choose>
								<xsl:when test="$biography/@ep:birth_date_type='exact'">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_DATE/node()"/>
										<xsl:value-of select="start/day"/>/<xsl:value-of select="start/month"/>/<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('year','around-year') satisfies $x=$biography/@ep:birth_date_type">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_DATE/node()"/>
										<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="$biography/@ep:birth_date_type='century'">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_DATE_CENTURY/node()"/>
										<xsl:value-of select="$biography/@ep:birth_date_value"/>
										<xsl:if test="$biography/@ep:birth_date_era='BC'"> p.n.e. </xsl:if> (<xsl:value-of select="start/year"/> r. - <xsl:value-of select="end/year"/> r.)
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$biography/@ep:birth_date_type">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_DATE_CENTURY/node()"/>
										<xsl:value-of select="$biography/@ep:birth_date_value"/>
										<xsl:if test="$biography/@ep:birth_date_era='BC'"> p.n.e. </xsl:if>
									</entry>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="location">
							<entry>
								<xsl:copy-of select="$L/BIOGRAPHY_BIRTH_PLACE/node()"/>
								<xsl:value-of select="text()"/>
							</entry>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="death">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/BIOGRAPHY_DEATH/*"/>
						</entry>
						<xsl:for-each select="date">
							<entry>
								<xsl:copy-of select="$L/BIOGRAPHY_DEATH_DATE_FORMAT/node()"/>
								<xsl:value-of select="$L/element()[local-name()=string-join(('BIOGRAPHY_DEATH_DATE_FORMAT',upper-case($biography/@ep:death_date_type)),'_')]/node()"/>
							</entry>
							<xsl:choose>
								<xsl:when test="$biography/@ep:death_date_type='exact'">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_DEATH_DATE/node()"/>
										<xsl:value-of select="start/day"/>/<xsl:value-of select="start/month"/>/<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('year','around-year') satisfies $x=$biography/@ep:death_date_type">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_DEATH_DATE/node()"/>
										<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="$biography/@ep:death_date_type='century'">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_DEATH_DATE_CENTURY/node()"/>
										<xsl:value-of select="$biography/@ep:death_date_value"/>
										<xsl:if test="$biography/@ep:death_date_era='BC'"> p.n.e. </xsl:if> (<xsl:value-of select="start/year"/> r. - <xsl:value-of select="end/year"/> r.)
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$biography/@ep:death_date_type">
									<entry>
										<xsl:copy-of select="$L/BIOGRAPHY_DEATH_DATE_CENTURY/node()"/>
										<xsl:value-of select="$biography/@ep:death_date_value"/>
										<xsl:if test="$biography/@ep:death_date_era='BC'"> p.n.e. </xsl:if>
									</entry>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="location">
							<entry>
								<xsl:copy-of select="$L/BIOGRAPHY_DEATH_PLACE/node()"/>
								<xsl:value-of select="text()"/>
							</entry>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:call-template name="emit_WOMIs_in_biography_or_event_DOCBOOK_OUTPUT">
					<xsl:with-param name="main_title">
						<xsl:copy-of select="$L/BIOGRAPHY_MAIN_WOMI/*"/>
					</xsl:with-param>
					<xsl:with-param name="title">
						<xsl:copy-of select="$L/BIOGRAPHY_WOMI/*"/>
					</xsl:with-param>
					<xsl:with-param name="position">
						<xsl:value-of select="$biography/@biography_metadata_position"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:for-each select="content">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/BIOGRAPHY_DESCRIPTION/node()"/>
					</entry>
					<entry>
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</entry>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="event" mode="DOCBOOK_OUTPUT" priority="1">
		<xsl:variable name="event" select="."/>
		<xsl:variable name="glossary" select="@ep:glossary"/>
		<xsl:variable name="id" select="epconvert:resolve-event-id-local(.,preceding::event)"/>
		<xsl:apply-templates select="$AGGREGATED_REFERENCABLE_ELEMENTS//event[@local-id=$id]/error" mode="DOCBOOK_OUTPUT"/>
		<xsl:call-template name="special_block_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="type">
				<xsl:value-of select="$L/EVENT_TYPE"/>
				<xsl:if test="@glossary='true'">
					(<xsl:value-of select="$L/GOES_TO_GLOSSARY"/>)
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="entries">
				<entry>
					<para id="{$id}"/>
					<xsl:copy-of select="$L/EVENT_NAME/node()"/>
					<xsl:apply-templates select="name/element()" mode="DOCBOOK_OUTPUT"/>
				</entry>
				<xsl:for-each select="special_table">
					<xsl:for-each select="start">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/EVENT_START/*"/>
						</entry>
						<xsl:for-each select="date">
							<entry>
								<xsl:copy-of select="$L/EVENT_START_DATE_FORMAT/node()"/>
								<xsl:value-of select="$L/element()[local-name()=string-join(('EVENT_START_DATE_FORMAT',upper-case($event/@ep:start_date_type)),'_')]/node()"/>
							</entry>
							<xsl:choose>
								<xsl:when test="$event/@ep:start_date_type='exact'">
									<entry>
										<xsl:copy-of select="$L/EVENT_START_DATE/node()"/>
										<xsl:value-of select="start/day"/>/<xsl:value-of select="start/month"/>/<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('year','around-year') satisfies $x=$event/@ep:start_date_type">
									<entry>
										<xsl:copy-of select="$L/EVENT_START_DATE/node()"/>
										<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="$event/@ep:start_date_type='century'">
									<entry>
										<xsl:copy-of select="$L/EVENT_START_DATE_CENTURY/node()"/>
										<xsl:value-of select="$event/@ep:start_date_value"/>
										<xsl:if test="$event/@ep:start_date_era='BC'"> p.n.e. </xsl:if> (<xsl:value-of select="start/year"/> r. - <xsl:value-of select="end/year"/> r.)
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$event/@ep:start_date_type">
									<entry>
										<xsl:copy-of select="$L/EVENT_START_DATE_CENTURY/node()"/>
										<xsl:value-of select="$event/@ep:start_date_value"/>
										<xsl:if test="$event/@ep:start_date_era='BC'"> p.n.e. </xsl:if>
									</entry>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="location">
							<entry>
								<xsl:copy-of select="$L/EVENT_START_PLACE/node()"/>
								<xsl:value-of select="text()"/>
							</entry>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="end">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/EVENT_END/*"/>
						</entry>
						<xsl:for-each select="date">
							<entry>
								<xsl:copy-of select="$L/EVENT_END_DATE_FORMAT/node()"/>
								<xsl:value-of select="$L/element()[local-name()=string-join(('EVENT_END_DATE_FORMAT',upper-case($event/@ep:end_date_type)),'_')]/node()"/>
							</entry>
							<xsl:choose>
								<xsl:when test="$event/@ep:end_date_type='exact'">
									<entry>
										<xsl:copy-of select="$L/EVENT_END_DATE/node()"/>
										<xsl:value-of select="start/day"/>/<xsl:value-of select="start/month"/>/<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('year','around-year') satisfies $x=$event/@ep:end_date_type">
									<entry>
										<xsl:copy-of select="$L/EVENT_END_DATE/node()"/>
										<xsl:value-of select="start/year"/>
									</entry>
								</xsl:when>
								<xsl:when test="$event/@ep:end_date_type='century'">
									<entry>
										<xsl:copy-of select="$L/EVENT_END_DATE_CENTURY/node()"/>
										<xsl:value-of select="$event/@ep:end_date_value"/>
										<xsl:if test="$event/@ep:end_date_era='BC'"> p.n.e. </xsl:if> (<xsl:value-of select="start/year"/> r. - <xsl:value-of select="end/year"/> r.)
									</entry>
								</xsl:when>
								<xsl:when test="some $x in ('beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$event/@ep:end_date_type">
									<entry>
										<xsl:copy-of select="$L/EVENT_END_DATE_CENTURY/node()"/>
										<xsl:value-of select="$event/@ep:end_date_value"/>
										<xsl:if test="$event/@ep:end_date_era='BC'"> p.n.e. </xsl:if>
									</entry>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<xsl:for-each select="location">
							<entry>
								<xsl:copy-of select="$L/EVENT_END_PLACE/node()"/>
								<xsl:value-of select="text()"/>
							</entry>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:call-template name="emit_WOMIs_in_biography_or_event_DOCBOOK_OUTPUT">
					<xsl:with-param name="main_title">
						<xsl:copy-of select="$L/EVENT_MAIN_WOMI/*"/>
					</xsl:with-param>
					<xsl:with-param name="title">
						<xsl:copy-of select="$L/EVENT_WOMI/*"/>
					</xsl:with-param>
					<xsl:with-param name="position">
						<xsl:value-of select="$event/@event_metadata_position"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:for-each select="content">
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/EVENT_DESCRIPTION/node()"/>
					</entry>
					<entry>
						<xsl:call-template name="multi_para_block_DOCBOOK_OUTPUT"/>
					</entry>
				</xsl:for-each>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="separator" mode="DOCBOOK_OUTPUT" priority="1"/>
	<xsl:template match="w:hyperlink" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="link_id" select="@r:id"/>
		<xsl:variable name="link_anchor" select="@w:anchor"/>
		<xsl:choose>
			<xsl:when test="not($link_id)">
				<xsl:variable name="bookmark" select="$DOCXM_MAP_MY_ENTRY/bookmark[name/text()=$link_anchor]"/>
				<xsl:choose>
					<xsl:when test="$bookmark/id/text()!=''">
						<link linkend="{$bookmark/id/text()}">
							<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
								<xsl:with-param name="context" select="$context"/>
							</xsl:call-template>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="error">
							<error type="EL0001" link_anchor="{$link_anchor}"/>
						</xsl:variable>
						<xsl:for-each select="$error">
							<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
						</xsl:for-each>
						<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
							<xsl:with-param name="context" select="$context"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="rel" select="$RELS/rels:Relationships/rels:Relationship[@Id=$link_id]"/>
				<xsl:choose>
					<xsl:when test="starts-with($rel/@Target,'file:///')">
						<xsl:variable name="file_name" select="$rel/@Target"/>
						<xsl:variable name="docxm_map_entry" select="$DOCXM_MAP/docxm_map/entry[filename/text()=$file_name]"/>
						<xsl:choose>
							<xsl:when test="$docxm_map_entry">
								<xsl:if test="$link_anchor and not($docxm_map_entry/bookmark[name/text()=$link_anchor])">
									<xsl:variable name="warn">
										<warn type="WL0001">
											<link_anchor>
												<xsl:value-of select="$link_anchor"/>
											</link_anchor>
											<file_name>
												<xsl:value-of select="$file_name"/>
											</file_name>
										</warn>
									</xsl:variable>
									<xsl:for-each select="$warn">
										<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
									</xsl:for-each>
								</xsl:if>
								<xsl:variable name="url">
									<xsl:value-of select="concat($docxm_map_entry/ra_prefix/text(),'/')"/>
									<xsl:value-of select="concat($docxm_map_entry/id/text(),'.pdf')"/>
									<xsl:if test="$link_anchor">#<xsl:value-of select="$docxm_map_entry/bookmark[name/text()=$link_anchor]/id/text()"/>
									</xsl:if>
								</xsl:variable>
								<ulink url="{$url}">
									<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
										<xsl:with-param name="context" select="$context"/>
									</xsl:call-template>
								</ulink>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="some $x in ('docx','docm') satisfies ends-with($file_name,$x)">
										<xsl:variable name="error">
											<error type="EL0002">
												<xsl:value-of select="$file_name"/>
											</error>
										</xsl:variable>
										<xsl:for-each select="$error">
											<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
										</xsl:for-each>
										<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
											<xsl:with-param name="context" select="$context"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="error">
											<error type="EL0003">
												<xsl:value-of select="$file_name"/>
											</error>
										</xsl:variable>
										<xsl:for-each select="$error">
											<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
										</xsl:for-each>
										<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
											<xsl:with-param name="context" select="$context"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="url" select="$rel/@Target"/>
						<xsl:variable name="error">
							<error type="EL0005">
								<xsl:value-of select="$url"/>
							</error>
						</xsl:variable>
						<xsl:for-each select="$error">
							<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
						</xsl:for-each>
						<xsl:if test="1=0">
							<xsl:choose>
								<xsl:when test="some $x in ('http','https','ftp') satisfies starts-with($url,$x)">
									<ulink url="{$url}">
										<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
											<xsl:with-param name="context" select="$context"/>
										</xsl:call-template>
									</ulink>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="error_DOCBOOK_OUTPUT">
										<xsl:with-param name="title">
											<xsl:value-of select="$L/EL0004_TITLE"/>
										</xsl:with-param>
										<xsl:with-param name="text">
											<xsl:value-of select="$L/EL0004"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="hyperlink_apply_DOCBOOK_OUTPUT">
										<xsl:with-param name="context" select="$context"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="hyperlink_apply_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="p">
			<xsl:element name="w:p">
				<xsl:copy-of select="node()"/>
			</xsl:element>
		</xsl:variable>
		<xsl:apply-templates select="$p" mode="DOCBOOK_OUTPUT">
			<xsl:with-param name="context" select="$context"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="w:p" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="para_context" select="."/>
		<xsl:variable name="has_any_comments" select="0 &lt; count(w:commentRangeStart)"/>
		<xsl:variable name="has_any_inline_comments" select="$has_any_comments and (0 &lt; count(w:commentRangeStart[(some $x in ($INLINE_COMMENTS_MAP/comment/@id) satisfies $x=@w:id)]))"/>
		<xsl:choose>
			<xsl:when test="$has_any_inline_comments">
				<xsl:variable name="inline_comments_for_processing" as="element()">
					<comments>
						<ok>
							<xsl:copy-of select="w:commentRangeStart[(some $x in ($INLINE_COMMENTS_MAP/comment/@id) satisfies $x=@w:id) and (some $x in (following-sibling::element()[some $y in ('commentRangeStart','commentRangeEnd') satisfies local-name()=$y][1]/@w:id) satisfies $x=@w:id)]"/>
						</ok>
						<all>
							<xsl:copy-of select="w:commentRangeStart[(some $x in ($INLINE_COMMENTS_MAP/comment/@id) satisfies $x=@w:id)]"/>
						</all>
					</comments>
				</xsl:variable>
				<xsl:variable name="processed_para">
					<xsl:for-each-group select="element()[(some $x in ('pPr','r','hyperlink','oMathPara','oMath') satisfies local-name()=$x) or ((some $x in ('commentRangeStart','commentRangeEnd') satisfies local-name()=$x) and (some $x in (@w:id) satisfies $inline_comments_for_processing/ok/w:commentRangeStart[@w:id=$x]))]" group-adjacent="string-join((w:rPr/w:rStyle/@w:val, w:rPr/w:vertAlign/@w:val),'')">
						<xsl:variable name="target">
							<xsl:choose>
								<xsl:when test="some $x in ('EPOkrelenie','EPEmfaza','EPEmfaza-pogrubienie','EPEmfaza-kursywapogrubienie','EPAutorwtreci','EPTytuutworuliterackiego','EPWydarzeniewtreci','EPCytat','EPKod','EPJzykobcy') satisfies current-grouping-key()=$x">
									<xsl:element name="w:r">
										<xsl:copy-of select="current-group()//w:rPr[1]"/>
										<xsl:element name="w:t">
											<xsl:value-of select="string-join(current-group()//w:t/text(),'')"/>
										</xsl:element>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="current-group()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:apply-templates select="$target" mode="DOCBOOK_OUTPUT">
							<xsl:with-param name="context" select="$context"/>
							<xsl:with-param name="para_context" select="$para_context"/>
						</xsl:apply-templates>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:if test="$has_any_inline_comments">
					<xsl:apply-templates select="$INLINE_COMMENTS_MAP/comment[some $x in ($processed_para/w:commentRangeStart/@w:id) satisfies @id=$x]//error" mode="DOCBOOK_OUTPUT"/>
					<xsl:variable name="nesting_errors">
						<xsl:for-each select="$inline_comments_for_processing/all/w:commentRangeStart[not((@w:id)=($inline_comments_for_processing/ok/w:commentRangeStart/@w:id))]/@w:id">
							<xsl:variable name="comment_id" select="."/>
							<xsl:variable name="inline_comment" select="$INLINE_COMMENTS_MAP/comment[@id=$comment_id]"/>
							<xsl:choose>
								<xsl:when test="$inline_comment/@code='true'">
									<xsl:element name="error">
										<xsl:attribute name="type" select="'code_inline_comment_nesting_error'"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="attribute_name" select="local-name($inline_comment/@*[local-name(.)!='INLINE_COMMENT_PROCESSING' and .='true'])"/>
									<xsl:element name="error">
										<xsl:attribute name="type" select="'inline_comment_nesting_error'"/>
										<xsl:attribute name="style"><xsl:value-of select="$L/element()[local-name()=concat('INLINE_COMMENT_STYLE_',upper-case($attribute_name))]"/></xsl:attribute>
										<xsl:choose>
											<xsl:when test="$inline_comment/error">
												<xsl:value-of select="$inline_comment/error/text()"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$inline_comment/element()[local-name(.)=$attribute_name]/text()"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:apply-templates select="$nesting_errors" mode="DOCBOOK_OUTPUT"/>
				</xsl:if>
				<xsl:for-each-group select="$processed_para/node()" group-starting-with="w:commentRangeStart|w:commentRangeEnd">
					<xsl:choose>
						<xsl:when test="current-group()[some $x in ('commentRangeStart','commentRangeEnd') satisfies $x=local-name()]">
							<xsl:choose>
								<xsl:when test="local-name(current-group()[1])='commentRangeStart'">
									<xsl:for-each select="$INLINE_COMMENTS_MAP/comment[@id=current-group()[1]/@w:id]">
										<xsl:call-template name="inline_comment_processing_DOCBOOK_OUTPUT">
											<xsl:with-param name="content" select="current-group()[position()!=1]"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="current-group()[position()!=1]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="current-group()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each-group select="element()[some $x in ('pPr','r','hyperlink','oMathPara','oMath') satisfies local-name()=$x]" group-adjacent="string-join((w:rPr/w:rStyle/@w:val, w:rPr/w:vertAlign/@w:val),'')">
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="some $x in ('EPOkrelenie','EPEmfaza','EPEmfaza-pogrubienie','EPEmfaza-kursywapogrubienie','EPAutorwtreci','EPTytuutworuliterackiego','EPWydarzeniewtreci','EPCytat','EPKod','EPJzykobcy') satisfies current-grouping-key()=$x">
								<xsl:element name="w:r">
									<xsl:copy-of select="current-group()//w:rPr[1]"/>
									<xsl:element name="w:t">
										<xsl:value-of select="string-join(current-group()//w:t/text(),'')"/>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="current-group()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:apply-templates select="$target" mode="DOCBOOK_OUTPUT">
						<xsl:with-param name="context" select="$context"/>
						<xsl:with-param name="para_context" select="$para_context"/>
					</xsl:apply-templates>
				</xsl:for-each-group>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="w:commentRangeStart|w:commentRangeEnd" mode="DOCBOOK_OUTPUT">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="inline_comment_processing_DOCBOOK_OUTPUT">
		<xsl:param name="content"/>
		<xsl:choose>
			<xsl:when test="error">
				<xsl:copy-of select="$content"/>
			</xsl:when>
			<xsl:when test="@code='true'">
				<xsl:copy-of select="$L/CODE_START_A/node()"/>
				<xsl:copy-of select="$L/CODE_LANGUAGE/node()"/>
				<emphasis role="{$IER}">
					<xsl:value-of select="@language"/>
				</emphasis>
				<xsl:copy-of select="$L/CODE_START_B/node()"/>
				<code>
					<xsl:copy-of select="$content"/>
				</code>
				<xsl:copy-of select="$L/CODE_END/node()"/>
			</xsl:when>
			<xsl:when test="@tooltip-reference='true'">
				<link linkend="{epconvert:resolve-tooltip-id(tooltip-reference/text(),())}">
					<xsl:copy-of select="$L/TOOLTIP_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/TOOLTIP_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="tooltip-reference/text()"/>
					</emphasis>
					<xsl:copy-of select="$L/TOOLTIP_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/TOOLTIP_REFERENCE_END/node()"/>
				</link>
			</xsl:when>
			<xsl:when test="@glossary-reference='true'">
				<xsl:variable name="name" select="glossary-reference/text()"/>
				<xsl:variable name="link_content">
					<xsl:copy-of select="$L/GLOSSARY_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/GLOSSARY_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="$name"/>
					</emphasis>
					<xsl:copy-of select="$L/GLOSSARY_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/GLOSSARY_REFERENCE_END/node()"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="epconvert:check-glossary-local($name)">
						<link linkend="{epconvert:resolve-glossary-id($name)}">
							<xsl:copy-of select="$link_content"/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<ulink url="{epconvert:generate-referencable-global-url('glossary',epconvert:resolve-glossary-id($name))}">
							<xsl:copy-of select="$link_content"/>
						</ulink>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@concept-reference='true'">
				<xsl:variable name="name" select="concept-reference/text()"/>
				<xsl:variable name="link_content">
					<xsl:copy-of select="$L/CONCEPT_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/CONCEPT_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="$name"/>
					</emphasis>
					<xsl:copy-of select="$L/CONCEPT_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/CONCEPT_REFERENCE_END/node()"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="epconvert:check-concept-local($name)">
						<link linkend="{epconvert:resolve-concept-id($name)}">
							<xsl:copy-of select="$link_content"/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<ulink url="{epconvert:generate-referencable-global-url('concept',epconvert:resolve-concept-id($name))}">
							<xsl:copy-of select="$link_content"/>
						</ulink>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@event-reference='true'">
				<xsl:variable name="name" select="event-reference/text()"/>
				<xsl:variable name="link_content">
					<xsl:copy-of select="$L/EVENT_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/EVENT_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="$name"/>
					</emphasis>
					<xsl:copy-of select="$L/EVENT_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/EVENT_REFERENCE_END/node()"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="epconvert:check-event-local($name)">
						<link linkend="{epconvert:resolve-event-id($name)}">
							<xsl:copy-of select="$link_content"/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<ulink url="{epconvert:generate-referencable-global-url('event',epconvert:resolve-event-id($name))}">
							<xsl:copy-of select="$link_content"/>
						</ulink>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@biography-reference='true'">
				<xsl:variable name="name" select="biography-reference/text()"/>
				<xsl:variable name="link_content">
					<xsl:copy-of select="$L/BIOGRAPHY_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/BIOGRAPHY_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="$name"/>
					</emphasis>
					<xsl:copy-of select="$L/BIOGRAPHY_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/BIOGRAPHY_REFERENCE_END/node()"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="epconvert:check-biography-local($name)">
						<link linkend="{epconvert:resolve-biography-id($name)}">
							<xsl:copy-of select="$link_content"/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<ulink url="{epconvert:generate-referencable-global-url('biography',epconvert:resolve-biography-id($name))}">
							<xsl:copy-of select="$link_content"/>
						</ulink>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@bibliography-reference='true'">
				<xsl:variable name="name" select="bibliography-reference/text()"/>
				<xsl:variable name="link_content">
					<xsl:copy-of select="$L/BIBLIOGRAPHY_REFERENCE_START_A/node()"/>
					<xsl:copy-of select="$L/BIBLIOGRAPHY_REFERENCE/node()"/>
					<emphasis role="{$IER}">
						<xsl:value-of select="$name"/>
					</emphasis>
					<xsl:copy-of select="$L/BIBLIOGRAPHY_REFERENCE_START_B/node()"/>
					<xsl:copy-of select="$content"/>
					<xsl:copy-of select="$L/BIBLIOGRAPHY_REFERENCE_END/node()"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="epconvert:check-bibliography-local($name)">
						<link linkend="{epconvert:resolve-bibliography-id($name)}">
							<xsl:copy-of select="$link_content"/>
						</link>
					</xsl:when>
					<xsl:otherwise>
						<ulink url="{epconvert:generate-referencable-global-url('bibliography',epconvert:resolve-bibliography-id($name))}">
							<xsl:copy-of select="$link_content"/>
						</ulink>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<ERROR>
					<xsl:copy-of select="$content"/>
				</ERROR>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[text()!='']" mode="DOCBOOK_OUTPUT">
		<xsl:copy-of select="text()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPOkrelenie']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="term_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="term_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/TERM_START/node()"/>
		<emphasis>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</emphasis>
		<xsl:copy-of select="$L/TERM_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="emphasis_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/EMPHASIS_START/node()"/>
		<emphasis>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</emphasis>
		<xsl:copy-of select="$L/EMPHASIS_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza-pogrubienie']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="emphasis_bold_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_bold_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/EMPHASIS_BOLD_START/node()"/>
		<emphasis>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</emphasis>
		<xsl:copy-of select="$L/EMPHASIS_BOLD_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza-kursywapogrubienie']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="emphasis_bold_italic_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_bold_italic_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/EMPHASIS_BOLDITALICS_START/node()"/>
		<emphasis>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</emphasis>
		<xsl:copy-of select="$L/EMPHASIS_BOLDITALICS_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPCytat']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="cite_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="cite_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/CITE_START/node()"/>
		<citation>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</citation>
		<xsl:copy-of select="$L/CITE_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKod']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="code_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="code_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/CODE_START_A/node()"/>
		<xsl:copy-of select="$L/CODE_START_B/node()"/>
		<code>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</code>
		<xsl:copy-of select="$L/CODE_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPJzykobcy']" mode="DOCBOOK_OUTPUT">
		<xsl:call-template name="foreign_DOCBOOK_OUTPUT"/>
	</xsl:template>
	<xsl:template name="foreign_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:copy-of select="$L/FOREIGNPHRASE_START/node()"/>
		<foreignphrase>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</foreignphrase>
		<xsl:copy-of select="$L/FOREIGNPHRASE_END/node()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKomentarzedycyjny']" mode="DOCBOOK_OUTPUT"/>
	<xsl:template match="w:t[some $x in ('superscript','subscript') satisfies preceding-sibling::w:rPr[1]/w:vertAlign/@w:val=$x]" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="ename" select="preceding-sibling::w:rPr[1]/w:vertAlign/@w:val"/>
		<xsl:variable name="style" select="preceding-sibling::w:rPr[1]/w:rStyle/@w:val"/>
		<xsl:element name="{$ename}">
			<xsl:choose>
				<xsl:when test="not($style)">
					<xsl:apply-templates mode="DOCBOOK_OUTPUT">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$style='EPOkrelenie'">
					<xsl:call-template name="term_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza'">
					<xsl:call-template name="emphasis_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza-pogrubienie'">
					<xsl:call-template name="emphasis_bold_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza-kursywapogrubienie'">
					<xsl:call-template name="emphasis_bold_italic_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPCytat'">
					<xsl:call-template name="cite_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPKod'">
					<xsl:call-template name="code_DOCBOOK_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPJzykobcy'">
					<xsl:call-template name="foreign_DOCBOOK_OUTPUT"/>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="m:oMath" mode="DOCBOOK_OUTPUT">
		<xsl:param name="para_context"/>
		<xsl:variable name="mathms" as="node()">
			<xsl:copy>
				<xsl:element name="m:fName" extension-element-prefixes="#default">
					<xsl:copy-of select="child::node()"/>
				</xsl:element>
			</xsl:copy>
		</xsl:variable>
		<xsl:variable name="mathml">
			<xsl:choose>
				<xsl:when test="$para_context//w:t[text()!='']">
					<inlineequation>
						<xsl:apply-templates select="$mathms"/>
					</inlineequation>
				</xsl:when>
				<xsl:otherwise>
					<informalequation>
						<xsl:apply-templates select="$mathms"/>
					</informalequation>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates select="$mathml" mode="rmStyle"/>
	</xsl:template>
	<xsl:template match="m:oMath">
		<xsl:element name="mml:math">
			<xsl:apply-imports/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@mathvariant" mode="rmStyle"/>
	<xsl:template match="@*|node()" mode="rmStyle">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="rmStyle"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="w:tbl" mode="DOCBOOK_OUTPUT"/>
	<xsl:template match="w:tbl[not(w:tblPr/w:tblDescription) or w:tblPr/w:tblDescription[@w:val!='EP_AUTHOR' and @w:val!='EP_CORE_CURRICULUM' and @w:val!='EP_USPP_CORE_CURRICULUM' and @w:val!='WOMI_V2_REFERENCE' and @w:val!='EP_WOMI_GALLERY' and not(starts-with(@w:val,'WOMI_REFERENCE_')) and not(starts-with(@w:val,'EP_METADATA')) and not(starts-with(@w:val,'EP_ZAPIS_BIB'))]]" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="table_test" select="epconvert:table_test(w:tblPr)"/>
		<xsl:choose>
			<xsl:when test="$table_test/error">
				<xsl:call-template name="error_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:value-of select="$L/ET0000_TITLE"/>
					</xsl:with-param>
					<xsl:with-param name="entries" as="element()">
						<entries>
							<xsl:for-each select="$table_test/error">
								<entry>
									<xsl:value-of select="."/>
								</entry>
							</xsl:for-each>
						</entries>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:copy-of select="$L/TABLE_TITLE/node()"/>
						<xsl:value-of select="$table_test/title"/>
					</xsl:with-param>
					<xsl:with-param name="entries">
						<entry>
							<xsl:copy-of select="$L/TABLE_ALT_TEXT/node()"/>
							<xsl:value-of select="$table_test/alttext"/>
						</entry>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<table frame="all">
			<xsl:variable name="columns" select="count(w:tblGrid/w:gridCol)"/>
			<tgroup cols="{$columns}" align="left" colsep="1" rowsep="1">
				<xsl:for-each select="w:tblGrid/w:gridCol">
					<xsl:variable name="position" select="position()"/>
					<colspec colname="c{$position}"/>
				</xsl:for-each>
				<xsl:if test="w:tr[w:trPr/w:tblHeader]">
					<thead>
						<xsl:apply-templates select="w:tr[w:trPr/w:tblHeader]" mode="DOCBOOK_OUTPUT">
							<xsl:with-param name="context" select="$context"/>
						</xsl:apply-templates>
					</thead>
				</xsl:if>
				<tbody>
					<xsl:apply-templates select="w:tr[not(w:trPr/w:tblHeader)]" mode="DOCBOOK_OUTPUT">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>
	<xsl:function name="epconvert:table_test" as="element()">
		<xsl:param name="tableProperties"/>
		<output>
			<xsl:choose>
				<xsl:when test="$tableProperties/w:tblCaption/@w:val">
					<title>
						<xsl:value-of select="$tableProperties/w:tblCaption/@w:val"/>
					</title>
				</xsl:when>
				<xsl:otherwise>
					<error>
						<xsl:value-of select="$L/ET0001"/>
					</error>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$tableProperties/w:tblDescription/@w:val">
					<alttext>
						<xsl:value-of select="$tableProperties/w:tblDescription/@w:val"/>
					</alttext>
				</xsl:when>
				<xsl:otherwise>
					<error>
						<xsl:value-of select="$L/ET0002"/>
					</error>
				</xsl:otherwise>
			</xsl:choose>
		</output>
	</xsl:function>
	<xsl:template match="w:tr" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<row>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</row>
	</xsl:template>
	<xsl:template match="w:tc" mode="DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="colspan">
			<xsl:choose>
				<xsl:when test="w:tcPr/w:gridSpan/@w:val">
					<xsl:value-of select="number(w:tcPr/w:gridSpan/@w:val)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_col" select="count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)"/>
		<xsl:choose>
			<xsl:when test="w:tcPr/w:vMerge[@w:val='restart']">
				<xsl:variable name="current_row" select="count(ancestor::w:tr/preceding-sibling::w:tr)+1"/>
				<xsl:variable name="next_row_with_restart_on_that_col">
					<xsl:choose>
						<xsl:when test="ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge/@w:val='restart' and position()>$current_row]">
							<xsl:value-of select="count(ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge/@w:val='restart' and position()>$current_row][1]/preceding-sibling::w:tr)+1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="count(ancestor::w:tbl/w:tr)+1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="morerows" select="count(ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge[not(@w:val)] and position()>$current_row and position()&lt;$next_row_with_restart_on_that_col])"/>
				<xsl:call-template name="tc_apply_DOCBOOK_OUTPUT">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="colspan">
						<xsl:value-of select="$colspan"/>
					</xsl:with-param>
					<xsl:with-param name="current_col">
						<xsl:value-of select="$current_col"/>
					</xsl:with-param>
					<xsl:with-param name="morerows">
						<xsl:value-of select="$morerows"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="w:tcPr/w:vMerge">
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tc_apply_DOCBOOK_OUTPUT">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="colspan">
						<xsl:value-of select="$colspan"/>
					</xsl:with-param>
					<xsl:with-param name="current_col">
						<xsl:value-of select="$current_col"/>
					</xsl:with-param>
					<xsl:with-param name="morerows">0</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tc_apply_DOCBOOK_OUTPUT">
		<xsl:param name="context"/>
		<xsl:param name="colspan"/>
		<xsl:param name="current_col"/>
		<xsl:param name="morerows"/>
		<xsl:element name="entry">
			<xsl:if test="0 != $colspan">
				<xsl:attribute name="namest">c<xsl:value-of select="$current_col"/></xsl:attribute>
				<xsl:attribute name="nameend">c<xsl:value-of select="$current_col+number($colspan)-1"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="0 != $morerows">
				<xsl:attribute name="morerows" select="$morerows"/>
			</xsl:if>
			<xsl:apply-templates mode="DOCBOOK_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:function name="epconvert:parseWOMIReference" as="element()">
		<xsl:param name="reference"/>
		<xsl:analyze-string select="$reference" regex="^WOMI_REFERENCE_(IMAGE|ICON|VIDEO|AUDIO|OINT)_(\d+)$">
			<xsl:matching-substring>
				<WOMI>
					<parsed>1</parsed>
					<type>
						<xsl:value-of select="regex-group(1)"/>
					</type>
					<hr-type>
						<xsl:value-of select="$L/*[local-name()=concat('WOMI_TYPE_',regex-group(1))]"/>
					</hr-type>
					<id>
						<xsl:value-of select="regex-group(2)"/>
					</id>
				</WOMI>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<WOMI>
					<parsed>0</parsed>
				</WOMI>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:function>
	<xsl:template name="emit_WOMIs_in_biography_or_event_DOCBOOK_OUTPUT">
		<xsl:param name="main_title"/>
		<xsl:param name="title"/>
		<xsl:param name="position"/>
		<xsl:for-each select="special_table/element">
			<xsl:variable name="WOMI_element" select="."/>
			<xsl:variable name="is_main_WOMI" select="1=position()"/>
			<xsl:variable name="id" select="$WOMI_element/@id"/>
			<entry>
				<xsl:choose>
					<xsl:when test="$is_main_WOMI">
						<xsl:copy-of select="$main_title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$title"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="womi_V2_DOCBOOK_OUTPUT">
					<xsl:with-param name="WOMI_element" select="$WOMI_element"/>
				</xsl:call-template>
			</entry>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="womi_gallery_DOCBOOK_OUTPUT">
		<xsl:param name="special_table" as="element()"/>
		<xsl:param name="position"/>
		<xsl:param name="gallery_style" select="''"/>
		<xsl:variable name="gallery_title" select="$special_table/attribute[@key='gallery-title']/text()"/>
		<xsl:variable name="gallery_type" select="$special_table/attribute[@key='gallery-type']/text()"/>
		<xsl:variable name="gallery_start_on" select="$special_table/attribute[@key='ep:start-on']/text()"/>
		<xsl:variable name="gallery_thumbnails" select="$special_table/attribute[@key='ep:thumbnails']/text()"/>
		<xsl:variable name="gallery_titles" select="$special_table/attribute[@key='ep:titles']/text()"/>
		<xsl:variable name="gallery_format_contents" select="$special_table/attribute[@key='ep:format-contents']/text()"/>
		<xsl:variable name="gallery_playlist" select="$special_table/attribute[@key='ep:playlist']/text()"/>
		<xsl:variable name="gallery_view_width" select="$special_table/attribute[@key='ep:view-width']/text()"/>
		<xsl:variable name="gallery_view_height" select="$special_table/attribute[@key='ep:view-height']/text()"/>
		<xsl:variable name="gallery_text_copy" select="$special_table/attribute[@key='gallery-content-copy']/text()"/>
		<xsl:variable name="gallery_text_classic" select="$special_table/attribute[@key='ep:gallery-content-classic']/node()"/>
		<xsl:variable name="gallery_text_mobile" select="$special_table/attribute[@key='ep:gallery-content-mobile']/node()"/>
		<xsl:variable name="gallery_text_static" select="$special_table/attribute[@key='ep:gallery-content-pdf']/node()"/>
		<xsl:variable name="gallery_text_static_mono" select="$special_table/attribute[@key='ep:gallery-content-ebook']/node()"/>
		<xsl:variable name="gallery_no_of_WOMIs" select="count($special_table/element)"/>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="''!=$gallery_title">
						<xsl:value-of select="$L/WOMI_GALLERY_TITLE"/>
						<xsl:value-of select="$gallery_title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$L/WOMI_GALLERY_NO_TITLE"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="table_title">
				<xsl:value-of select="$L/WOMI_GALLERY_2"/>
			</xsl:with-param>
			<xsl:with-param name="color">dblight-gray</xsl:with-param>
			<xsl:with-param name="entries" as="element()">
				<entries>
					<entry>
						<xsl:copy-of select="$L/WOMI_GALLERY_TYPE/node()"/>
						<xsl:value-of select="$L/*[local-name()=concat('WOMI_GALLERY_TYPE_',upper-case($gallery_type))]"/>
					</entry>
					<entry>
						<xsl:copy-of select="$L/WOMI_GALLERY_NO_OF_WOMIES/node()"/>
						<xsl:value-of select="$gallery_no_of_WOMIs"/>
					</entry>
					<xsl:if test="$gallery_style!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_STYLE/node()"/>
							<xsl:value-of select="$gallery_style"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_start_on!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_START_ON/node()"/>
							<xsl:value-of select="$gallery_start_on"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_thumbnails!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_THUMBNAILS/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_GALLERY_THUMBNAILS_',upper-case($gallery_thumbnails))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_titles!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_TITLES/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_GALLERY_TITLES_',upper-case($gallery_titles))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_format_contents!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_FORMAT_CONTENTS/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_GALLERY_FORMAT_CONTENTS_',upper-case($gallery_format_contents))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_playlist!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_PLAYLIST/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_GALLERY_PLAYLIST_',upper-case($gallery_playlist))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_view_width!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_VIEW_WIDTH/node()"/>
							<xsl:value-of select="$gallery_view_width"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_view_height!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY_VIEW_HEIGHT/node()"/>
							<xsl:value-of select="$gallery_view_height"/>
						</entry>
					</xsl:if>
					<xsl:if test="$gallery_text_classic!='' or $gallery_text_mobile!='' or $gallery_text_static!='' or $gallery_text_static_mono!=''">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/WOMI_GALLERY_TEXT/node()"/>
						</entry>
						<xsl:if test="$gallery_text_classic!=''">
							<entry>
								<xsl:copy-of select="$L/WOMI_GALLERY_TEXT_CLASSIC/node()"/>
								<xsl:copy-of select="$gallery_text_classic"/>
							</entry>
						</xsl:if>
						<xsl:if test="$gallery_text_mobile!='' or 'true'=$gallery_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_GALLERY_TEXT_MOBILE/node()"/>
								<xsl:choose>
									<xsl:when test="$gallery_text_mobile!=''">
										<xsl:copy-of select="$gallery_text_mobile"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$gallery_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
						<xsl:if test="$gallery_text_static!='' or 'true'=$gallery_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_GALLERY_TEXT_STATIC/node()"/>
								<xsl:choose>
									<xsl:when test="$gallery_text_static!=''">
										<xsl:copy-of select="$gallery_text_static"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$gallery_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
						<xsl:if test="$gallery_text_static_mono!='' or 'true'=$gallery_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_GALLERY_TEXT_STATIC_MONO/node()"/>
								<xsl:choose>
									<xsl:when test="$gallery_text_static_mono!=''">
										<xsl:copy-of select="$gallery_text_static_mono"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$gallery_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
					</xsl:if>
					<entry>
						<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
						<xsl:copy-of select="$L/WOMIES_IN_GALLERY/node()"/>
					</entry>
					<entry>
						<xsl:for-each select="$special_table/element">
							<xsl:call-template name="emit_WOMIs_in_gallery_DOCBOOK_OUTPUT">
								<xsl:with-param name="WOMI_element" select="."/>
								<xsl:with-param name="position" select="$position"/>
							</xsl:call-template>
						</xsl:for-each>
					</entry>
				</entries>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="womi_V2_DOCBOOK_OUTPUT">
		<xsl:param name="WOMI_element" as="element()"/>
		<xsl:param name="womi_style" select="''"/>
		<xsl:variable name="id" select="$WOMI_element/@id"/>
		<xsl:variable name="womi_width" select="$WOMI_element/attribute[@name='WOMI_WIDTH']/text()"/>
		<xsl:variable name="womi_type" select="$WOMI_element/attribute[@name='WOMI_REFERENCE']/@group_2"/>
		<xsl:variable name="womi_context" select="$WOMI_element/attribute[@name='WOMI_CONTEXT']/text()"/>
		<xsl:variable name="womi_gallery" select="$WOMI_element/attribute[@name='WOMI_GALLERY']/text()"/>
		<xsl:variable name="womi_caption" select="$WOMI_element/attribute[@name='WOMI_CAPTION']/text()"/>
		<xsl:variable name="womi_zoomable" select="$WOMI_element/attribute[@name='WOMI_ZOOMABLE']/text()"/>
		<xsl:variable name="womi_avatar" select="$WOMI_element/attribute[@name='WOMI_AVATAR']/text()"/>
		<xsl:variable name="womi_text_copy" select="$WOMI_element/attribute[@name='WOMI_TEXT_COPY']/text()"/>
		<xsl:variable name="womi_text_classic" select="$WOMI_element/attribute[@name='WOMI_TEXT_CLASSIC']/node()"/>
		<xsl:variable name="womi_text_mobile" select="$WOMI_element/attribute[@name='WOMI_TEXT_MOBILE']/node()"/>
		<xsl:variable name="womi_text_static" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC']/node()"/>
		<xsl:variable name="womi_text_static_mono" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC_MONO']/node()"/>
		<xsl:call-template name="womi_DOCBOOK_OUTPUT">
			<xsl:with-param name="title">
				<xsl:value-of select="$L/WOMI_ID"/>
				<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
					<xsl:with-param name="id" select="$id"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="entries" as="element()">
				<entries>
					<entry>
						<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
						<xsl:value-of select="$L/*[local-name()=concat('WOMI_TYPE_',$womi_type)]"/>
					</entry>
					<xsl:if test="$womi_width!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_WIDTH/node()"/>
							<xsl:value-of select="$womi_width"/> %
						</entry>
					</xsl:if>
					<xsl:if test="$womi_style!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_STYLE/node()"/>
							<xsl:value-of select="$womi_style"/>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_context!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_CONTEXT/node()"/>
							<xsl:choose>
								<xsl:when test="'no'=$womi_context">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
									<xsl:if test="'yes'=$womi_context">
										<xsl:value-of select="$L/WOMI_CONTEXT_STATIC"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_gallery!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_GALLERY/node()"/>
							<xsl:choose>
								<xsl:when test="'true'=$womi_gallery">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_TRUE"/>
								</xsl:when>
								<xsl:when test="'false'=$womi_gallery">
									<xsl:value-of select="$L/ATTRIBUTE_OPTION_FALSE"/>
								</xsl:when>
								<xsl:when test="'show-format-contents'=$womi_gallery">
									<xsl:value-of select="$L/WOMI_GALLERY_WITH_CONTENTS"/>
								</xsl:when>
							</xsl:choose>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_caption!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_CAPTION/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_CAPTION_',upper-case($womi_caption))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_zoomable!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_ZOOMABLE/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('WOMI_ZOOMABLE_',upper-case($womi_zoomable))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_avatar!=''">
						<entry>
							<xsl:copy-of select="$L/WOMI_AVATAR/node()"/>
							<xsl:value-of select="$L/*[local-name()=concat('ATTRIBUTE_OPTION_',upper-case($womi_avatar))]"/>
						</entry>
					</xsl:if>
					<xsl:if test="$womi_text_classic!='' or $womi_text_mobile!='' or $womi_text_static!='' or $womi_text_static_mono!=''">
						<entry>
							<xsl:call-template name="dbvlight-gray_DOCBOOK_OUTPUT"/>
							<xsl:copy-of select="$L/WOMI_TEXT/node()"/>
						</entry>
						<xsl:if test="$womi_text_classic!=''">
							<entry>
								<xsl:copy-of select="$L/WOMI_TEXT_CLASSIC/node()"/>
								<xsl:copy-of select="$womi_text_classic"/>
							</entry>
						</xsl:if>
						<xsl:if test="$womi_text_mobile!='' or 'true'=$womi_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_TEXT_MOBILE/node()"/>
								<xsl:choose>
									<xsl:when test="$womi_text_mobile!=''">
										<xsl:copy-of select="$womi_text_mobile"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$womi_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
						<xsl:if test="$womi_text_static!='' or 'true'=$womi_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_TEXT_STATIC/node()"/>
								<xsl:choose>
									<xsl:when test="$womi_text_static!=''">
										<xsl:copy-of select="$womi_text_static"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$womi_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
						<xsl:if test="$womi_text_static_mono!='' or 'true'=$womi_text_copy">
							<entry>
								<xsl:copy-of select="$L/WOMI_TEXT_STATIC_MONO/node()"/>
								<xsl:choose>
									<xsl:when test="$womi_text_static_mono!=''">
										<xsl:copy-of select="$womi_text_static_mono"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="$womi_text_classic"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</xsl:if>
					</xsl:if>
				</entries>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="womi_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="text" select="$text"/>
			<xsl:with-param name="entries" select="$entries"/>
			<xsl:with-param name="table_title">
				<xsl:value-of select="$L/WOMI_REFERENCE"/>
			</xsl:with-param>
			<xsl:with-param name="color">dblight-gray</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="womi_id_url_DOCBOOK_OUTPUT">
		<xsl:param name="id"/>
		<ulink url="http://{$REPO_DOMAIN}/repo/rt/docmetadata?id={$id}">
			<xsl:value-of select="$id"/>
		</ulink>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription[starts-with(@w:val,'WOMI_REFERENCE_')]]" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="womi_reference" select="epconvert:parseWOMIReference(w:tblPr/w:tblDescription/@w:val)"/>
		<xsl:variable name="womi_width" select="string-join(w:tr[2]/w:tc[2]/w:p/w:r/w:t,'')"/>
		<xsl:variable name="womi_style_key" select="w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val"/>
		<xsl:variable name="womi_style" select="$EP_STYLES/style[@key=$womi_style_key]/hr-name"/>
		<xsl:choose>
			<xsl:when test="$womi_reference/parsed='1' and $womi_reference/type = 'AUDIO'">
				<xsl:call-template name="womi_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:copy-of select="$L/WOMI_ID/node()"/>
						<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
							<xsl:with-param name="id" select="$womi_reference/id"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="entries" as="element()">
						<entries>
							<entry>
								<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
								<xsl:value-of select="$womi_reference/hr-type"/>
							</entry>
							<xsl:if test="$womi_style!=''">
								<entry>
									<xsl:copy-of select="$L/WOMI_STYLE/node()"/>
									<xsl:value-of select="$womi_style"/>
								</entry>
							</xsl:if>
						</entries>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$womi_reference/parsed='1' and number($womi_width) and round(number($womi_width))=number($womi_width) and number($womi_width) &gt; 0 and number($womi_width) &lt; 101">
				<xsl:call-template name="womi_DOCBOOK_OUTPUT">
					<xsl:with-param name="title">
						<xsl:value-of select="$L/WOMI_ID"/>
						<xsl:call-template name="womi_id_url_DOCBOOK_OUTPUT">
							<xsl:with-param name="id" select="$womi_reference/id"/>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="entries" as="element()">
						<entries>
							<entry>
								<xsl:copy-of select="$L/WOMI_TYPE/node()"/>
								<xsl:value-of select="$womi_reference/hr-type"/>
							</entry>
							<entry>
								<xsl:copy-of select="$L/WOMI_WIDTH/node()"/>
								<xsl:value-of select="$womi_width"/> %
							</entry>
							<xsl:if test="$womi_style!=''">
								<entry>
									<xsl:copy-of select="$L/WOMI_STYLE/node()"/>
									<xsl:value-of select="$womi_style"/>
								</entry>
							</xsl:if>
						</entries>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="error">
					<xsl:choose>
						<xsl:when test="$womi_reference/parsed='1'">
							<error type="EW0001" womi_width="{$womi_width}" womi_id="{$womi_reference/id}"/>
						</xsl:when>
						<xsl:otherwise>
							<error type="EW0002">
								<xsl:value-of select="w:tblPr/w:tblDescription/@w:val"/>
							</error>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:for-each select="$error">
					<xsl:apply-templates mode="DOCBOOK_OUTPUT"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription/@w:val='EP_WOMI_GALLERY']" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="this_table" select="."/>
		<xsl:variable name="possition_context" select="$ROOT//w:tbl[.=$this_table]"/>
		<xsl:variable name="current_position" select="count($possition_context/preceding-sibling::w:p|$possition_context/preceding-sibling::w:tbl)+1"/>
		<xsl:variable name="special_table" select="epconvert:process_special_table_attributes(.,$current_position)"/>
		<xsl:variable name="gallery_style_key" select="w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val"/>
		<xsl:variable name="gallery_style" select="$EP_STYLES/style[@key=$gallery_style_key]/hr-name"/>
		<xsl:variable name="gallery_errors" select="epconvert:check_WOMI_GALLERY_attributes($special_table)"/>
		<xsl:choose>
			<xsl:when test="0 &lt; count($gallery_errors)">
				<xsl:apply-templates mode="DOCBOOK_OUTPUT" select="$gallery_errors"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="womi_gallery_DOCBOOK_OUTPUT">
					<xsl:with-param name="special_table" select="$special_table"/>
					<xsl:with-param name="position" select="$current_position"/>
					<xsl:with-param name="gallery_style" select="$gallery_style"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:function name="epconvert:check_WOMI_GALLERY_attributes" as="node()*">
		<xsl:param name="special_table" as="element()"/>
		<xsl:copy-of select="$special_table/error"/>
		<xsl:variable name="gallery_type" select="$special_table/attribute[@key='gallery-type']/text()"/>
		<xsl:variable name="gallery_start_on" select="$special_table/attribute[@key='ep:start-on']/text()"/>
		<xsl:variable name="gallery_thumbnails" select="$special_table/attribute[@key='ep:thumbnails']/text()"/>
		<xsl:variable name="gallery_titles" select="$special_table/attribute[@key='ep:titles']/text()"/>
		<xsl:variable name="gallery_format_contents" select="$special_table/attribute[@key='ep:format-contents']/text()"/>
		<xsl:variable name="gallery_playlist" select="$special_table/attribute[@key='ep:playlist']/text()"/>
		<xsl:variable name="gallery_view_width" select="$special_table/attribute[@key='ep:view-width']/text()"/>
		<xsl:variable name="gallery_view_height" select="$special_table/attribute[@key='ep:view-height']/text()"/>
		<xsl:variable name="gallery_text_copy" select="$special_table/attribute[@key='gallery-content-copy']/text()"/>
		<xsl:variable name="gallery_text_classic" select="$special_table/attribute[@key='ep:gallery-content-classic']/text()"/>
		<xsl:choose>
			<xsl:when test="$gallery_type='slideshow'">
				<xsl:if test="''!=$gallery_view_width">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_SLIDESHOW/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-width']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_view_height">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_SLIDESHOW/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-height']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_playlist">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_SLIDESHOW/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:playlist']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="not(''!=$gallery_start_on) and count($special_table/element) &lt; $gallery_start_on">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_gallery_start_on_greater_than_no_of_WOMIs'"/>
						<xsl:attribute name="start_on" select="$gallery_start_on"/>
						<xsl:attribute name="no_of_WOMIs" select="count($special_table/element)"/>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$gallery_type='grid'">
				<xsl:if test="''!=$gallery_start_on">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:start-on']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_thumbnails">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:thumbnails']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_titles">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:titles']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_format_contents">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:format-contents']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_playlist">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_SLIDESHOW/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:playlist']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="not(''!=$gallery_view_width)">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_gallery_attribute_undefined'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-width']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="not(''!=$gallery_view_height)">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_gallery_attribute_undefined'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_GRID/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-height']/name"/>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$gallery_type='miniatures'">
				<xsl:if test="''!=$gallery_start_on">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_MINIATURES/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:start-on']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_view_width">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_MINIATURES/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-width']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_view_height">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_MINIATURES/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-height']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_playlist">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_SLIDESHOW/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:playlist']/name"/>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="''!=$gallery_view_width">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_PLAYLIST/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-width']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''!=$gallery_view_height">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_gallery_type_disallowed_attribute'"/>
						<xsl:attribute name="gallery_type" select="$L/WOMI_GALLERY_TYPE_PLAYLIST/text()"/>
						<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_gallery_metadata']/field[@key='ep:view-height']/name"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="''=$gallery_playlist">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_gallery_playlist_but_not_playlist_option_chosen'"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="not(''!=$gallery_start_on) and count($special_table/element) &lt; $gallery_start_on">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_gallery_start_on_greater_than_no_of_WOMIs'"/>
						<xsl:attribute name="start_on" select="$gallery_start_on"/>
						<xsl:attribute name="no_of_WOMIs" select="count($special_table/element)"/>
					</xsl:element>
				</xsl:if>
				<xsl:for-each select="$special_table/element">
					<xsl:if test="attribute[@name='WOMI_REFERENCE' and not(some $x in ('VIDEO','IMAGE','ICON') satisfies @group_2=$x)]">
						<error type="WOMI_gallery_playlist_but_WOMI_not_VIDEO_or_IMAGE" WOMI_id="{@id}"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="count($special_table/element) &lt; 2">
			<xsl:element name="warn">
				<xsl:attribute name="type" select="'WOMI_gallery_less_then_2_WOMIes'"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="'true'=$gallery_text_copy and not(''!=$gallery_text_classic)">
			<xsl:element name="warn">
				<xsl:attribute name="type" select="'WOMI_gallery_text_copy_but_no_classic_text'"/>
			</xsl:element>
		</xsl:if>
	</xsl:function>
	<xsl:template name="emit_WOMIs_in_gallery_DOCBOOK_OUTPUT">
		<xsl:param name="WOMI_element" as="element()"/>
		<xsl:param name="position"/>
		<xsl:variable name="special_table" as="element()">
			<special_table>
				<xsl:copy-of select="$WOMI_element"/>
			</special_table>
		</xsl:variable>
		<xsl:variable name="errors" select="epconvert:check_WOMI_V2_attributes($special_table, true())"/>
		<xsl:choose>
			<xsl:when test="0 &lt; count($errors)">
				<xsl:apply-templates mode="DOCBOOK_OUTPUT" select="$errors"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="womi_V2_DOCBOOK_OUTPUT">
					<xsl:with-param name="WOMI_element" select="$WOMI_element"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription/@w:val='WOMI_V2_REFERENCE']" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="special_table" select="epconvert:process_special_table_attributes(.,0)"/>
		<xsl:variable name="womi_style_key" select="w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val"/>
		<xsl:variable name="womi_style" select="$EP_STYLES/style[@key=$womi_style_key]/hr-name"/>
		<xsl:variable name="errors" select="epconvert:check_WOMI_V2_attributes($special_table, false())"/>
		<xsl:variable name="WOMI_element" select="$special_table/element[1]"/>
		<xsl:choose>
			<xsl:when test="0 &lt; count($errors)">
				<xsl:apply-templates mode="DOCBOOK_OUTPUT" select="$errors"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="womi_V2_DOCBOOK_OUTPUT">
					<xsl:with-param name="WOMI_element" select="$WOMI_element"/>
					<xsl:with-param name="womi_style" select="$womi_style"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:function name="epconvert:check_WOMI_V2_attributes" as="node()*">
		<xsl:param name="special_table" as="element()"/>
		<xsl:param name="check_WOMI_in_gallery"/>
		<xsl:choose>
			<xsl:when test="1 &lt; count($special_table/element)">
				<xsl:element name="warn">
					<xsl:attribute name="type" select="'WW0001'"/>
					<xsl:for-each select="$special_table/element">
						<xsl:element name="id">
							<xsl:value-of select="@id"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<xsl:copy-of select="$special_table/element/error"/>
			</xsl:when>
			<xsl:when test="0=count($special_table/element)">
				<xsl:element name="error">
					<xsl:attribute name="type" select="'WOMI_reference_unable_to_parse'"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="0=count($special_table/element[1]/attribute[@name='WOMI_REFERENCE'])">
				<xsl:element name="error">
					<xsl:attribute name="type" select="'WOMI_reference_unable_to_parse'"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="0 &lt; count($special_table/element/error)">
				<xsl:copy-of select="$special_table/element/error"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="WOMI_element" select="$special_table/element[1]"/>
				<xsl:variable name="womi_width" select="$WOMI_element/attribute[@name='WOMI_WIDTH']/text()"/>
				<xsl:variable name="womi_type" select="$WOMI_element/attribute[@name='WOMI_REFERENCE']/@group_2"/>
				<xsl:variable name="womi_context" select="$WOMI_element/attribute[@name='WOMI_CONTEXT']/text()"/>
				<xsl:variable name="womi_gallery" select="$WOMI_element/attribute[@name='WOMI_GALLERY']/text()"/>
				<xsl:variable name="womi_caption" select="$WOMI_element/attribute[@name='WOMI_CAPTION']/text()"/>
				<xsl:variable name="womi_zoomable" select="$WOMI_element/attribute[@name='WOMI_ZOOMABLE']/text()"/>
				<xsl:variable name="womi_avatar" select="$WOMI_element/attribute[@name='WOMI_AVATAR']/text()"/>
				<xsl:variable name="womi_text_copy" select="$WOMI_element/attribute[@name='WOMI_TEXT_COPY']/text()"/>
				<xsl:variable name="womi_text_classic" select="$WOMI_element/attribute[@name='WOMI_TEXT_CLASSIC']/text()"/>
				<xsl:variable name="womi_text_mobile" select="$WOMI_element/attribute[@name='WOMI_TEXT_MOBILE']/text()"/>
				<xsl:variable name="womi_text_static" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC']/text()"/>
				<xsl:variable name="womi_text_static_mono" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC_MONO']/text()"/>
				<xsl:choose>
					<xsl:when test="'AUDIO'=$womi_type">
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not($womi_width) and not($check_WOMI_in_gallery)">
							<xsl:element name="error">
								<xsl:attribute name="type" select="'WOMI_attribute_missing'"/>
								<xsl:attribute name="id" select="$WOMI_element/@id"/>
								<xsl:element name="field_name">
									<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:width']/name"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="not(some $x in ('IMAGE','ICON') satisfies $x=$womi_type)">
					<xsl:if test="'zoom'=$womi_zoomable or 'magnifier'=$womi_zoomable">
						<xsl:element name="error">
							<xsl:attribute name="type" select="'WOMI_zoomable_while_not_image'"/>
							<xsl:attribute name="id" select="$WOMI_element/@id"/>
							<xsl:element name="field_name">
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:zoomable']/name"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not('OINT'=$womi_type)">
					<xsl:if test="'true'=$womi_avatar">
						<xsl:element name="error">
							<xsl:attribute name="type" select="'WOMI_avatar_while_not_oint'"/>
							<xsl:attribute name="id" select="$WOMI_element/@id"/>
							<xsl:element name="field_name">
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:avatar']/name"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not($womi_context) and not($check_WOMI_in_gallery)">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_attribute_missing'"/>
						<xsl:attribute name="id" select="$WOMI_element/@id"/>
						<xsl:element name="field_name">
							<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:context']/name"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="not($womi_gallery)">
					<xsl:element name="error">
						<xsl:attribute name="type" select="'WOMI_attribute_missing'"/>
						<xsl:attribute name="id" select="$WOMI_element/@id"/>
						<xsl:element name="field_name">
							<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:reading-room']/name"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="'true'=$womi_text_copy and not(''!=$womi_text_classic)">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_text_copy_but_no_classic_text'"/>
						<xsl:attribute name="id" select="$WOMI_element/@id"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="'classic_only'=$womi_context">
					<xsl:if test="''!=$womi_text_static">
						<xsl:element name="warn">
							<xsl:attribute name="type" select="'WOMI_reference_no_context_but_static_text'"/>
							<xsl:attribute name="id" select="$WOMI_element/@id"/>
							<xsl:attribute name="for" select="'static'"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="''!=$womi_text_static">
						<xsl:element name="warn">
							<xsl:attribute name="type" select="'WOMI_reference_no_context_but_static_text'"/>
							<xsl:attribute name="id" select="$WOMI_element/@id"/>
							<xsl:attribute name="for" select="'static_mono'"/>
						</xsl:element>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template name="br_DOCBOOK_OUTPUT">
		<epconvert:PROC>br</epconvert:PROC>
	</xsl:template>
	<xsl:template match="w:br" mode="DOCBOOK_OUTPUT">
		<epconvert:PROC>br</epconvert:PROC>
	</xsl:template>
	<xsl:template name="dbcolor_DOCBOOK_OUTPUT">
		<xsl:param name="color"/>
		<epconvert:PROC>dbfo bgcolor="#<xsl:value-of select="$color"/>"</epconvert:PROC>
	</xsl:template>
	<xsl:template name="dblight-gray_DOCBOOK_OUTPUT">
		<xsl:call-template name="dbcolor_DOCBOOK_OUTPUT">
			<xsl:with-param name="color">DDDDDD</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="dbvlight-gray_DOCBOOK_OUTPUT">
		<xsl:call-template name="dbcolor_DOCBOOK_OUTPUT">
			<xsl:with-param name="color">EEEEEE</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="dbred_DOCBOOK_OUTPUT">
		<xsl:call-template name="dbcolor_DOCBOOK_OUTPUT">
			<xsl:with-param name="color">FF0000</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="dborange_DOCBOOK_OUTPUT">
		<xsl:call-template name="dbcolor_DOCBOOK_OUTPUT">
			<xsl:with-param name="color">FFA500</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="warn_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:message terminate="no">EPK_STATUS_WARN;;;<xsl:value-of select="$title"/>.</xsl:message>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="table_title" select="$title"/>
			<xsl:with-param name="text" select="$text"/>
			<xsl:with-param name="entries" select="$entries"/>
			<xsl:with-param name="title">
				<xsl:value-of select="$L/WARN_AUTHOR"/>
			</xsl:with-param>
			<xsl:with-param name="color">dborange</xsl:with-param>
			<xsl:with-param name="role" select="'ERROR'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="error_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:message terminate="no">EPK_STATUS_ERROR;;;<xsl:value-of select="$title"/>.</xsl:message>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="table_title" select="$title"/>
			<xsl:with-param name="text" select="$text"/>
			<xsl:with-param name="entries" select="$entries"/>
			<xsl:with-param name="title">
				<xsl:value-of select="$L/ERROR_AUTHOR"/>
			</xsl:with-param>
			<xsl:with-param name="color">dbred</xsl:with-param>
			<xsl:with-param name="role" select="'ERROR'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="error_warn_table_row_DOCBOOK_OUTPUT">
		<xsl:param name="element" as="element()"/>
		<xsl:variable name="type" select="$element/@type"/>
		<xsl:variable name="entry" select="if($DI/entry[@key=$type]) then $DI/entry[@key=$type] else $DI/entry[@key='DEFAULT']"/>
		<xsl:variable name="tokens">
			<xsl:for-each select="$element">
				<xsl:call-template name="get_issue_tokens">
					<xsl:with-param name="type">
						<xsl:value-of select="$entry/@key"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="description">
			<xsl:choose>
				<xsl:when test="$tokens/element()">
					<xsl:apply-templates select="$entry/PATTERN" mode="GENERATE_ISSUE_DESCRIPTION">
						<xsl:with-param name="tokens" select="$tokens"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$entry/PATTERN"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="local-name($element)='error'">
				<xsl:message terminate="no">EPK_STATUS_ERROR;;;<xsl:value-of select="$entry/TITLE"/>.</xsl:message>
				<row>
					<entry namest="c1" nameend="c2" align="center">
						<xsl:call-template name="dbred_DOCBOOK_OUTPUT"/>
						<xsl:value-of select="$L/ERROR_AUTHOR"/>
					</entry>
				</row>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">EPK_STATUS_WARN;;;<xsl:value-of select="$entry/TITLE"/>.</xsl:message>
				<row>
					<entry namest="c1" nameend="c2" align="center">
						<xsl:call-template name="dborange_DOCBOOK_OUTPUT"/>
						<xsl:value-of select="$L/WARN_AUTHOR"/>
					</entry>
				</row>
			</xsl:otherwise>
		</xsl:choose>
		<row role="ERROR">
			<entry>
				<xsl:value-of select="$entry/TITLE"/>
			</entry>
			<entry>
				<xsl:copy-of select="$description"/>
			</entry>
		</row>
	</xsl:template>
	<xsl:template name="table_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="text" select="$text"/>
			<xsl:with-param name="entries" select="$entries"/>
			<xsl:with-param name="table_title">
				<xsl:value-of select="$L/TABLE"/>
			</xsl:with-param>
			<xsl:with-param name="color">dblight-gray</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="special_block_table_DOCBOOK_OUTPUT">
		<xsl:param name="type"/>
		<xsl:param name="entries"/>
		<xsl:call-template name="info_table_DOCBOOK_OUTPUT">
			<xsl:with-param name="title">
				<xsl:value-of select="$L/SPECIAL_TYPE"/>
				<xsl:value-of select="$type"/>
			</xsl:with-param>
			<xsl:with-param name="entries" select="$entries"/>
			<xsl:with-param name="table_title">
				<xsl:value-of select="$L/SPECIAL_BLOCK"/>
			</xsl:with-param>
			<xsl:with-param name="color">dblight-gray</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="info_table_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:param name="table_title"/>
		<xsl:param name="color"/>
		<xsl:param name="role"/>
		<xsl:element name="table">
			<xsl:if test="$role">
				<xsl:attribute name="role" select="$role"/>
			</xsl:if>
			<title>
				<xsl:value-of select="$table_title"/>
			</title>
			<tgroup cols="1">
				<colspec colname="c1" colwidth="1*"/>
				<thead>
					<row>
						<entry>
							<xsl:choose>
								<xsl:when test="$color='dbred'">
									<xsl:call-template name="dbred_DOCBOOK_OUTPUT"/>
								</xsl:when>
								<xsl:when test="$color='dborange'">
									<xsl:call-template name="dborange_DOCBOOK_OUTPUT"/>
								</xsl:when>
								<xsl:when test="$color='dblight-gray'">
									<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
								</xsl:when>
							</xsl:choose>
							<xsl:copy-of select="$title"/>
						</entry>
					</row>
				</thead>
				<tbody>
					<xsl:if test="$text">
						<row>
							<entry>
								<xsl:copy-of select="$text"/>
							</entry>
						</row>
					</xsl:if>
					<xsl:if test="$entries">
						<xsl:for-each select="$entries/entry">
							<row>
								<entry>
									<xsl:copy-of select="node()"/>
								</entry>
							</row>
						</xsl:for-each>
					</xsl:if>
				</tbody>
			</tgroup>
		</xsl:element>
	</xsl:template>
	<xsl:template name="info_table_with_image_DOCBOOK_OUTPUT">
		<xsl:param name="title"/>
		<xsl:param name="text"/>
		<xsl:param name="entries"/>
		<xsl:param name="table_title"/>
		<xsl:param name="image_relid"/>
		<xsl:param name="color"/>
		<xsl:param name="role"/>
		<xsl:variable name="rowspan" select="if($text) then 1+count($entries/entry) else count($entries/entry)"/>
		<xsl:element name="table">
			<xsl:if test="$role">
				<xsl:attribute name="role" select="$role"/>
			</xsl:if>
			<title>
				<xsl:value-of select="$table_title"/>
			</title>
			<tgroup cols="2">
				<colspec colname="c1" colwidth="1*"/>
				<colspec colname="c2" colwidth="3*"/>
				<thead>
					<row>
						<entry namest="c1" nameend="c2">
							<xsl:choose>
								<xsl:when test="$color='dbred'">
									<xsl:call-template name="dbred_DOCBOOK_OUTPUT"/>
								</xsl:when>
								<xsl:when test="$color='dborange'">
									<xsl:call-template name="dborange_DOCBOOK_OUTPUT"/>
								</xsl:when>
								<xsl:when test="$color='dblight-gray'">
									<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
								</xsl:when>
							</xsl:choose>
							<xsl:value-of select="$title"/>
						</entry>
					</row>
				</thead>
				<tbody>
					<row>
						<entry morerows="{$rowspan - 1}">
							<xsl:call-template name="emit_image_DOCBOOK_OUTPUT">
								<xsl:with-param name="relid" select="$image_relid"/>
							</xsl:call-template>
						</entry>
						<entry>
							<xsl:choose>
								<xsl:when test="$text">
									<xsl:value-of select="$text"/>
								</xsl:when>
								<xsl:when test="$entries">
									<xsl:copy-of select="$entries/entry[1]/node()"/>
								</xsl:when>
							</xsl:choose>
						</entry>
					</row>
					<xsl:if test="$entries">
						<xsl:choose>
							<xsl:when test="$text">
								<xsl:for-each select="$entries/entry">
									<row>
										<entry>
											<xsl:copy-of select="node()"/>
										</entry>
									</row>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$entries/entry[1 &lt; position()]">
									<row>
										<entry>
											<xsl:copy-of select="node()"/>
										</entry>
									</row>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</tbody>
			</tgroup>
		</xsl:element>
	</xsl:template>
	<xsl:template name="emit_image_DOCBOOK_OUTPUT">
		<xsl:param name="relid"/>
		<xsl:variable name="target" select="$RELS/rels:Relationships/rels:Relationship[@Id=$relid]/@Target"/>
		<mediaobject>
			<imageobject>
				<xsl:element name="imagedata">
					<xsl:attribute name="fileref" select="concat($docxm_working_dir_path, '/word/', $target)"/>
					<xsl:attribute name="format" select="substring-after($target,'.')"/>
					<xsl:attribute name="width" select="'100%'"/>
					<xsl:attribute name="scalefit" select="1"/>
				</xsl:element>
			</imageobject>
		</mediaobject>
	</xsl:template>
	<xsl:template match="special_table[@type='global_metadata']" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="element" select="."/>
		<xsl:for-each select="descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
			<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:for-each>
		<row>
			<entry namest="c1" nameend="c2" align="center">
				<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
				<xsl:value-of select="$L/METADATA_MODULE_SCOPE_TITLE"/>
			</entry>
		</row>
		<xsl:for-each select="('recipient','status')">
			<xsl:variable name="label_prefix" select="string-join(('METADATA_MODULE_SCOPE', upper-case(.)),'_')"/>
			<xsl:variable name="field_name" select="string-join(('ep',.),':')"/>
			<row>
				<entry>
					<xsl:value-of select="$L/element()[local-name()=$label_prefix]"/>
				</entry>
				<entry>
					<xsl:value-of select="$L/element()[local-name()=string-join(($label_prefix, upper-case($element/attribute[@key=$field_name])),'_')]"/>
				</entry>
			</row>
		</xsl:for-each>
		<xsl:if test="attribute[@key='ep:type'] or attribute[@key='ep:template']">
			<row>
				<entry namest="c1" nameend="c2" align="center">
					<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
					<xsl:value-of select="$L/METADATA_MODULE_OTHER_TITLE"/>
				</entry>
			</row>
		</xsl:if>
		<xsl:if test="attribute[@key='ep:type']">
			<xsl:variable name="subtype" select="@subtype"/>
			<row>
				<entry>
					<xsl:value-of select="$L/METADATA_MODULE_TYPE"/>
				</entry>
				<entry>
					<xsl:choose>
						<xsl:when test="'NONE'=attribute[@key='ep:type']">
							<xsl:value-of select="$L/METADATA_MODULE_TYPE_NONE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="attribute[@key='ep:type']"/> (<xsl:value-of select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$subtype]/name"/>)</xsl:otherwise>
					</xsl:choose>
				</entry>
			</row>
		</xsl:if>
		<xsl:if test="attribute[@key='ep:template']">
			<xsl:variable name="value" select="attribute[@key='ep:template']"/>
			<row>
				<entry>
					<xsl:value-of select="$L/METADATA_MODULE_TEMPLATE"/>
				</entry>
				<entry>
					<xsl:choose>
						<xsl:when test="some $x in ('NONE','COLUMNS','FREEFORM') satisfies $x=$value">
							<xsl:value-of select="$L/element()[local-name()=string-join(('METADATA_MODULE_TEMPLATE', $value),'_')]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$TEMPLATE_MAPPINGS/template[key=$value]/name"/>
						</xsl:otherwise>
					</xsl:choose>
				</entry>
			</row>
			<xsl:for-each select="('grid-width','grid-height')">
				<xsl:variable name="label_prefix" select="string-join(('METADATA_MODULE_TEMPLATE_FREEFORM', upper-case(.)),'_')"/>
				<xsl:variable name="field_name" select="string-join(('ep',.),':')"/>
				<xsl:if test="$element/attribute[@key=$field_name]/text()">
					<row>
						<entry>
							<xsl:value-of select="$L/element()[local-name()=$label_prefix]"/>
						</entry>
						<entry>
							<xsl:value-of select="$element/attribute[@key=$field_name]"/>
						</entry>
					</row>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="special_table[@type='module_author']" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="element" select="."/>
		<row>
			<entry namest="c1" nameend="c2" align="center">
				<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
				<xsl:value-of select="$L/METADATA_MODULE_AUTHOR"/>
			</entry>
		</row>
		<xsl:for-each select="descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
			<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="('first_name','second_name','email')">
			<xsl:variable name="label_prefix" select="string-join(('METADATA_MODULE_AUTHOR', upper-case(.)),'_')"/>
			<xsl:variable name="field_name" select="."/>
			<xsl:if test="$element/attribute[@key=$field_name]/text()">
				<row>
					<entry>
						<xsl:value-of select="$L/element()[local-name()=$label_prefix]"/>
					</entry>
					<entry>
						<xsl:value-of select="$element/attribute[@key=$field_name]"/>
					</entry>
				</row>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="core_curriculum_group_DOCBOOK_OUTPUT">
		<row>
			<entry namest="c1" nameend="c2" align="center">
				<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
				<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_GROUP"/>
			</entry>
		</row>
		<row>
			<entry>
				<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_EDUCATION_LEVEL"/>
				<xsl:value-of select="current-group()[1]/core-curriculum-stage/@key"/>
			</entry>
			<entry>
				<xsl:value-of select="current-group()[1]/core-curriculum-stage/text()"/>
			</entry>
		</row>
		<row>
			<entry>
				<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_SCHOOL"/>
				<xsl:value-of select="current-group()[1]/core-curriculum-school/@key"/>
			</entry>
			<entry>
				<xsl:value-of select="current-group()[1]/core-curriculum-school/text()"/>
			</entry>
		</row>
		<row>
			<entry>
				<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_SUBJECT"/>
				<xsl:value-of select="current-group()[1]/core-curriculum-subject/@key"/>
			</entry>
			<entry>
				<xsl:value-of select="current-group()[1]/core-curriculum-subject/text()"/>
			</entry>
		</row>
		<xsl:for-each select="current-group()/descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
			<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:for-each>
		<row colsep="0">
			<entry/>
			<entry align="center">
				<xsl:for-each select="current-group()">
					<xsl:choose>
						<xsl:when test="not(core-curriculum-version)">
							<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_OTHER"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="table">
								<tgroup cols="2">
									<colspec colname="c1" colwidth="1*"/>
									<colspec colname="c2" colwidth="3*"/>
									<tbody>
										<row colsep="0" rowsep="0">
											<entry>
												<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_VERSION"/>
												<xsl:value-of select="core-curriculum-version/@key"/>
											</entry>
											<entry>
												<xsl:value-of select="core-curriculum-version/text()"/>
											</entry>
										</row>
										<row colsep="0" rowsep="0">
											<entry>
												<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_CODE"/>
												<xsl:if test="'true'=core-curriculum-ability/@core-curriculum-main">
													<xsl:text> </xsl:text>
													<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_MAIN"/>
												</xsl:if>
											</entry>
											<entry>
												<xsl:value-of select="core-curriculum-ability/@key"/>
											</entry>
										</row>
										<row colsep="0" rowsep="0">
											<entry>
												<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_KEYWORD"/>
											</entry>
											<entry>
												<xsl:copy-of select="core-curriculum-ability/node()"/>
											</entry>
										</row>
									</tbody>
								</tgroup>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</entry>
		</row>
	</xsl:template>
	<xsl:template match="special_table[@type='module_keyword']" mode="DOCBOOK_OUTPUT">
		<xsl:variable name="element" select="."/>
		<xsl:for-each select="descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
			<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
				<xsl:with-param name="element" select="."/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:if test="$element/attribute[@key='md:keyword'] and ''!=$element/attribute[@key='md:keyword']">
			<row>
				<entry>
					<xsl:value-of select="$L/MODULE_KEYWORD"/>
				</entry>
				<entry>
					<xsl:value-of select="$element/attribute[@key='md:keyword']"/>
				</entry>
			</row>
		</xsl:if>
	</xsl:template>
	<xsl:template name="chapters_DOCBOOK_OUTPUT">
		<xsl:if test="$DOCXM_MAP_MY_ENTRY/chapters/chapter[1]">
			<row>
				<entry>
					<xsl:value-of select="$L/MODULE_CHAPTER"/>
				</entry>
				<entry>
					<xsl:value-of select="$DOCXM_MAP_MY_ENTRY/chapters/chapter[1]"/>
				</entry>
			</row>
			<xsl:if test="$DOCXM_MAP_MY_ENTRY/chapters/chapter[2]">
				<row>
					<entry>
						<xsl:value-of select="$L/MODULE_SUBCHAPTER_1"/>
					</entry>
					<entry>
						<xsl:value-of select="$DOCXM_MAP_MY_ENTRY/chapters/chapter[2]"/>
					</entry>
				</row>
				<xsl:if test="$DOCXM_MAP_MY_ENTRY/chapters/chapter[3]">
					<row>
						<entry>
							<xsl:value-of select="$L/MODULE_SUBCHAPTER_2"/>
						</entry>
						<entry>
							<xsl:value-of select="$DOCXM_MAP_MY_ENTRY/chapters/chapter[3]"/>
						</entry>
					</row>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="emit_base_module_info_table_DOCBOOK_OUTPUT">
		<table rowheader="firstcol">
			<tgroup cols="2">
				<colspec colname="c1" colwidth="1*"/>
				<colspec colname="c2" colwidth="3*"/>
				<tbody>
					<row>
						<entry namest="c1" nameend="c2" align="center">
							<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
							<xsl:value-of select="$L/BASE_MODULE_INFORMATION_TITLE"/>
						</entry>
					</row>
					<row>
						<entry>
							<xsl:value-of select="$L/MODULE_TITLE"/>
						</entry>
						<entry>
							<xsl:value-of select="string-join($ROOT/w:document/w:body/w:p[w:pPr/w:pStyle[@w:val='EPTytumoduu']]/w:r/w:t/text(),'')"/>
						</entry>
					</row>
					<xsl:if test="''!=$GLOBAL_METADATA/md:abstract">
						<row>
							<entry>
								<xsl:value-of select="$L/MODULE_ABSTRACT"/>
							</entry>
							<entry>
								<xsl:copy-of select="$GLOBAL_METADATA/md:abstract/node()"/>
							</entry>
						</row>
					</xsl:if>
					<row>
						<entry>
							<xsl:value-of select="$L/MODULE_LICENSE"/>
						</entry>
						<xsl:variable name="license">
							<xsl:choose>
								<xsl:when test="''!=$GLOBAL_METADATA/md:license">
									<xsl:value-of select="$GLOBAL_METADATA/md:license"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$LICENSES/license['true'=@default]/@key"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<entry>
							<ulink url="{$LICENSES/license[@key=$license]/url}">
								<xsl:value-of select="$LICENSES/license[@key=$license]/name"/>
							</ulink>
						</entry>
					</row>
					<row>
						<entry>
							<xsl:value-of select="$L/MODULE_LANGUAGE"/>
						</entry>
						<entry>
							<xsl:variable name="language">
								<xsl:choose>
									<xsl:when test="''!=$GLOBAL_METADATA/md:language">
										<xsl:value-of select="$GLOBAL_METADATA/md:language"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$LANGUAGES/language['true'=@default]/@key"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$LANGUAGES/language[@key=$language]/text()"/>
						</entry>
					</row>
					<xsl:call-template name="chapters_DOCBOOK_OUTPUT"/>
					<row>
						<entry>
							<xsl:value-of select="$L/MODULE_PROCESSED_TIME"/>
						</entry>
						<entry>
							<xsl:value-of select="format-dateTime(current-dateTime(),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
						</entry>
					</row>
					<xsl:if test="descendant::special_table[@type='module_keyword']">
						<row>
							<entry namest="c1" nameend="c2" align="center">
								<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
								<xsl:value-of select="$L/MODULE_KEYWORDS"/>
							</entry>
						</row>
						<xsl:apply-templates select="descendant::special_table[@type='module_keyword']" mode="DOCBOOK_OUTPUT"/>
					</xsl:if>
					<xsl:apply-templates select="descendant::special_table[@type='global_metadata']" mode="DOCBOOK_OUTPUT"/>
					<xsl:apply-templates select="descendant::special_table[@type='module_author']" mode="DOCBOOK_OUTPUT"/>
					<xsl:if test="0 &lt; count(descendant::special_table[@type='module_core_curriuculum_uspp']/element()[some $x in ('error','warn') satisfies $x=local-name()])">
						<row>
							<entry namest="c1" nameend="c2" align="center">
								<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
								<xsl:value-of select="$L/METADATA_MODULE_CORE_CURRICULUM_ERRORS"/>
							</entry>
						</row>
						<xsl:for-each select="descendant::special_table[@type='module_core_curriuculum_uspp']/element()[some $x in ('error','warn') satisfies $x=local-name()]">
							<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
								<xsl:with-param name="element" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:if>
					<xsl:for-each-group select="descendant::special_table[@type='module_core_curriuculum_uspp']/entry" group-by="string-join((core-curriculum-stage/text(),core-curriculum-school/text(),core-curriculum-subject/text()),'-')">
						<xsl:call-template name="core_curriculum_group_DOCBOOK_OUTPUT"/>
					</xsl:for-each-group>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>
	<xsl:template name="emit_section_info_table_DOCBOOK_OUTPUT">
		<xsl:param name="section_metadata" as="element()"/>
		<xsl:param name="title"/>
		<xsl:param name="entries"/>
		<table rowheader="firstcol">
			<tgroup cols="2">
				<colspec colname="c1" colwidth="1*"/>
				<colspec colname="c2" colwidth="3*"/>
				<tbody>
					<row>
						<entry namest="c1" nameend="c2" align="center">
							<xsl:call-template name="dblight-gray_DOCBOOK_OUTPUT"/>
							<xsl:value-of select="$title"/>
						</entry>
					</row>
					<xsl:for-each select="$section_metadata/descendant::element()[some $x in ('error','warn') satisfies $x=local-name()]">
						<xsl:call-template name="error_warn_table_row_DOCBOOK_OUTPUT">
							<xsl:with-param name="element" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:variable name="role" select="$section_metadata/attribute[@key='ep:role']"/>
					<xsl:if test="$role">
						<row>
							<entry>
								<xsl:value-of select="$L/METADATA_SECTION_ROLE"/>
							</entry>
							<entry>
								<xsl:choose>
									<xsl:when test="'NONE'=$role">
										<xsl:value-of select="$L/METADATA_SECTION_ROLE_NONE"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$role"/>
									</xsl:otherwise>
								</xsl:choose>
							</entry>
						</row>
					</xsl:if>
					<xsl:copy-of select="$entries"/>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>
	<xsl:template match="epconvert:EPXML_OUTPUT">
		<xsl:param name="elements" as="node()*"/>
		<xsl:apply-templates select="$elements" mode="EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template match="map" mode="EPXML_OUTPUT" priority="1">
		<document xmlns="http://cnx.rice.edu/cnxml" xmlns:md="http://cnx.rice.edu/mdml" xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:q="http://cnx.rice.edu/qml/1.0" xmlns:ep="http://epodreczniki.pl/" id="{$DOCXM_MAP_MY_ENTRY/id/text()}" module-id="{$DOCXM_MAP_MY_ENTRY/id/text()}" cnxml-version="0.7">
			<title>
				<xsl:value-of select="epconvert:select_text_for_element(module[1])"/>
			</title>
			<metadata mdml-version="0.5">
				<md:content-id>
					<xsl:value-of select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
				</md:content-id>
				<md:repository>https://<xsl:value-of select="$REPO_DOMAIN"/>/</md:repository>
				<md:version>1</md:version>
				<md:created>
					<xsl:value-of select="format-dateTime(adjust-dateTime-to-timezone($CORE/cp:coreProperties/dcterms:created,timezone-from-dateTime(current-dateTime())),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
				</md:created>
				<md:revised>
					<xsl:value-of select="format-dateTime(adjust-dateTime-to-timezone($CORE/cp:coreProperties/dcterms:modified,timezone-from-dateTime(current-dateTime())),concat('[Y0001]-[M01]-[D01] [H01]:[m01] ',if(timezone-from-dateTime(current-dateTime())=xs:dayTimeDuration('PT2H')) then 'CEST' else 'CET'))"/>
				</md:revised>
				<md:title>
					<xsl:value-of select="epconvert:select_text_for_element(module[1])"/>
				</md:title>
				<md:language>
					<xsl:choose>
						<xsl:when test="''!=$GLOBAL_METADATA/md:language">
							<xsl:value-of select="$GLOBAL_METADATA/md:language"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$LANGUAGES/language['true'=@default]/@key"/>
						</xsl:otherwise>
					</xsl:choose>
				</md:language>
				<xsl:variable name="license">
					<xsl:choose>
						<xsl:when test="''!=$GLOBAL_METADATA/md:license">
							<xsl:value-of select="$GLOBAL_METADATA/md:license"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$LICENSES/license['true'=@default]/@key"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<md:license url="{$LICENSES/license[@key=$license]/url}">
					<xsl:value-of select="$license"/>
				</md:license>
				<md:actors>
					<xsl:for-each select="$ROOT//w:tbl[descendant::w:tblDescription/@w:val='EP_AUTHOR']">
						<xsl:variable name="first_name">
							<xsl:call-template name="text_value_picker">
								<xsl:with-param name="tag" select="'EP_AUTOR_IMIE'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="second_name">
							<xsl:call-template name="text_value_picker">
								<xsl:with-param name="tag" select="'EP_AUTOR_NAZWISKO'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="email">
							<xsl:call-template name="text_value_picker">
								<xsl:with-param name="tag" select="'EP_AUTOR_EMAIL'"/>
							</xsl:call-template>
						</xsl:variable>
						<md:person userid="{epconvert:generate-id(.)}">
							<md:fullname>
								<xsl:value-of select="$first_name"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$second_name"/>
							</md:fullname>
							<md:firstname>
								<xsl:value-of select="$first_name"/>
							</md:firstname>
							<md:surname>
								<xsl:value-of select="$second_name"/>
							</md:surname>
							<md:email>
								<xsl:value-of select="$email"/>
							</md:email>
						</md:person>
					</xsl:for-each>
				</md:actors>
				<md:roles>
					<xsl:for-each select="$ROOT//w:tbl[descendant::w:tblDescription/@w:val='EP_AUTHOR']">
						<md:role type="author">
							<xsl:value-of select="epconvert:generate-id(.)"/>
						</md:role>
					</xsl:for-each>
				</md:roles>
				<xsl:if test="''!=$GLOBAL_METADATA/md:abstract">
					<md:abstract>
						<xsl:copy-of select="$GLOBAL_METADATA/md:abstract/node()"/>
					</md:abstract>
				</xsl:if>
				<xsl:if test="descendant::special_table[@type='module_keyword']">
					<md:keywordlist>
						<xsl:for-each select="descendant::special_table[@type='module_keyword']">
							<md:keyword>
								<xsl:value-of select="attribute[@key='md:keyword']"/>
							</md:keyword>
						</xsl:for-each>
					</md:keywordlist>
				</xsl:if>
				<ep:e-textbook-module ep:version="1.5" ep:recipient="{$GLOBAL_METADATA/ep:recipient}" ep:content-status="{$GLOBAL_METADATA/ep:status}">
					<xsl:variable name="type" select="$GLOBAL_METADATA/ep:type"/>
					<xsl:variable name="subtype" select="$GLOBAL_METADATA/subtype"/>
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:element name="ep:presentation">
						<xsl:if test="'teacher'=$GLOBAL_METADATA/ep:recipient or 'true'=$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$subtype]/module[type=$type]/skipNumbering">
							<xsl:element name="ep:numbering">skip</xsl:element>
						</xsl:if>
						<xsl:if test="'NONE'!=$type">
							<xsl:element name="ep:type">
								<xsl:value-of select="$GLOBAL_METADATA/subtype"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($type))"/>
							</xsl:element>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="'NONE'=$template or 'COLUMNS'=$template">
								<xsl:element name="ep:template">linear</xsl:element>
							</xsl:when>
							<xsl:when test="'FREEFORM'=$template">
								<xsl:element name="ep:template">freeform</xsl:element>
								<xsl:element name="ep:width">
									<xsl:value-of select="$GLOBAL_METADATA/ep:grid-width"/>
								</xsl:element>
								<xsl:element name="ep:height">
									<xsl:value-of select="$GLOBAL_METADATA/ep:grid-height"/>
								</xsl:element>
								<xsl:element name="ep:fixed-tile-layout">false</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="ep:template">
									<xsl:value-of select="$template"/>
								</xsl:element>
								<xsl:element name="ep:width">
									<xsl:value-of select="$TEMPLATE_MAPPINGS/template[key=$template]/gridWidth"/>
								</xsl:element>
								<xsl:element name="ep:height">
									<xsl:value-of select="$TEMPLATE_MAPPINGS/template[key=$template]/gridHeight"/>
								</xsl:element>
								<xsl:element name="ep:fixed-tile-layout">false</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<ep:core-curriculum-entries>
						<xsl:for-each-group select="descendant::special_table[@type='module_core_curriuculum_uspp']/entry" group-by="string-join((core-curriculum-stage/text(),core-curriculum-school/text(),core-curriculum-subject/text()),'-')">
							<xsl:for-each select="current-group()">
								<ep:core-curriculum-entry>
									<xsl:for-each select="element()">
										<xsl:element name="{concat('ep:',local-name())}">
											<xsl:for-each select="attribute()">
												<xsl:attribute name="{concat('ep:',local-name())}" select="."/>
											</xsl:for-each>
											<xsl:apply-templates select="node()" mode="CORE_CURRICULUM_ENTRY_2_EPXML"/>
										</xsl:element>
									</xsl:for-each>
								</ep:core-curriculum-entry>
							</xsl:for-each>
						</xsl:for-each-group>
					</ep:core-curriculum-entries>
				</ep:e-textbook-module>
			</metadata>
			<content>
				<xsl:copy-of select="epconvert:process(.,'EPXML_OUTPUT')"/>
			</content>
			<xsl:if test="descendant::special_table[@type='bibliography_entry']">
				<xsl:element name="bib:file" namespace="http://bibtexml.sf.net/">
					<xsl:apply-templates select="descendant::special_table[@type='bibliography_entry']" mode="EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:if>
		</document>
	</xsl:template>
	<xsl:template match="subscript" mode="CORE_CURRICULUM_ENTRY_2_EPXML">
		<cnxml:sub>
			<xsl:copy-of select="node()"/>
		</cnxml:sub>
	</xsl:template>
	<xsl:template match="superscript" mode="CORE_CURRICULUM_ENTRY_2_EPXML">
		<cnxml:sup>
			<xsl:copy-of select="node()"/>
		</cnxml:sup>
	</xsl:template>
	<xsl:template match="element()" mode="CORE_CURRICULUM_ENTRY_2_EPXML">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="module" mode="EPXML_OUTPUT" priority="1">
		<xsl:if test="element()[not(some $x in ('separator','header1') satisfies local-name()=$x)]">
			<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
				<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
				<xsl:variable name="group" as="element()">
					<xsl:element name="group">
						<xsl:copy-of select="element()[not(self::header1 or preceding-sibling::header1 or following-sibling::element()[1][local-name()='header1'])]"/>
					</xsl:element>
				</xsl:variable>
				<xsl:apply-templates select="special_table[starts-with(@type,'section_metadata_')]" mode="EPXML_OUTPUT"/>
				<xsl:copy-of select="epconvert:process($group,'EPXML_OUTPUT')"/>
			</xsl:element>
		</xsl:if>
		<xsl:apply-templates select="header1" mode="EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template match="header1|header2|header3" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:if test="special_table[starts-with(@type,'section_metadata_')]/attribute[@key='ep:recipient'] and 'teacher'=special_table[starts-with(@type,'section_metadata_')]/attribute[@key='ep:recipient']">
				<xsl:attribute name="ep:recipient">teacher</xsl:attribute>
			</xsl:if>
			<xsl:if test="special_table[starts-with(@type,'section_metadata_')]/attribute[@key='ep:status'] and (some $x in ('expanding','supplemental') satisfies $x=special_table[starts-with(@type,'section_metadata_')]/attribute[@key='ep:status'])">
				<xsl:attribute name="ep:content-status"><xsl:value-of select="special_table[starts-with(@type,'section_metadata_')]/attribute[@key='ep:status']"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="special_table[starts-with(@type,'section_metadata_')]" mode="EPXML_OUTPUT"/>
			<xsl:if test="not(special_table[starts-with(@type,'section_metadata_')]/attribute[@key='hide-section-title']) or 'true'!=special_table[starts-with(@type,'section_metadata_')]/attribute[@key='hide-section-title']">
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:value-of select="epconvert:select_text_for_element(.)"/>
				</xsl:element>
			</xsl:if>
			<xsl:copy-of select="epconvert:process(.,'EPXML_OUTPUT')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_linear']" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="role" select="attribute[@key='ep:role']"/>
		<xsl:element name="ep:parameters">
			<xsl:if test="'NONE'!=$role">
				<xsl:element name="ep:role">
					<xsl:value-of select="$GLOBAL_METADATA/subtype"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($GLOBAL_METADATA/ep:type))"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($role))"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="ep:columns">
				<xsl:value-of select="attribute[@key='ep:columns']"/>
			</xsl:element>
			<xsl:if test="'true'=attribute[@key='ep:start-new-page']">
				<xsl:element name="ep:start-new-page">true</xsl:element>
			</xsl:if>
			<xsl:if test="'true'=attribute[@key='ep:foldable']">
				<xsl:element name="ep:foldable">true</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_linear_l2']" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:parameters">
			<xsl:element name="ep:width">
				<xsl:value-of select="attribute[@key='ep:width']"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_freeform']" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="role" select="attribute[@key='ep:role']"/>
		<xsl:variable name="section_attributes" select="."/>
		<xsl:element name="ep:parameters">
			<xsl:if test="'NONE'!=$role">
				<xsl:element name="ep:role">
					<xsl:value-of select="$GLOBAL_METADATA/subtype"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($GLOBAL_METADATA/ep:type))"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($role))"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="('ep:left','ep:top','ep:width','ep:height')">
				<xsl:variable name="key" select="."/>
				<xsl:element name="{$key}">
					<xsl:value-of select="$section_attributes/attribute[@key=$key]"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="special_table[@type='section_metadata_tile']" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="role" select="attribute[@key='ep:role']"/>
		<xsl:variable name="tile_key" select="attribute[@key='ep:tile']"/>
		<xsl:variable name="tile" select="$TEMPLATE_MAPPINGS/template[key=$GLOBAL_METADATA/ep:template]/tile[key=$tile_key]"/>
		<xsl:element name="ep:parameters">
			<xsl:if test="'NONE'!=$role">
				<xsl:element name="ep:role">
					<xsl:value-of select="$GLOBAL_METADATA/subtype"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($GLOBAL_METADATA/ep:type))"/>_<xsl:value-of select="ep:only_alpha_numeric(ep:only_ascii($role))"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="ep:tile">
				<xsl:value-of select="$tile/key"/>
			</xsl:element>
			<xsl:for-each select="('left','top','width','height')">
				<xsl:variable name="key" select="."/>
				<xsl:element name="{string-join(('ep',$key),':')}">
					<xsl:value-of select="$tile/element()[local-name()=$key]"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="special_table[@type='bibliography_entry']" mode="EPXML_OUTPUT" priority="1">
		<xsl:param name="bibliography_entry" select="."/>
		<xsl:param name="global-ids" tunnel="yes" select="false()" as="xs:boolean"/>
		<xsl:variable name="validate" select="$bibliography_entry/attribute[@key='validate']"/>
		<xsl:element name="bib:entry">
			<xsl:variable name="name" select="$bibliography_entry/attribute[@key='id']/text()"/>
			<xsl:attribute name="id" select="if($global-ids) then epconvert:resolve-bibliography-id-global(.,preceding::special_table[@type='bibliography_entry']) else epconvert:resolve-bibliography-id-local(.,preceding::special_table[@type='bibliography_entry'])"/>
			<xsl:attribute name="ep:target-name" select="$name"/>
			<xsl:if test="not($global-ids)">
				<xsl:attribute name="ep:show-in"><xsl:choose><xsl:when test="$bibliography_entry[attribute[@key='display_in_module' and 'true'=text()]]">bibliography-and-module</xsl:when><xsl:otherwise>bibliography-only</xsl:otherwise></xsl:choose></xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="'article'=$validate">
					<xsl:element name="bib:article">
						<xsl:for-each select="$bibliography_entry/element[@id='author']">
							<xsl:call-template name="bibliography_author_EPXML_OUTPUT"/>
						</xsl:for-each>
						<xsl:for-each select="('title','journal','year','number')">
							<xsl:variable name="key" select="."/>
							<xsl:if test="$bibliography_entry/attribute[@key=$key]">
								<xsl:element name="bib:{$key}">
									<xsl:value-of select="$bibliography_entry/attribute[@key=$key]/text()"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				<xsl:when test="some $x in ('book','bookpart') satisfies $x=$validate">
					<xsl:element name="bib:incollection">
						<xsl:for-each select="$bibliography_entry/element[@id='author']">
							<xsl:call-template name="bibliography_author_EPXML_OUTPUT"/>
						</xsl:for-each>
						<xsl:for-each select="('title','booktitle','publisher','year')">
							<xsl:variable name="key" select="."/>
							<xsl:if test="$bibliography_entry/attribute[@key=$key]">
								<xsl:element name="bib:{$key}">
									<xsl:value-of select="$bibliography_entry/attribute[@key=$key]/text()"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:for-each select="$bibliography_entry/element[@id='editor']">
							<xsl:call-template name="bibliography_editor_EPXML_OUTPUT"/>
						</xsl:for-each>
						<xsl:if test="$bibliography_entry/attribute[@key='series']/text()">
							<xsl:element name="bib:series">
								<xsl:value-of select="$bibliography_entry/attribute[@key='series']/text()"/>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="pages-start" select="$bibliography_entry/attribute[@key='pages-start']/text()"/>
						<xsl:variable name="pages-end" select="$bibliography_entry/attribute[@key='pages-end']/text()"/>
						<xsl:if test="$pages-start and $pages-end">
							<xsl:element name="bib:pages">
								<xsl:value-of select="$pages-start"/> - <xsl:value-of select="$pages-end"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$bibliography_entry/attribute[@key='address']">
							<xsl:element name="bib:address">
								<xsl:value-of select="$bibliography_entry/attribute[@key='address']/text()"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:when>
				<xsl:when test="'report'=$validate">
					<xsl:element name="bib:unpublished">
						<xsl:for-each select="$bibliography_entry/element[@id='author']">
							<xsl:call-template name="bibliography_author_EPXML_OUTPUT"/>
						</xsl:for-each>
						<xsl:for-each select="('title','note','year')">
							<xsl:variable name="key" select="."/>
							<xsl:if test="$bibliography_entry/attribute[@key=$key]">
								<xsl:element name="bib:{$key}">
									<xsl:value-of select="$bibliography_entry/attribute[@key=$key]/text()"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				<xsl:when test="'act'=$validate">
					<xsl:element name="bib:manual">
						<xsl:for-each select="('title','organization','edition','key')">
							<xsl:variable name="key" select="."/>
							<xsl:if test="$bibliography_entry/attribute[@key=$key]">
								<xsl:element name="bib:{$key}">
									<xsl:value-of select="$bibliography_entry/attribute[@key=$key]/text()"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				<xsl:when test="'web'=$validate">
					<xsl:element name="bib:misc">
						<xsl:for-each select="$bibliography_entry/element[@id='author']">
							<xsl:call-template name="bibliography_author_EPXML_OUTPUT"/>
						</xsl:for-each>
						<xsl:for-each select="('title','howpublished','note')">
							<xsl:variable name="key" select="."/>
							<xsl:if test="$bibliography_entry/attribute[@key=$key]">
								<xsl:element name="bib:{$key}">
									<xsl:value-of select="$bibliography_entry/attribute[@key=$key]/text()"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="bibliography_author_EPXML_OUTPUT">
		<xsl:element name="bib:author">
			<xsl:call-template name="bibliography_author_or_editor_body_EPXML_OUTPUT"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="bibliography_editor_EPXML_OUTPUT">
		<xsl:element name="bib:editor">
			<xsl:call-template name="bibliography_author_or_editor_body_EPXML_OUTPUT"/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="bibliography_author_or_editor_body_EPXML_OUTPUT">
		<xsl:variable name="persons" select="."/>
		<xsl:variable name="multiple_values" select="if($persons/attribute[@multiple_value='true']) then true() else false()" as="xs:boolean"/>
		<xsl:choose>
			<xsl:when test="$multiple_values">
				<xsl:variable name="count" select="count($persons/attribute[@key='surname']/value)"/>
				<xsl:for-each select="1 to $count">
					<xsl:variable name="i" select="."/>
					<xsl:value-of select="$persons/attribute[@key='surname']/value[$i]"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$persons/attribute[@key='name']/value[$i]"/>
					<xsl:if test=".!=$count">, </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$persons/attribute[@key='surname']"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$persons/attribute[@key='name']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="bookmark" mode="EPXML_OUTPUT" priority="1">
		<ep:bookmark ep:id="{@id}" ep:name="{@name}"/>
	</xsl:template>
	<xsl:template match="para|table|WOMI" mode="EPXML_OUTPUT" priority="1">
		<xsl:apply-templates select="bookmark" mode="EPXML_OUTPUT"/>
		<xsl:apply-templates select="epconvert:select_element_for_processing(@position)" mode="EPXML_OUTPUT">
			<xsl:with-param name="context" select="node()"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="list" mode="EPXML_OUTPUT" priority="1">
		<xsl:apply-templates select="bookmark" mode="EPXML_OUTPUT"/>
		<xsl:variable name="numId" select="list_item[1]/@numId"/>
		<xsl:variable name="ilvl" select="list_item[1]/@ilvl"/>
		<xsl:variable name="lp" select="$LISTS_MAP/lists-map/list[@numId=$numId]/lvl[@ilvl=$ilvl]"/>
		<xsl:element name="list" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:choose>
				<xsl:when test="$lp/type/text()='itemizedlist'">
					<xsl:attribute name="list-type" select="'bulleted'"/>
				</xsl:when>
				<xsl:when test="$lp/type/text()='itemizedlist' and $lp/mark">
					<xsl:attribute name="list-type" select="'bulleted'"/>
					<xsl:attribute name="bullet-style" select="$lp/mark/text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="list-type" select="'enumerated'"/>
					<xsl:attribute name="number-style"><xsl:choose><xsl:when test="$lp/numeration/text()='lowerroman'">lower-roman</xsl:when><xsl:when test="$lp/numeration/text()='upperroman'">upper-roman</xsl:when><xsl:when test="$lp/numeration/text()='loweralpha'">lower-alpha</xsl:when><xsl:when test="$lp/numeration/text()='upperalpha'">upper-alpha</xsl:when><xsl:when test="$lp/numeration/text()='arabic'">arabic</xsl:when></xsl:choose></xsl:attribute>
					<xsl:if test="1 &lt; $lp/start/text()">
						<xsl:attribute name="start-value" select="$lp/start/text()"/>
					</xsl:if>
					<xsl:if test="$lp/prefix/text()!=''">
						<xsl:attribute name="mark-prefix" select="$lp/prefix/text()"/>
					</xsl:if>
					<xsl:if test="$lp/postfix/text()!=''">
						<xsl:attribute name="mark-suffix" select="$lp/postfix/text()"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@special_block='true'">
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:apply-templates select="element()[local-name()='name']/*" mode="EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="element()[local-name()!='name']">
				<xsl:apply-templates select="." mode="EPXML_OUTPUT"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="list_item" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="item" namespace="http://cnx.rice.edu/cnxml">
			<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
				<xsl:attribute name="id" select="string-join((epconvert:generate-id(.),'li'),'')"/>
				<xsl:apply-templates select="bookmark" mode="EPXML_OUTPUT"/>
				<xsl:apply-templates select="epconvert:select_element_for_processing(@position)" mode="EPXML_OUTPUT">
					<xsl:with-param name="context" select="node()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="element()[some $x in ('WOMI','table','para') satisfies $x=local-name()]" mode="EPXML_OUTPUT"/>
				<xsl:if test="element()[local-name()='list_item']">
					<xsl:variable name="list">
						<xsl:element name="list">
							<xsl:copy-of select="element()[local-name()='list_item']"/>
						</xsl:element>
					</xsl:variable>
					<xsl:apply-templates select="$list" mode="EPXML_OUTPUT"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="group" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="style" select="element()[not(some $x in ('','normal') satisfies @style=$x)]/@style"/>
		<xsl:choose>
			<xsl:when test="$style">
				<xsl:choose>
					<xsl:when test="some $x in ('EPNotatka-wskazwka','EPNotka-wskazwka') satisfies $style=$x">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'tip'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="some $x in ('EPNotatka-ostrzeenie','EPNotka-ostrzeenie') satisfies $style=$x">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'warning'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="some $x in ('EPNotatka-wane','EPNotka-wane') satisfies $style=$x">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'important'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPNotka-ciekawostka'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'curiosity'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPNotka-zapamitaj'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'remember'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPCytatakapit'">
						<xsl:element name="quote" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPKodakapit'">
						<xsl:element name="code" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="display" select="'block'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPKomentarztechniczny'">
						<xsl:element name="ep:technical-remarks">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPPrzykad'">
						<xsl:element name="example" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPPolecenie'">
						<xsl:element name="ep:command">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="problem" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'problem')"/>
								<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'problempara')"/>
									<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPLead'">
						<xsl:element name="ep:lead">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPIntro'">
						<xsl:element name="ep:intro">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPPrzygotujprzedlekcj'">
						<xsl:element name="ep:prerequisite">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPNauczyszsi'">
						<xsl:element name="ep:effect">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPPrzypomnijsobie'">
						<xsl:element name="ep:revisal">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPOdziele'">
						<xsl:element name="ep:literary-work-description">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$style='EPStreszczenie'">
						<xsl:element name="ep:literary-work-summary">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
					<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
					<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="multi_para_block_EPXML_OUTPUT">
		<xsl:for-each select="element()">
			<xsl:apply-templates select="." mode="EPXML_OUTPUT"/>
			<xsl:if test="local-name(.)='para' and not(position()=last()) and local-name(following-sibling::element()[1])='para'">
				<xsl:call-template name="br_EPXML_OUTPUT"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="homework" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:student-work">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="ep:type" select="'homework'"/>
			<xsl:copy-of select="epconvert:process(.,'EPXML_OUTPUT')"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="definition" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="glossary" select="@glossary-declaration"/>
		<xsl:element name="definition" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:resolve-glossary-id-local(.,(),'definitions')"/>
			<xsl:attribute name="ep:glossary" select="$glossary"/>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='name'">
						<xsl:element name="term" namespace="http://cnx.rice.edu/cnxml">
							<xsl:apply-templates select="element()" mode="EPXML_OUTPUT"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='meaning'">
						<xsl:element name="meaning" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='example'">
						<xsl:element name="example" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="concept" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="glossary" select="@glossary-declaration"/>
		<xsl:element name="ep:concept">
			<xsl:attribute name="id" select="epconvert:resolve-concept-id-local(.,())"/>
			<xsl:attribute name="ep:glossary" select="$glossary"/>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='name'">
						<xsl:element name="term" namespace="http://cnx.rice.edu/cnxml">
							<xsl:apply-templates select="element()" mode="EPXML_OUTPUT"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='meaning'">
						<xsl:element name="meaning" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='example'">
						<xsl:element name="example" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="cite" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="cite_subtype" select="@cite_subtype"/>
		<xsl:element name="quote" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:copy-of select="@*[some $x in ('type','readability','start-numbering','presentation') satisfies $x=local-name()]"/>
			<xsl:element name="label" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="author">
				<xsl:element name="ep:author" namespace="http://epodreczniki.pl/">
					<xsl:apply-templates select="element()" mode="EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:for-each>
			<xsl:if test="comment">
				<xsl:element name="ep:comment" namespace="http://epodreczniki.pl/">
					<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'comment')"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'commentpara')"/>
						<xsl:for-each select="comment">
							<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:if>
			<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
				<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
				<xsl:for-each select="content">
					<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="rule" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="glossary" select="@glossary-declaration"/>
		<xsl:element name="rule" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:resolve-glossary-id-local(.,(),'rules')"/>
			<xsl:attribute name="ep:glossary" select="$glossary"/>
			<xsl:if test="@type and 'lack'!=@type">
				<xsl:variable name="rule_type" select="@type"/>
				<xsl:attribute name="type" select="$EP_RULE_TYPES/rule_type[@key=$rule_type]/text()"/>
			</xsl:if>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='statement'">
						<xsl:element name="statement" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='proof'">
						<xsl:element name="proof" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='example'">
						<xsl:element name="example" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="exercise" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="exercise_subtype" select="@exercise_subtype"/>
		<xsl:variable name="exercise_common_components">
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='problem'">
						<xsl:element name="problem" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='tip'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'tip'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='solution'">
						<xsl:element name="solution" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='commentary'">
						<xsl:element name="commentary" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='example'">
						<xsl:element name="commentary" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="'example'"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:element name="exercise" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:copy-of select="@*[some $x in ('interactivity','context-dependent') satisfies $x=local-name()]"/>
			<xsl:choose>
				<xsl:when test="$exercise_subtype='MAT'">
					<xsl:if test="@ep:on-paper">
						<xsl:attribute name="ep:on-paper" select="@ep:on-paper"/>
					</xsl:if>
					<xsl:element name="ep:effect-of-education">
						<xsl:value-of select="@effect-of-education"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$exercise_subtype='JPOL3'">
					<xsl:attribute name="type" select="@type"/>
					<xsl:element name="ep:effect-of-education">
						<xsl:value-of select="@effect-of-education"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="@alternative_WOMI">
					<xsl:element name="ep:alternatives">
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative1')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">classicmobile</xsl:element>
							</xsl:element>
							<xsl:element name="ep:reference">
								<xsl:attribute name="ep:id" select="@alternative_WOMI"/>
								<xsl:attribute name="ep:instance-id" select="concat(epconvert:generate-id(.),'WOMI')"/>
								<xsl:element name="ep:hide-caption">all</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative2')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">static</xsl:element>
								<xsl:element name="ep:format">static-mono</xsl:element>
							</xsl:element>
							<xsl:copy-of select="$exercise_common_components"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$exercise_common_components"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="exercise_WOMI" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="context-dependent" select="@ep:context-dependent"/>
		<xsl:variable name="exercise_subtype" select="@exercise_subtype"/>
		<xsl:variable name="effect-of-education" select="@effect-of-education"/>
		<xsl:element name="exercise" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="ep:context-dependent" select="if ($context-dependent='true') then true() else false()"/>
			<xsl:attribute name="ep:interactivity" select="'womi_with_alternatives'"/>
			<xsl:attribute name="type" select="'WOMI'"/>
			<xsl:if test="$exercise_subtype='MAT'">
				<xsl:element name="ep:effect-of-education">
					<xsl:value-of select="$effect-of-education"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="ep:reference">
				<xsl:attribute name="ep:id" select="@WOMI_id"/>
				<xsl:attribute name="ep:instance-id" select="concat(epconvert:generate-id(.),'WOMI')"/>
				<xsl:element name="ep:hide-caption">all</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="exercise_set" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:student-work">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="ep:type" select="'exercise-set'"/>
			<xsl:for-each select="command">
				<xsl:element name="problem" namespace="http://cnx.rice.edu/cnxml">
					<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
						<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="WOMI_exercise">
				<xsl:element name="exercise" namespace="http://cnx.rice.edu/cnxml">
					<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
					<xsl:attribute name="ep:context-dependent" select="'true'"/>
					<xsl:attribute name="ep:interactivity" select="'womi_with_alternatives'"/>
					<xsl:attribute name="type" select="'WOMI'"/>
					<xsl:element name="ep:reference">
						<xsl:attribute name="ep:id" select="@id"/>
						<xsl:attribute name="ep:instance-id" select="concat(epconvert:generate-id(.),'WOMI')"/>
						<xsl:element name="ep:hide-caption">all</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="command" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:command">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='problem'">
						<xsl:element name="problem" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='note'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="@type"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tooltip" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:tooltip">
			<xsl:variable name="name" select="epconvert:select_text_for_element(name/*)"/>
			<xsl:attribute name="ep:id" select="epconvert:resolve-tooltip-id($name,())"/>
			<xsl:copy-of select="@ep:type"/>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/*" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="content">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
						<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="procedure-instructions" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:procedure-instructions">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/*" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="step">
				<xsl:element name="ep:step">
					<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
						<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="codeblock" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="code" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="display" select="'block'"/>
			<xsl:attribute name="lang" select="@language"/>
			<xsl:if test="name">
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:apply-templates select="name/*" mode="EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:if>
			<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
				<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
				<xsl:call-template name="br_EPXML_OUTPUT"/>
				<xsl:for-each select="element()[not(local-name()='name')]">
					<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="quiz" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="quiz_subtype" select="@quiz_subtype"/>
		<xsl:variable name="quiz_variant" select="@quiz_variant"/>
		<xsl:variable name="behaviour" select="@ep:behaviour"/>
		<xsl:variable name="presented-answers" select="@ep:presented-answers"/>
		<xsl:variable name="correct-in-set-min" select="@ep:correct-in-set-min"/>
		<xsl:variable name="correct-in-set-max" select="@ep:correct-in-set-max"/>
		<xsl:variable name="quiz_static_qitem">
			<xsl:variable name="answer_id_base" select="concat(epconvert:generate-id(.),'answer')"/>
			<xsl:variable name="correct_answers" as="element()">
				<correct_answers>
					<xsl:choose>
						<xsl:when test="not($behaviour) or 'all-sets'=$behaviour">
							<xsl:for-each select="descendant::answer">
								<xsl:if test="'true'=@correct">
									<answer>
										<xsl:value-of select="concat($answer_id_base,position())"/>
									</answer>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="descendant::answer[position() &lt;= $presented-answers]">
								<xsl:if test="'true'=@correct">
									<answer>
										<xsl:value-of select="concat($answer_id_base,position())"/>
									</answer>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</correct_answers>
			</xsl:variable>
			<xsl:element name="q:item">
				<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'item')"/>
				<xsl:attribute name="type" select="@quiz_type"/>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='question'">
							<xsl:element name="q:question">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='answer'">
							<xsl:element name="q:answer">
								<xsl:attribute name="id" select="concat($answer_id_base,count(preceding-sibling::answer)+1)"/>
								<xsl:element name="q:response">
									<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
										<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
											<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
											<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='answer-group'">
							<xsl:if test="count(preceding-sibling::answer-group) &lt; $presented-answers">
								<xsl:call-template name="answer-group_EPXML_OUTPUT">
									<xsl:with-param name="answer_id_base" select="$answer_id_base"/>
									<xsl:with-param name="answer_id_counter_start" select="0"/>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:when test="local-name()='answer-set'">
							<xsl:if test="not(preceding-sibling::answer-set) or 'all-sets'=$behaviour">
								<xsl:call-template name="answer-set_EPXML_OUTPUT">
									<xsl:with-param name="answers" select="answer-group"/>
									<xsl:with-param name="answer_id_base" select="$answer_id_base"/>
									<xsl:with-param name="answer_id_counter_start" select="xs:integer(count(preceding-sibling::answer-set) * $presented-answers)"/>
									<xsl:with-param name="in-set">
										<xsl:if test="'all-sets'=$behaviour">
											<xsl:value-of select="@ep:in-set"/>
										</xsl:if>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:when>
						<xsl:when test="local-name()='hint'">
							<xsl:element name="q:hint">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='feedback'">
							<xsl:element name="q:feedback">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:element name="q:key">
					<xsl:attribute name="answer"><xsl:for-each select="$correct_answers/answer"><xsl:value-of select="text()"/><xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:variable name="quiz_dynamic_qitem">
			<xsl:variable name="answer_id_base" select="concat(epconvert:generate-id(.),'answerd')"/>
			<xsl:variable name="correct_answers" as="element()">
				<correct_answers>
					<xsl:for-each select="descendant::answer">
						<xsl:if test="'true'=@correct">
							<answer>
								<xsl:value-of select="concat($answer_id_base,position())"/>
							</answer>
						</xsl:if>
					</xsl:for-each>
				</correct_answers>
			</xsl:variable>
			<xsl:element name="q:item">
				<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'itemd')"/>
				<xsl:attribute name="type" select="@quiz_type"/>
				<xsl:for-each select="element()">
					<xsl:choose>
						<xsl:when test="local-name()='question'">
							<xsl:element name="q:question">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'d')"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='answer'">
							<xsl:element name="q:answer">
								<xsl:attribute name="id" select="concat($answer_id_base,count(preceding-sibling::answer)+1)"/>
								<xsl:element name="q:response">
									<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'d')"/>
										<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
											<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
											<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='answer-group'">
							<xsl:call-template name="answer-group_EPXML_OUTPUT">
								<xsl:with-param name="answer_id_base" select="$answer_id_base"/>
								<xsl:with-param name="answer_inner_id_postfix" select="'d'"/>
								<xsl:with-param name="answer_id_counter_start" select="0"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="local-name()='answer-set'">
							<xsl:call-template name="answer-set_EPXML_OUTPUT">
								<xsl:with-param name="answers" select="answer-group"/>
								<xsl:with-param name="answer_id_base" select="$answer_id_base"/>
								<xsl:with-param name="answer_inner_id_postfix" select="'d'"/>
								<xsl:with-param name="answer_id_counter_start" select="xs:integer(count(preceding-sibling::answer-set) * $presented-answers)"/>
								<xsl:with-param name="in-set" select="@ep:in-set"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="local-name()='hint'">
							<xsl:element name="q:hint">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'d')"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="local-name()='feedback'">
							<xsl:element name="q:feedback">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'d')"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:element name="q:key">
					<xsl:attribute name="answer"><xsl:for-each select="$correct_answers/answer"><xsl:value-of select="text()"/><xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each></xsl:attribute>
					<xsl:if test="feedback_correct">
						<xsl:element name="q:feedback">
							<xsl:attribute name="correct">yes</xsl:attribute>
							<xsl:for-each select="feedback_correct">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					<xsl:if test="feedback_incorrect">
						<xsl:element name="q:feedback">
							<xsl:attribute name="correct">no</xsl:attribute>
							<xsl:for-each select="feedback_incorrect">
								<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
									<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
									<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
										<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'parad')"/>
										<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="exercise" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:copy-of select="@ep:context-dependent"/>
			<xsl:choose>
				<xsl:when test="''!=$quiz_variant">
					<xsl:attribute name="ep:interactivity">random_quiz</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ep:interactivity">quiz</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$quiz_subtype='MAT'">
					<xsl:element name="ep:effect-of-education">
						<xsl:value-of select="@effect-of-education"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$quiz_subtype='JPOL3'">
					<xsl:attribute name="type" select="@type"/>
					<xsl:element name="ep:effect-of-education">
						<xsl:value-of select="@effect-of-education"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="name">
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
				</xsl:element>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="''!=$quiz_variant">
					<xsl:element name="ep:alternatives">
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative1')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">classicmobile</xsl:element>
							</xsl:element>
							<xsl:element name="ep:config">
								<xsl:element name="ep:behaviour">
									<xsl:value-of select="$behaviour"/>
								</xsl:element>
								<xsl:element name="ep:presented-answers">
									<xsl:value-of select="$presented-answers"/>
								</xsl:element>
								<xsl:if test="'randomize'=$behaviour and 'ZJ-1'!=$quiz_variant">
									<xsl:element name="ep:correct-in-set">
										<xsl:choose>
											<xsl:when test="$correct-in-set-min=$correct-in-set-max">
												<xsl:value-of select="$correct-in-set-min"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$correct-in-set-min"/>-<xsl:value-of select="$correct-in-set-max"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:element>
								</xsl:if>
								<xsl:if test="'ZW-2'=$quiz_variant">
									<xsl:element name="ep:presentation-style">true-false</xsl:element>
								</xsl:if>
							</xsl:element>
							<xsl:copy-of select="$quiz_dynamic_qitem"/>
						</xsl:element>
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative2')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">static</xsl:element>
								<xsl:element name="ep:format">static-mono</xsl:element>
							</xsl:element>
							<xsl:copy-of select="$quiz_static_qitem"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:when test="@alternative_WOMI">
					<xsl:element name="ep:alternatives">
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative1')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">classicmobile</xsl:element>
							</xsl:element>
							<xsl:element name="ep:reference">
								<xsl:attribute name="ep:id" select="@alternative_WOMI"/>
								<xsl:attribute name="ep:instance-id" select="concat(epconvert:generate-id(.),'WOMI')"/>
								<xsl:element name="ep:hide-caption">all</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:element name="ep:alternative">
							<xsl:attribute name="ep:id" select="concat(epconvert:generate-id(.),'alternative2')"/>
							<xsl:element name="ep:formats">
								<xsl:element name="ep:format">static</xsl:element>
								<xsl:element name="ep:format">static-mono</xsl:element>
							</xsl:element>
							<xsl:copy-of select="$quiz_static_qitem"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$quiz_static_qitem"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="answer-set_EPXML_OUTPUT">
		<xsl:param name="answers" as="node()*"/>
		<xsl:param name="answer_id_base"/>
		<xsl:param name="answer_inner_id_postfix"/>
		<xsl:param name="answer_id_counter_start" as="xs:integer"/>
		<xsl:param name="in-set"/>
		<xsl:for-each select="$answers[local-name()='answer-group']">
			<xsl:call-template name="answer-group_EPXML_OUTPUT">
				<xsl:with-param name="answer_id_base" select="$answer_id_base"/>
				<xsl:with-param name="answer_inner_id_postfix" select="$answer_inner_id_postfix"/>
				<xsl:with-param name="answer_id_counter_start" select="$answer_id_counter_start"/>
				<xsl:with-param name="in-set" select="$in-set"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="answer-group_EPXML_OUTPUT">
		<xsl:param name="answer_id_base"/>
		<xsl:param name="answer_inner_id_postfix" select="''"/>
		<xsl:param name="answer_id_counter_start" as="xs:integer" select="0"/>
		<xsl:param name="in-set"/>
		<xsl:element name="q:answer">
			<xsl:attribute name="id" select="concat($answer_id_base,count(preceding-sibling::answer-group)+$answer_id_counter_start+1)"/>
			<xsl:if test="''!=$in-set">
				<xsl:attribute name="ep:in-set" select="$in-set"/>
			</xsl:if>
			<xsl:for-each select="answer">
				<xsl:element name="q:response">
					<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),$answer_inner_id_postfix)"/>
						<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="concat(concat(epconvert:generate-id(.),'para'),$answer_inner_id_postfix)"/>
							<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:for-each select="hint">
				<xsl:element name="q:hint">
					<xsl:element name="section" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),$answer_inner_id_postfix)"/>
						<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="concat(concat(epconvert:generate-id(.),'para'),$answer_inner_id_postfix)"/>
							<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="experiment" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:experiment">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="ep:supervised" select="@ep:supervised"/>
			<xsl:attribute name="ep:context-dependent" select="@ep:context-dependent"/>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='problem'">
						<xsl:element name="ep:problem">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='hypothesis'">
						<xsl:element name="ep:hypothesis">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='objective'">
						<xsl:element name="ep:objective">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='instruments'">
						<xsl:element name="ep:instruments">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='instructions'">
						<xsl:element name="ep:instructions">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='conclusions'">
						<xsl:element name="ep:conclusions">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='note'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="@type"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="observation" mode="EPXML_OUTPUT" priority="1">
		<xsl:element name="ep:observation">
			<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="ep:supervised" select="@ep:supervised"/>
			<xsl:attribute name="ep:context-dependent" select="@ep:context-dependent"/>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="element()">
				<xsl:choose>
					<xsl:when test="local-name()='objective'">
						<xsl:element name="ep:objective">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='instruments'">
						<xsl:element name="ep:instruments">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='instructions'">
						<xsl:element name="ep:instructions">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='conclusions'">
						<xsl:element name="ep:conclusions">
							<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="local-name()='note'">
						<xsl:element name="note" namespace="http://cnx.rice.edu/cnxml">
							<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
							<xsl:attribute name="type" select="@type"/>
							<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
								<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
								<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="biography" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="biography" select="."/>
		<xsl:variable name="glossary" select="@ep:glossary"/>
		<xsl:element name="ep:biography">
			<xsl:attribute name="ep:id" select="epconvert:resolve-biography-id-local(.,())"/>
			<xsl:attribute name="ep:glossary" select="$glossary"/>
			<xsl:element name="ep:name">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:if test="@ep:sorting-key and not(''=@ep:sorting-key)">
				<xsl:element name="ep:sorting-key">
					<xsl:value-of select="@ep:sorting-key"/>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="special_table">
				<xsl:for-each select="birth">
					<xsl:element name="ep:birth">
						<xsl:for-each select="date">
							<xsl:element name="ep:date">
								<xsl:attribute name="ep:type"><xsl:choose><xsl:when test="$biography/@ep:birth_date_type='exact'">date</xsl:when><xsl:otherwise><xsl:value-of select="$biography/@ep:birth_date_type"/></xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:element name="ep:date-start">
									<xsl:for-each select="start/element()">
										<xsl:element name="ep:{local-name()}">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<xsl:if test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$biography/@ep:birth_date_type">
									<xsl:element name="ep:date-end">
										<xsl:for-each select="end/element()">
											<xsl:element name="ep:{local-name()}">
												<xsl:value-of select="."/>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="location">
							<xsl:element name="ep:location">
								<xsl:value-of select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="death">
					<xsl:element name="ep:death">
						<xsl:for-each select="date">
							<xsl:element name="ep:date">
								<xsl:attribute name="ep:type"><xsl:choose><xsl:when test="$biography/@ep:death_date_type='exact'">date</xsl:when><xsl:otherwise><xsl:value-of select="$biography/@ep:death_date_type"/></xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:element name="ep:date-start">
									<xsl:for-each select="start/element()">
										<xsl:element name="ep:{local-name()}">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<xsl:if test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$biography/@ep:death_date_type">
									<xsl:element name="ep:date-end">
										<xsl:for-each select="end/element()">
											<xsl:element name="ep:{local-name()}">
												<xsl:value-of select="."/>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="location">
							<xsl:element name="ep:location">
								<xsl:value-of select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:call-template name="emit_WOMIs_in_biography_or_event_EPXML_OUTPUT">
				<xsl:with-param name="special_table" select="special_table"/>
				<xsl:with-param name="instance_id_context" select="$biography"/>
				<xsl:with-param name="gallery_name" select="name/element()"/>
			</xsl:call-template>
			<xsl:for-each select="content">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
						<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="event" mode="EPXML_OUTPUT" priority="1">
		<xsl:variable name="event" select="."/>
		<xsl:variable name="glossary" select="@ep:glossary"/>
		<xsl:element name="ep:event">
			<xsl:attribute name="ep:id" select="epconvert:resolve-event-id-local(.,())"/>
			<xsl:attribute name="ep:glossary" select="$glossary"/>
			<xsl:element name="ep:name">
				<xsl:apply-templates select="name/element()" mode="EPXML_OUTPUT"/>
			</xsl:element>
			<xsl:for-each select="special_table">
				<xsl:for-each select="start">
					<xsl:element name="ep:event-start">
						<xsl:for-each select="date">
							<xsl:element name="ep:date">
								<xsl:attribute name="ep:type"><xsl:choose><xsl:when test="$event/@ep:start_date_type='exact'">date</xsl:when><xsl:otherwise><xsl:value-of select="$event/@ep:start_date_type"/></xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:element name="ep:date-start">
									<xsl:for-each select="start/element()">
										<xsl:element name="ep:{local-name()}">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<xsl:if test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$event/@ep:start_date_type">
									<xsl:element name="ep:date-end">
										<xsl:for-each select="end/element()">
											<xsl:element name="ep:{local-name()}">
												<xsl:value-of select="."/>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="location">
							<xsl:element name="ep:location">
								<xsl:value-of select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="end">
					<xsl:element name="ep:event-end">
						<xsl:for-each select="date">
							<xsl:element name="ep:date">
								<xsl:attribute name="ep:type"><xsl:choose><xsl:when test="$event/@ep:end_date_type='exact'">date</xsl:when><xsl:otherwise><xsl:value-of select="$event/@ep:end_date_type"/></xsl:otherwise></xsl:choose></xsl:attribute>
								<xsl:element name="ep:date-start">
									<xsl:for-each select="start/element()">
										<xsl:element name="ep:{local-name()}">
											<xsl:value-of select="."/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
								<xsl:if test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$event/@ep:end_date_type">
									<xsl:element name="ep:date-end">
										<xsl:for-each select="end/element()">
											<xsl:element name="ep:{local-name()}">
												<xsl:value-of select="."/>
											</xsl:element>
										</xsl:for-each>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="location">
							<xsl:element name="ep:location">
								<xsl:value-of select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:call-template name="emit_WOMIs_in_biography_or_event_EPXML_OUTPUT">
				<xsl:with-param name="special_table" select="special_table"/>
				<xsl:with-param name="instance_id_context" select="$event"/>
				<xsl:with-param name="gallery_name" select="name/element()"/>
			</xsl:call-template>
			<xsl:for-each select="content">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="epconvert:generate-id(.)"/>
					<xsl:element name="para" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="concat(epconvert:generate-id(.),'para')"/>
						<xsl:call-template name="multi_para_block_EPXML_OUTPUT"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="br_EPXML_OUTPUT">
		<newline xmlns="http://cnx.rice.edu/cnxml"/>
	</xsl:template>
	<xsl:template match="w:br" mode="EPXML_OUTPUT">
		<newline xmlns="http://cnx.rice.edu/cnxml"/>
	</xsl:template>
	<xsl:template match="separator" mode="EPXML_OUTPUT" priority="1"/>
	<xsl:template match="w:hyperlink" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="link_id" select="@r:id"/>
		<xsl:variable name="link_anchor" select="@w:anchor"/>
		<xsl:element name="link" namespace="http://cnx.rice.edu/cnxml">
			<xsl:choose>
				<xsl:when test="not($link_id)">
					<xsl:attribute name="target-id" select="$DOCXM_MAP_MY_ENTRY/bookmark[name/text()=$link_anchor]/id/text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="docxm_map_entry" select="$DOCXM_MAP/docxm_map/entry[filename/text()=$RELS/rels:Relationships/rels:Relationship[@Id=$link_id]/@Target]"/>
					<xsl:if test="$link_id">
						<xsl:attribute name="document" select="$docxm_map_entry/id/text()"/>
					</xsl:if>
					<xsl:if test="$link_anchor">
						<xsl:attribute name="target-id" select="$docxm_map_entry/bookmark[name/text()=$link_anchor]/id/text()"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="hyperlink_apply_EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template name="hyperlink_apply_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="p">
			<xsl:element name="w:p">
				<xsl:copy-of select="node()"/>
			</xsl:element>
		</xsl:variable>
		<xsl:apply-templates select="$p" mode="EPXML_OUTPUT">
			<xsl:with-param name="context" select="$context"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="w:p" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="para_context" select="."/>
		<xsl:variable name="inline_comments_for_processing" as="element()">
			<comments>
				<xsl:copy-of select="w:commentRangeStart[some $x in ($INLINE_COMMENTS_MAP/comment/@id) satisfies $x=@w:id]"/>
			</comments>
		</xsl:variable>
		<xsl:variable name="processed_para">
			<xsl:for-each-group select="element()[(some $x in ('pPr','r','hyperlink','oMathPara','oMath') satisfies local-name()=$x) or ((some $x in ('commentRangeStart','commentRangeEnd') satisfies local-name()=$x) and (some $x in (@w:id) satisfies $inline_comments_for_processing/w:commentRangeStart[@w:id=$x]))]" group-adjacent="string-join((w:rPr/w:rStyle/@w:val, w:rPr/w:vertAlign/@w:val),'')">
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="some $x in ('EPOkrelenie','EPEmfaza','EPEmfaza-pogrubienie','EPEmfaza-kursywapogrubienie','EPAutorwtreci','EPTytuutworuliterackiego','EPWydarzeniewtreci','EPCytat','EPKod','EPJzykobcy') satisfies current-grouping-key()=$x">
							<xsl:element name="w:r">
								<xsl:copy-of select="current-group()//w:rPr[1]"/>
								<xsl:element name="w:t">
									<xsl:value-of select="string-join(current-group()//w:t/text(),'')"/>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="current-group()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:apply-templates select="$target" mode="EPXML_OUTPUT">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="para_context" select="$para_context"/>
				</xsl:apply-templates>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:for-each-group select="$processed_para/node()" group-starting-with="w:commentRangeStart|w:commentRangeEnd">
			<xsl:choose>
				<xsl:when test="current-group()[some $x in ('commentRangeStart','commentRangeEnd') satisfies $x=local-name()]">
					<xsl:choose>
						<xsl:when test="local-name(current-group()[1])='commentRangeStart'">
							<xsl:for-each select="$INLINE_COMMENTS_MAP/comment[@id=current-group()[1]/@w:id]">
								<xsl:call-template name="inline_comment_processing_EPXML_OUTPUT">
									<xsl:with-param name="content" select="current-group()[position()!=1]"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="current-group()[position()!=1]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current-group()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template match="w:commentRangeStart|w:commentRangeEnd" mode="EPXML_OUTPUT">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="inline_comment_processing_EPXML_OUTPUT">
		<xsl:param name="content"/>
		<xsl:choose>
			<xsl:when test="@code='true'">
				<xsl:element name="code" namespace="http://cnx.rice.edu/cnxml">
					<xsl:attribute name="lang" select="@language"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@tooltip-reference='true'">
				<xsl:element name="ep:tooltip-reference">
					<xsl:variable name="name" select="tooltip-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-tooltip-id($name,())"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="'true'"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@glossary-reference='true'">
				<xsl:element name="ep:glossary-reference">
					<xsl:variable name="name" select="glossary-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-glossary-id($name)"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="epconvert:check-glossary-local($name)"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@concept-reference='true'">
				<xsl:element name="ep:concept-reference">
					<xsl:variable name="name" select="concept-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-concept-id($name)"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="epconvert:check-concept-local($name)"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@event-reference='true'">
				<xsl:element name="ep:event-reference">
					<xsl:variable name="name" select="event-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-event-id($name)"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="epconvert:check-event-local($name)"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@biography-reference='true'">
				<xsl:element name="ep:biography-reference">
					<xsl:variable name="name" select="biography-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-biography-id($name)"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="epconvert:check-biography-local($name)"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@bibliography-reference='true'">
				<xsl:element name="ep:bibliography-reference">
					<xsl:variable name="name" select="bibliography-reference/text()"/>
					<xsl:attribute name="ep:id" select="epconvert:resolve-bibliography-id($name)"/>
					<xsl:attribute name="ep:target-name" select="$name"/>
					<xsl:attribute name="ep:local-reference" select="epconvert:check-bibliography-local($name)"/>
					<xsl:copy-of select="$content"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<ERROR>
					<xsl:copy-of select="$content"/>
				</ERROR>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[text()!='']" mode="EPXML_OUTPUT">
		<xsl:copy-of select="text()"/>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPOkrelenie']" mode="EPXML_OUTPUT">
		<xsl:call-template name="term_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="term_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="term" namespace="http://cnx.rice.edu/cnxml">
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza']" mode="EPXML_OUTPUT">
		<xsl:call-template name="emphasis_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="emphasis" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="effect" select="'italics'"/>
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza-pogrubienie']" mode="EPXML_OUTPUT">
		<xsl:call-template name="emphasis_bold_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_bold_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="emphasis" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="effect" select="'bold'"/>
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPEmfaza-kursywapogrubienie']" mode="EPXML_OUTPUT">
		<xsl:call-template name="emphasis_bold_italic_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="emphasis_bold_italic_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="emphasis" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="effect" select="'bolditalics'"/>
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPCytat']" mode="EPXML_OUTPUT">
		<xsl:call-template name="cite_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="cite_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="quote" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="display" select="'inline'"/>
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKod']" mode="EPXML_OUTPUT">
		<xsl:call-template name="code_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="code_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="code" namespace="http://cnx.rice.edu/cnxml">
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPJzykobcy']" mode="EPXML_OUTPUT">
		<xsl:call-template name="foreign_EPXML_OUTPUT"/>
	</xsl:template>
	<xsl:template name="foreign_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="foreign" namespace="http://cnx.rice.edu/cnxml">
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:t[ancestor::w:r/w:rPr/w:rStyle/@w:val='EPKomentarzedycyjny']" mode="EPXML_OUTPUT"/>
	<xsl:template match="w:t[some $x in ('superscript','subscript') satisfies preceding-sibling::w:rPr[1]/w:vertAlign/@w:val=$x]" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="ename" select="if(preceding-sibling::w:rPr[1]/w:vertAlign/@w:val='superscript') then 'sup' else 'sub'"/>
		<xsl:variable name="style" select="preceding-sibling::w:rPr[1]/w:rStyle/@w:val"/>
		<xsl:element name="{$ename}" namespace="http://cnx.rice.edu/cnxml">
			<xsl:choose>
				<xsl:when test="not($style)">
					<xsl:apply-templates mode="EPXML_OUTPUT">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$style='EPOkrelenie'">
					<xsl:call-template name="term_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza'">
					<xsl:call-template name="emphasis_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza-pogrubienie'">
					<xsl:call-template name="emphasis_bold_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPEmfaza-kursywapogrubienie'">
					<xsl:call-template name="emphasis_bold_italic_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPCytat'">
					<xsl:call-template name="cite_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPKod'">
					<xsl:call-template name="code_EPXML_OUTPUT"/>
				</xsl:when>
				<xsl:when test="$style='EPJzykobcy'">
					<xsl:call-template name="foreign_EPXML_OUTPUT"/>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="m:oMath" mode="EPXML_OUTPUT">
		<xsl:param name="para_context"/>
		<xsl:variable name="mathms" as="node()">
			<xsl:copy>
				<xsl:element name="m:fName" extension-element-prefixes="#default">
					<xsl:copy-of select="child::node()"/>
				</xsl:element>
			</xsl:copy>
		</xsl:variable>
		<xsl:variable name="mathml">
			<xsl:choose>
				<xsl:when test="$para_context//w:t[normalize-space(text())!='']">
					<xsl:apply-templates select="$mathms"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="equation" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
						<xsl:apply-templates select="$mathms"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates select="$mathml" mode="rmStyle"/>
	</xsl:template>
	<xsl:template match="w:tbl" mode="EPXML_OUTPUT"/>
	<xsl:template match="w:tbl[not(w:tblPr/w:tblDescription) or w:tblPr/w:tblDescription[@w:val!='EP_AUTHOR' and @w:val!='EP_CORE_CURRICULUM' and @w:val!='EP_USPP_CORE_CURRICULUM' and @w:val!='WOMI_V2_REFERENCE' and @w:val!='EP_WOMI_GALLERY' and not(starts-with(@w:val,'WOMI_REFERENCE_')) and not(starts-with(@w:val,'EP_METADATA')) and not(starts-with(@w:val,'EP_ZAPIS_BIB'))]]" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="table" namespace="http://cnx.rice.edu/cnxml">
			<xsl:attribute name="id" select="epconvert:generate-id(.)"/>
			<xsl:attribute name="summary" select="w:tblPr/w:tblDescription/@w:val"/>
			<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
				<xsl:value-of select="w:tblPr/w:tblCaption/@w:val"/>
			</xsl:element>
			<xsl:element name="tgroup" namespace="http://cnx.rice.edu/cnxml">
				<xsl:attribute name="cols" select="count(w:tblGrid/w:gridCol)"/>
				<xsl:for-each select="w:tblGrid/w:gridCol">
					<xsl:element name="colspec" namespace="http://cnx.rice.edu/cnxml">
						<xsl:attribute name="colnum" select="position()"/>
						<xsl:attribute name="colname" select="concat('c',position())"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:if test="w:tr[w:trPr/w:tblHeader]">
					<xsl:element name="thead" namespace="http://cnx.rice.edu/cnxml">
						<xsl:apply-templates select="w:tr[w:trPr/w:tblHeader]" mode="EPXML_OUTPUT">
							<xsl:with-param name="context" select="$context"/>
						</xsl:apply-templates>
					</xsl:element>
				</xsl:if>
				<xsl:element name="tbody" namespace="http://cnx.rice.edu/cnxml">
					<xsl:apply-templates select="w:tr[not(w:trPr/w:tblHeader)]" mode="EPXML_OUTPUT">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:tr" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:element name="row" namespace="http://cnx.rice.edu/cnxml">
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:tc" mode="EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:variable name="colspan">
			<xsl:choose>
				<xsl:when test="w:tcPr/w:gridSpan/@w:val">
					<xsl:value-of select="number(w:tcPr/w:gridSpan/@w:val)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_col" select="count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)"/>
		<xsl:choose>
			<xsl:when test="w:tcPr/w:vMerge[@w:val='restart']">
				<xsl:variable name="current_row" select="count(ancestor::w:tr/preceding-sibling::w:tr)+1"/>
				<xsl:variable name="next_row_with_restart_on_that_col">
					<xsl:choose>
						<xsl:when test="ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge/@w:val='restart' and position()>$current_row]">
							<xsl:value-of select="count(ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge/@w:val='restart' and position()>$current_row][1]/preceding-sibling::w:tr)+1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="count(ancestor::w:tbl/w:tr)+1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="morerows" select="count(ancestor::w:tbl/w:tr[w:tc[count(preceding-sibling::w:tc)+1-count(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val])+sum(preceding-sibling::w:tc[w:tcPr/w:gridSpan/@w:val]/w:tcPr/w:gridSpan/@w:val)=$current_col]/w:tcPr/w:vMerge[not(@w:val)] and position()>$current_row and position()&lt;$next_row_with_restart_on_that_col])"/>
				<xsl:call-template name="tc_apply_EPXML_OUTPUT">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="colspan">
						<xsl:value-of select="$colspan"/>
					</xsl:with-param>
					<xsl:with-param name="current_col">
						<xsl:value-of select="$current_col"/>
					</xsl:with-param>
					<xsl:with-param name="morerows">
						<xsl:value-of select="$morerows"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="w:tcPr/w:vMerge">
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tc_apply_EPXML_OUTPUT">
					<xsl:with-param name="context" select="$context"/>
					<xsl:with-param name="colspan">
						<xsl:value-of select="$colspan"/>
					</xsl:with-param>
					<xsl:with-param name="current_col">
						<xsl:value-of select="$current_col"/>
					</xsl:with-param>
					<xsl:with-param name="morerows">0</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="tc_apply_EPXML_OUTPUT">
		<xsl:param name="context"/>
		<xsl:param name="colspan"/>
		<xsl:param name="current_col"/>
		<xsl:param name="morerows"/>
		<xsl:element name="entry" namespace="http://cnx.rice.edu/cnxml">
			<xsl:if test="0 != $colspan">
				<xsl:attribute name="namest">c<xsl:value-of select="$current_col"/></xsl:attribute>
				<xsl:attribute name="nameend">c<xsl:value-of select="$current_col+number($colspan)-1"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="0 != $morerows">
				<xsl:attribute name="morerows" select="$morerows"/>
			</xsl:if>
			<xsl:apply-templates mode="EPXML_OUTPUT">
				<xsl:with-param name="context" select="$context"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template name="emit_WOMIs_in_biography_or_event_EPXML_OUTPUT">
		<xsl:param name="special_table" as="element()"/>
		<xsl:param name="instance_id_context" as="element()"/>
		<xsl:param name="gallery_name"/>
		<xsl:if test="$special_table/element[1]">
			<xsl:call-template name="womi_V2_EPXML_OUTPUT">
				<xsl:with-param name="WOMI_element" select="$special_table/element[1]"/>
				<xsl:with-param name="instance_id" select="concat(epconvert:generate-id($instance_id_context),'WOMI')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="1 &lt; count($special_table/element)">
			<xsl:element name="ep:gallery">
				<xsl:attribute name="ep:id" select="concat(epconvert:generate-id($instance_id_context),'gallery')"/>
				<xsl:attribute name="ep:miniatures-only" select="'true'"/>
				<xsl:attribute name="ep:format-contents" select="'hide-normal'"/>
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:apply-templates select="$gallery_name" mode="EPXML_OUTPUT"/>
				</xsl:element>
				<xsl:for-each select="$special_table/element[1!=position()]">
					<xsl:variable name="WOMI_element" select="."/>
					<xsl:call-template name="womi_V2_EPXML_OUTPUT">
						<xsl:with-param name="WOMI_element" select="$WOMI_element"/>
						<xsl:with-param name="instance_id" select="string-join((epconvert:generate-id($instance_id_context),'gallery',string(position())),'')"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="womi_gallery_EPXML_OUTPUT">
		<xsl:param name="special_table" as="element()"/>
		<xsl:param name="id"/>
		<xsl:variable name="gallery_title" select="$special_table/attribute[@key='gallery-title']/text()"/>
		<xsl:variable name="gallery_type" select="$special_table/attribute[@key='gallery-type']/text()"/>
		<xsl:variable name="gallery_text_copy" select="$special_table/attribute[@key='gallery-content-copy']/text()"/>
		<xsl:variable name="gallery_text_classic" select="$special_table/attribute[@key='ep:gallery-content-classic']/node()"/>
		<xsl:variable name="gallery_text_mobile" select="$special_table/attribute[@key='ep:gallery-content-mobile']/node()"/>
		<xsl:variable name="gallery_text_static" select="$special_table/attribute[@key='ep:gallery-content-pdf']/node()"/>
		<xsl:variable name="gallery_text_static_mono" select="$special_table/attribute[@key='ep:gallery-content-ebook']/node()"/>
		<xsl:element name="ep:gallery">
			<xsl:attribute name="ep:id" select="$id"/>
			<xsl:choose>
				<xsl:when test="'slideshow'=$gallery_type">
					<xsl:for-each select="('start-on','thumbnails','titles','format-contents')">
						<xsl:variable name="key" select="concat('ep:',.)"/>
						<xsl:variable name="value" select="$special_table/attribute[@key=$key]/text()"/>
						<xsl:if test="''!=$value">
							<xsl:attribute name="{$key}" select="$value"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="'grid'=$gallery_type">
					<xsl:for-each select="('view-width','view-height')">
						<xsl:variable name="key" select="concat('ep:',.)"/>
						<xsl:variable name="value" select="$special_table/attribute[@key=$key]/text()"/>
						<xsl:attribute name="{$key}" select="$value"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="'miniatures'=$gallery_type">
					<xsl:attribute name="ep:miniatures-only" select="true()"/>
					<xsl:for-each select="('thumbnails','titles','format-contents')">
						<xsl:variable name="key" select="concat('ep:',.)"/>
						<xsl:variable name="value" select="$special_table/attribute[@key=$key]/text()"/>
						<xsl:if test="''!=$value">
							<xsl:attribute name="{$key}" select="$value"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="('start-on','thumbnails','titles','format-contents','playlist')">
						<xsl:variable name="key" select="concat('ep:',.)"/>
						<xsl:variable name="value" select="$special_table/attribute[@key=$key]/text()"/>
						<xsl:if test="''!=$value">
							<xsl:attribute name="{$key}" select="$value"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="''!=$gallery_title">
				<xsl:element name="title" namespace="http://cnx.rice.edu/cnxml">
					<xsl:value-of select="$gallery_title"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$gallery_text_classic">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($id,'content1')"/>
					<xsl:attribute name="ep:format" select="'classic'"/>
					<xsl:copy-of select="$gallery_text_classic"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$gallery_text_mobile!='' or 'true'=$gallery_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($id,'content2')"/>
					<xsl:attribute name="ep:format" select="'mobile'"/>
					<xsl:choose>
						<xsl:when test="$gallery_text_mobile!=''">
							<xsl:copy-of select="$gallery_text_mobile"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$gallery_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$gallery_text_static!='' or 'true'=$gallery_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($id,'content3')"/>
					<xsl:attribute name="ep:format" select="'static'"/>
					<xsl:choose>
						<xsl:when test="$gallery_text_static!=''">
							<xsl:copy-of select="$gallery_text_static"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$gallery_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$gallery_text_static_mono!='' or 'true'=$gallery_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($id,'content4')"/>
					<xsl:attribute name="ep:format" select="'static-mono'"/>
					<xsl:choose>
						<xsl:when test="$gallery_text_static_mono!=''">
							<xsl:copy-of select="$gallery_text_static_mono"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$gallery_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="$special_table/element">
				<xsl:call-template name="womi_V2_EPXML_OUTPUT">
					<xsl:with-param name="WOMI_element" select="."/>
					<xsl:with-param name="instance_id" select="concat($id, string(position()))"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="womi_V2_EPXML_OUTPUT">
		<xsl:param name="WOMI_element" as="element()"/>
		<xsl:param name="instance_id"/>
		<xsl:variable name="id" select="$WOMI_element/@id"/>
		<xsl:variable name="womi_width" select="$WOMI_element/attribute[@name='WOMI_WIDTH']/text()"/>
		<xsl:variable name="womi_type" select="$WOMI_element/attribute[@name='WOMI_REFERENCE']/@group_2"/>
		<xsl:variable name="womi_context" select="$WOMI_element/attribute[@name='WOMI_CONTEXT']/text()"/>
		<xsl:variable name="womi_gallery" select="$WOMI_element/attribute[@name='WOMI_GALLERY']/text()"/>
		<xsl:variable name="womi_caption" select="$WOMI_element/attribute[@name='WOMI_CAPTION']/text()"/>
		<xsl:variable name="womi_zoomable" select="$WOMI_element/attribute[@name='WOMI_ZOOMABLE']/text()"/>
		<xsl:variable name="womi_avatar" select="$WOMI_element/attribute[@name='WOMI_AVATAR']/text()"/>
		<xsl:variable name="womi_text_copy" select="$WOMI_element/attribute[@name='WOMI_TEXT_COPY']/text()"/>
		<xsl:variable name="womi_text_classic" select="$WOMI_element/attribute[@name='WOMI_TEXT_CLASSIC']/node()"/>
		<xsl:variable name="womi_text_mobile" select="$WOMI_element/attribute[@name='WOMI_TEXT_MOBILE']/node()"/>
		<xsl:variable name="womi_text_static" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC']/node()"/>
		<xsl:variable name="womi_text_static_mono" select="$WOMI_element/attribute[@name='WOMI_TEXT_STATIC_MONO']/node()"/>
		<xsl:element name="ep:reference">
			<xsl:attribute name="ep:id" select="$id"/>
			<xsl:attribute name="ep:instance-id" select="$instance_id"/>
			<xsl:if test="$womi_type != 'AUDIO' and $womi_width!=''">
				<xsl:element name="ep:width">
					<xsl:value-of select="$womi_width"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$womi_context">
				<xsl:element name="ep:context">
					<xsl:choose>
						<xsl:when test="'no'=$womi_context">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:element name="ep:reading-room">
				<xsl:choose>
					<xsl:when test="'show-format-contents'=$womi_gallery">
						<xsl:attribute name="ep:show-format-contents">true</xsl:attribute>true</xsl:when>
					<xsl:when test="'true'=$womi_gallery">
						<xsl:attribute name="ep:show-format-contents">false</xsl:attribute>true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="''!=$womi_zoomable">
				<xsl:element name="ep:zoomable">
					<xsl:value-of select="$womi_zoomable"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$womi_avatar">
				<xsl:element name="ep:avatar">
					<xsl:value-of select="$womi_avatar"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$womi_context">
				<xsl:element name="ep:embedded">
					<xsl:choose>
						<xsl:when test="'yes'=$womi_context">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$womi_caption">
				<xsl:element name="ep:hide-caption">
					<xsl:value-of select="$womi_caption"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="''!=$womi_text_classic">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($instance_id,'content1')"/>
					<xsl:attribute name="ep:format" select="'classic'"/>
					<xsl:copy-of select="$womi_text_classic"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$womi_text_mobile!='' or 'true'=$womi_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($instance_id,'content2')"/>
					<xsl:attribute name="ep:format" select="'mobile'"/>
					<xsl:choose>
						<xsl:when test="$womi_text_mobile!=''">
							<xsl:copy-of select="$womi_text_mobile"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$womi_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$womi_text_static!='' or 'true'=$womi_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($instance_id,'content3')"/>
					<xsl:attribute name="ep:format" select="'static'"/>
					<xsl:choose>
						<xsl:when test="$womi_text_static!=''">
							<xsl:copy-of select="$womi_text_static"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$womi_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$womi_text_static_mono!='' or 'true'=$womi_text_copy">
				<xsl:element name="ep:content">
					<xsl:attribute name="ep:id" select="concat($instance_id,'content4')"/>
					<xsl:attribute name="ep:format" select="'static-mono'"/>
					<xsl:choose>
						<xsl:when test="$womi_text_static_mono!=''">
							<xsl:copy-of select="$womi_text_static_mono"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$womi_text_classic"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription[starts-with(@w:val,'WOMI_REFERENCE_')]]" mode="EPXML_OUTPUT">
		<xsl:variable name="womi_reference" select="epconvert:parseWOMIReference(w:tblPr/w:tblDescription/@w:val)"/>
		<xsl:variable name="womi_width" select="string-join(w:tr[2]/w:tc[2]/w:p/w:r/w:t,'')"/>
		<xsl:element name="ep:reference">
			<xsl:attribute name="ep:id" select="$womi_reference/id"/>
			<xsl:attribute name="ep:instance-id" select="epconvert:generate-id(.)"/>
			<xsl:if test="$womi_reference/type != 'AUDIO'">
				<xsl:element name="ep:width">
					<xsl:value-of select="$womi_width"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription/@w:val='EP_WOMI_GALLERY']" mode="EPXML_OUTPUT">
		<xsl:call-template name="womi_gallery_EPXML_OUTPUT">
			<xsl:with-param name="special_table" select="epconvert:process_special_table_attributes(.,0)"/>
			<xsl:with-param name="id" select="concat(epconvert:generate-id(.),'gallery')"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="w:tbl[w:tblPr/w:tblDescription/@w:val='WOMI_V2_REFERENCE']" mode="EPXML_OUTPUT">
		<xsl:call-template name="womi_V2_EPXML_OUTPUT">
			<xsl:with-param name="WOMI_element" select="epconvert:process_special_table_attributes(.,0)/element[1]"/>
			<xsl:with-param name="instance_id" select="concat(epconvert:generate-id(.),'WOMI')"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="global_dropdown_value_picker">
		<xsl:param name="tag"/>
		<xsl:value-of select="$ROOT//w:sdt[w:sdtPr/w:tag/@w:val=$tag]/w:sdtPr/w:dropDownList/w:listItem[@w:displayText=ancestor::w:sdt/w:sdtContent/w:tc/w:p/w:r/w:t/text()]/@w:value"/>
	</xsl:template>
	<xsl:template name="text_value_picker">
		<xsl:param name="tag"/>
		<xsl:value-of select="descendant::w:sdt[w:sdtPr/w:tag/@w:val=$tag]/w:sdtContent/descendant::w:t/text()"/>
	</xsl:template>
	<xsl:template name="dropdown_value_picker">
		<xsl:param name="tag"/>
		<xsl:value-of select="descendant-or-self::w:sdt[w:sdtPr/w:tag/@w:val=$tag]/w:sdtPr/w:dropDownList/w:listItem[@w:displayText=ancestor::w:sdt/w:sdtContent/descendant::w:t/text()]/@w:value"/>
	</xsl:template>
	<xsl:function name="epconvert:get_WOMI_table_from_special_table" as="element()">
		<xsl:param name="position"/>
		<xsl:param name="WOMI_id"/>
		<xsl:variable name="special_table" select="epconvert:select_element_for_processing($position)"/>
		<xsl:copy-of select="$special_table/descendant::w:tbl[w:tblPr/w:tblDescription[starts-with(@w:val,'WOMI_REFERENCE_') and ends-with(@w:val,$WOMI_id)] or descendant::w:tag[starts-with(@w:val,'WOMI_REFERENCE_') and ends-with(@w:val,$WOMI_id)]]"/>
	</xsl:function>
	<xsl:function name="epconvert:get_WOMI_image_from_special_table">
		<xsl:param name="position"/>
		<xsl:param name="WOMI_id"/>
		<xsl:variable name="WOMI_table" select="epconvert:get_WOMI_table_from_special_table($position,$WOMI_id)"/>
		<xsl:copy-of select="$WOMI_table/descendant::a:blip/@r:embed"/>
	</xsl:function>
	<xsl:function name="epconvert:generate-id" as="node()">
		<xsl:param name="context"/>
		<xsl:value-of select="concat($DOCXM_MAP_MY_ENTRY/id/text(),'_',generate-id($context))"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-tooltip-id" as="node()">
		<xsl:param name="name"/>
		<xsl:param name="tooltips"/>
		<xsl:variable name="corrected_name" select="string-join($name,'')"/>
		<xsl:variable name="number" select="1 + count($tooltips[string-join(epconvert:select_text_for_element(name/element()),'')=$corrected_name])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/tooltips/tooltip[text()=$corrected_name][$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-glossary-id" as="node()">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:choose>
			<xsl:when test="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/element()[some $x in ('rules','definitions') satisfies local-name()=$x]/element()[text()=string-join($name,'')]">
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/element()[some $x in ('rules','definitions') satisfies local-name()=$x]/element()[text()=string-join($name,'')])[1]/@local-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module/element()[some $x in ('rules','definitions') satisfies local-name()=$x]/element()[text()=string-join($name,'') and @global-id])[1]/@global-id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:resolve-glossary-id-local" as="node()">
		<xsl:param name="glossary"/>
		<xsl:param name="glossaries"/>
		<xsl:param name="type"/>
		<xsl:variable name="name" select="string-join(epconvert:select_text_for_element($glossary/name/element()),'')"/>
		<xsl:variable name="number" select="1 + count($glossaries[string-join(epconvert:select_text_for_element(name/element()),'')=$name])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/element()[local-name()=$type]/element()[text()=$name])[$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-concept-id" as="node()">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:choose>
			<xsl:when test="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/concepts/concept[text()=string-join($name,'')]">
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/concepts/concept[text()=string-join($name,'')])[1]/@local-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module/concepts/concept[text()=string-join($name,'') and @global-id])[1]/@global-id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:resolve-concept-id-local" as="node()">
		<xsl:param name="concept"/>
		<xsl:param name="concepts"/>
		<xsl:variable name="name" select="string-join(epconvert:select_text_for_element($concept/name/element()),'')"/>
		<xsl:variable name="number" select="1 + count($concepts[string-join(epconvert:select_text_for_element(name/element()),'')=$name])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/concepts/concept[text()=$name])[$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-event-id" as="node()">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:choose>
			<xsl:when test="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/events/event[text()=string-join($name,'')]">
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/events/event[text()=string-join($name,'')])[1]/@local-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module/events/event[text()=string-join($name,'') and @global-id])[1]/@global-id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:resolve-event-id-local" as="node()">
		<xsl:param name="event"/>
		<xsl:param name="events"/>
		<xsl:variable name="name" select="string-join(epconvert:select_text_for_element($event/name/element()),'')"/>
		<xsl:variable name="number" select="1 + count($events[string-join(epconvert:select_text_for_element(name/element()),'')=$name])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/events/event[text()=$name])[$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-biography-id" as="node()">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:choose>
			<xsl:when test="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/biographies/biography[text()=string-join($name,'')]">
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/biographies/biography[text()=string-join($name,'')])[1]/@local-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module/biographies/biography[text()=string-join($name,'') and @global-id])[1]/@global-id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:resolve-biography-id-local" as="node()">
		<xsl:param name="biography"/>
		<xsl:param name="biographies"/>
		<xsl:variable name="name" select="string-join(epconvert:select_text_for_element($biography/name/element()),'')"/>
		<xsl:variable name="number" select="1 + count($biographies[string-join(epconvert:select_text_for_element(name/element()),'')=$name])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/biographies/biography[text()=$name])[$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-bibliography-id" as="node()">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:choose>
			<xsl:when test="$AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/bibliographies/bibliography[text()=string-join($name,'') and @display-in-module]">
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/bibliographies/bibliography[text()=string-join($name,'')])[1]/@local-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module/bibliographies/bibliography[text()=string-join($name,'')])[1]/@global-id"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:resolve-bibliography-id-local" as="node()">
		<xsl:param name="bibliography"/>
		<xsl:param name="bibliographies"/>
		<xsl:variable name="id" select="$bibliography/attribute[@key='id']/text()"/>
		<xsl:variable name="number" select="1 + count($bibliographies[attribute[@key='id']/text()=$id])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/bibliographies/bibliography[text()=$id])[$number]/@local-id"/>
	</xsl:function>
	<xsl:function name="epconvert:resolve-bibliography-id-global" as="node()">
		<xsl:param name="bibliography"/>
		<xsl:param name="bibliographies"/>
		<xsl:variable name="id" select="$bibliography/attribute[@key='id']/text()"/>
		<xsl:variable name="number" select="1 + count($bibliographies[attribute[@key='id']/text()=$id])"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/bibliographies/bibliography[text()=$id])[$number]/@global-id"/>
	</xsl:function>
	<xsl:function name="epconvert:check-glossary-local" as="xs:boolean">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="if($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/element()[some $x in ('definitions','rules') satisfies local-name()=$x]/element()[text()=string-join($name,'')]) then true() else false()"/>
	</xsl:function>
	<xsl:function name="epconvert:check-concept-local" as="xs:boolean">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="if($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/concepts/concept[text()=string-join($name,'')]) then true() else false()"/>
	</xsl:function>
	<xsl:function name="epconvert:check-event-local" as="xs:boolean">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="if($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/events/event[text()=string-join($name,'')]) then true() else false()"/>
	</xsl:function>
	<xsl:function name="epconvert:check-biography-local" as="xs:boolean">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="if($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/biographies/biography[text()=string-join($name,'')]) then true() else false()"/>
	</xsl:function>
	<xsl:function name="epconvert:check-bibliography-local" as="xs:boolean">
		<xsl:param name="name"/>
		<xsl:variable name="module_id" select="$DOCXM_MAP_MY_ENTRY/id/text()"/>
		<xsl:value-of select="if($AGGREGATED_REFERENCABLE_ELEMENTS/module[id/text()=$module_id]/bibliographies/bibliography[text()=string-join($name,'') and @display-in-module]) then true() else false()"/>
	</xsl:function>
	<xsl:function name="epconvert:generate-referencable-global-url" as="xs:string">
		<xsl:param name="type"/>
		<xsl:param name="id"/>
		<xsl:variable name="ra_prefix" select="$DOCXM_MAP_MY_ENTRY/ra_prefix/text()"/>
		<xsl:value-of select="concat($ra_prefix,'/',$type,'.pdf','#',$id)"/>
	</xsl:function>
	<xsl:function name="ep:only_alpha_numeric" as="xs:string">
		<xsl:param name="input"/>
		<xsl:value-of select="replace($input, '[^a-zA-Z0-9_]', '')"/>
	</xsl:function>
	<xsl:function name="ep:only_ascii" as="xs:string">
		<xsl:param name="input"/>
		<xsl:value-of select="translate($input, 'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ','acelnoszzACELNOSZZ')"/>
	</xsl:function>
	<xsl:function name="epconvert:century_to_year">
		<xsl:param name="century" as="xs:string"/>
		<xsl:copy-of select="epconvert:century_to_year($century,false())"/>
	</xsl:function>
	<xsl:function name="epconvert:century_to_year">
		<xsl:param name="century" as="xs:string"/>
		<xsl:param name="BC" as="xs:boolean"/>
		<xsl:variable name="century_integer" select="epconvert:convert_roman_to_arabic($century)"/>
		<start>
			<year>
				<xsl:value-of select="if($BC) then -1 * $century_integer * 100 else ($century_integer - 1) * 100 + 1"/>
			</year>
		</start>
		<end>
			<year>
				<xsl:value-of select="if($BC) then -1 * (($century_integer - 1) * 100 + 1) else $century_integer * 100"/>
			</year>
		</end>
	</xsl:function>
	<xsl:function name="epconvert:is_correct_roman_number" as="xs:boolean">
		<xsl:param name="roman" as="xs:string"/>
		<xsl:variable name="roman_upper" select="upper-case($roman)"/>
		<xsl:variable name="integer" select="number(epconvert:convert_roman_to_arabic($roman))[1]"/>
		<xsl:variable name="roman2">
			<xsl:number value="$integer" format="I"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$roman_upper = $roman2">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:convert_roman_to_arabic" as="xs:integer">
		<xsl:param name="roman" as="xs:string"/>
		<xsl:variable name="length" select="string-length($roman)"/>
		<xsl:variable name="roman_upper" select="upper-case($roman)"/>
		<xsl:choose>
			<xsl:when test="ends-with($roman_upper,'I')">
				<xsl:value-of select="1 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'IV')">
				<xsl:value-of select="4 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'V')">
				<xsl:value-of select="5 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'IX')">
				<xsl:value-of select="9 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'X')">
				<xsl:value-of select="10 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'XL')">
				<xsl:value-of select="40 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'L')">
				<xsl:value-of select="50 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'XC')">
				<xsl:value-of select="90 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'C')">
				<xsl:value-of select="100 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'CD')">
				<xsl:value-of select="400 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'D')">
				<xsl:value-of select="500 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'CM')">
				<xsl:value-of select="900 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 2))"/>
			</xsl:when>
			<xsl:when test="ends-with($roman_upper,'M')">
				<xsl:value-of select="1000 + epconvert:convert_roman_to_arabic(substring($roman_upper,1,$length - 1))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template match="w:commentRangeStart" mode="COMMENTS_MAP">
		<xsl:param name="comments"/>
		<xsl:variable name="id" select="@w:id"/>
		<xsl:variable name="comment" select="$comments/w:comments/w:comment[@w:id=$id]"/>
		<xsl:element name="comment">
			<xsl:attribute name="id" select="$id"/>
			<xsl:variable name="start_point" select="ancestor-or-self::w:*[parent::w:body][some $x in ('p','tbl','commentRangeStart') satisfies local-name()=$x]"/>
			<xsl:attribute name="global_start" select="count($start_point/preceding-sibling::w:*[some $x in ('p','tbl') satisfies local-name()=$x])+(if(local-name($start_point)='commentRangeStart') then 0 else 1)"/>
			<xsl:variable name="end_context" select="//w:commentRangeEnd[@w:id=$id]"/>
			<xsl:variable name="end_point" select="$end_context/ancestor-or-self::w:*[parent::w:body][some $x in ('p','tbl','commentRangeEnd') satisfies local-name()=$x]"/>
			<xsl:attribute name="global_end" select="count($end_point/preceding-sibling::w:*[some $x in ('p','tbl') satisfies local-name()=$x])+(if(local-name($end_point)='commentRangeEnd') then 0 else 1)"/>
			<xsl:attribute name="teacher" select="boolean($comment//w:rStyle[@w:val='EPKAdresatnauczyciel'])"/>
			<xsl:attribute name="expanding" select="boolean($comment//w:rStyle[@w:val='EPKStatustrerozszerzajca'])"/>
			<xsl:attribute name="supplemental" select="boolean($comment//w:rStyle[@w:val='EPKStatustreuzupeniajca'])"/>
			<xsl:attribute name="definition" select="boolean($comment//w:rStyle[@w:val='EPKDefinicja'])"/>
			<xsl:attribute name="concept" select="boolean($comment//w:rStyle[@w:val='EPKPojcie'])"/>
			<xsl:attribute name="exercise" select="boolean($comment//w:rStyle[@w:val='EPKwiczenie'])"/>
			<xsl:attribute name="command" select="boolean($comment//w:rStyle[@w:val='EPKPolecenie'])"/>
			<xsl:attribute name="homework" select="boolean($comment//w:rStyle[@w:val='EPKPracadomowa'])"/>
			<xsl:attribute name="glossary-declaration" select="boolean($comment//w:rStyle[@w:val='EPKSowniczek-deklaracja'])"/>
			<xsl:attribute name="list" select="boolean($comment//w:rStyle[@w:val='EPKLista'])"/>
			<xsl:attribute name="cite" select="boolean($comment//w:rStyle[@w:val='EPKCytat'])"/>
			<xsl:attribute name="quiz" select="boolean($comment//w:rStyle[@w:val='EPKZadanie'])"/>
			<xsl:attribute name="exercise_WOMI" select="boolean($comment//w:rStyle[@w:val='EPKZadaniesilnikowe'])"/>
			<xsl:attribute name="exercise_set" select="boolean($comment//w:rStyle[@w:val='EPKZbirzada'])"/>
			<xsl:attribute name="experiment" select="boolean($comment//w:rStyle[@w:val='EPKDowiadczenie'])"/>
			<xsl:attribute name="observation" select="boolean($comment//w:rStyle[@w:val='EPKObserwacja'])"/>
			<xsl:attribute name="biography" select="boolean($comment//w:rStyle[@w:val='EPKBiogram'])"/>
			<xsl:attribute name="event" select="boolean($comment//w:rStyle[@w:val='EPKWydarzenie'])"/>
			<xsl:attribute name="tooltip" select="boolean($comment//w:rStyle[@w:val='EPKDymek'])"/>
			<xsl:attribute name="procedure-instructions" select="boolean($comment//w:rStyle[@w:val='EPKInstrukcjapostpowania'])"/>
			<xsl:variable name="code" select="boolean($comment//w:rStyle[@w:val='EPKKod'])"/>
			<xsl:attribute name="code" select="$code"/>
			<xsl:variable name="rule" select="boolean($comment//w:rStyle[@w:val='EPKRegua'])"/>
			<xsl:attribute name="rule" select="$rule"/>
			<xsl:variable name="glossary-reference" select="boolean($comment//w:rStyle[@w:val='EPKSowniczek-odwoanie'])"/>
			<xsl:attribute name="glossary-reference" select="$glossary-reference"/>
			<xsl:variable name="concept-reference" select="boolean($comment//w:rStyle[@w:val='EPKPojcie-odwoanie'])"/>
			<xsl:attribute name="concept-reference" select="$concept-reference"/>
			<xsl:variable name="tooltip-reference" select="boolean($comment//w:rStyle[@w:val='EPKDymek-odwoanie'])"/>
			<xsl:attribute name="tooltip-reference" select="$tooltip-reference"/>
			<xsl:variable name="event-reference" select="boolean($comment//w:rStyle[@w:val='EPKWydarzenie-odwoanie'])"/>
			<xsl:attribute name="event-reference" select="$event-reference"/>
			<xsl:variable name="biography-reference" select="boolean($comment//w:rStyle[@w:val='EPKBiogram-odwoanie'])"/>
			<xsl:attribute name="biography-reference" select="$biography-reference"/>
			<xsl:variable name="bibliography-reference" select="boolean($comment//w:rStyle[@w:val='EPKZapisbibliograficzny-odwoanie'])"/>
			<xsl:attribute name="bibliography-reference" select="$bibliography-reference"/>
			<xsl:if test="some $x in ($code, $glossary-reference, $concept-reference, $tooltip-reference, $event-reference, $biography-reference, $bibliography-reference) satisfies true()=$x">
				<xsl:attribute name="INLINE_COMMENT_PROCESSING" select="true()"/>
			</xsl:if>
			<xsl:if test="$code">
				<xsl:element name="code">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKKod']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$rule">
				<xsl:variable name="value" select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKRegua']/w:t/text(),'')"/>
				<xsl:if test="some $x in ('REGUŁA','TWIERDZENIE','LEMAT','PRAWO','WŁASNOŚĆ') satisfies $value=$x">
					<xsl:element name="rule">
						<xsl:value-of select="$value"/>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$glossary-reference">
				<xsl:element name="glossary-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKSowniczek-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$concept-reference">
				<xsl:element name="concept-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKPojcie-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$tooltip-reference">
				<xsl:element name="tooltip-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKDymek-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$event-reference">
				<xsl:element name="event-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKWydarzenie-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$biography-reference">
				<xsl:element name="biography-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKBiogram-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="$bibliography-reference">
				<xsl:element name="bibliography-reference">
					<xsl:value-of select="string-join($comment//w:r[w:rPr/w:rStyle/@w:val='EPKZapisbibliograficzny-odwoanie']/w:t/text(),'')"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="count($comment//w:tbl[not(some $x in following-sibling::w:tbl/w:tblPr/w:tblDescription/@w:val satisfies $x = w:tblPr/w:tblDescription/@w:val)][matches(w:tblPr/w:tblDescription/@w:val, '^WOMI_REFERENCE_(IMAGE|ICON|VIDEO|AUDIO|OINT)_(\d+)$')]) &gt; 1">
				<error type="multiple_WOMI_in_a_comment"/>
			</xsl:if>
			<xsl:for-each select="$comment//w:tbl">
				<xsl:choose>
					<xsl:when test="w:tblPr/w:tblDescription/@w:val">
						<xsl:analyze-string select="w:tblPr/w:tblDescription/@w:val" regex="^WOMI_REFERENCE_(IMAGE|ICON|VIDEO|AUDIO|OINT)_(\d+)$">
							<xsl:matching-substring>
								<xsl:choose>
									<xsl:when test="regex-group(1)='AUDIO'">
										<WOMI id="{regex-group(2)}"/>
									</xsl:when>
									<xsl:otherwise>
										<error type="non_AUDIO_WOMI_in_comment"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
								<warn type="table_in_comment_but_not_WOMI"/>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</xsl:when>
					<xsl:otherwise>
						<warn type="table_in_comment_but_not_WOMI"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*[text()!='']" mode="COMMENTS_MAP"/>
	<xsl:function name="epconvert:stick_tables_to_listitems">
		<xsl:param name="document" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($document)">
				<xsl:copy-of select="$document"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name($document)}">
					<xsl:copy-of select="$document/@*"/>
					<xsl:for-each-group select="$document/element()" group-starting-with="list_item|separator">
						<xsl:choose>
							<xsl:when test="'list_item'=local-name(current-group()[1])">
								<xsl:choose>
									<xsl:when test="some $x in ('WOMI','table') satisfies $x=local-name(current-group()[2])">
										<xsl:element name="list_item">
											<xsl:copy-of select="current-group()[1]/@*"/>
											<xsl:copy-of select="current-group()[1]/element()"/>
											<xsl:copy-of select="current-group()[1!=position()]"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="current-group()"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="current-group()">
									<xsl:choose>
										<xsl:when test="element()">
											<xsl:copy-of select="epconvert:stick_tables_to_listitems(.)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:copy-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:group_listitems">
		<xsl:param name="document" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($document)">
				<xsl:copy-of select="$document"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name($document)}">
					<xsl:copy-of select="$document/@*"/>
					<xsl:for-each-group select="$document/element()" group-adjacent="string-join((local-name(), @numId, @style),'')">
						<xsl:choose>
							<xsl:when test="current-group()[1]/@numId">
								<xsl:if test="0 &lt; current-group()[1]/@ilvl">
									<error type="list_starting_with_ilvl_gt_0" ilvl="{current-group()[1]/@ilvl}"/>
								</xsl:if>
								<xsl:variable name="processed_list" select="epconvert:process_list_structure(current-group(),current-group()[1]/@ilvl)"/>
								<xsl:copy-of select="$processed_list//(error|warn)"/>
								<xsl:element name="list">
									<xsl:variable name="position_end" select="if(current-group()[last()]/element()[@position]) then current-group()[last()]/element()[@position][last()]/@position else current-group()[last()]/@position"/>
									<xsl:attribute name="position" select="$position_end"/>
									<xsl:attribute name="position_start" select="current-group()[1]/@position"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:attribute name="style" select="current-group()[1]/@style"/>
									<xsl:copy-of select="$processed_list"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="current-group()">
									<xsl:choose>
										<xsl:when test="element()">
											<xsl:copy-of select="epconvert:group_listitems(.)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:copy-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:process_list_structure">
		<xsl:param name="listitems" as="node()*"/>
		<xsl:param name="level"/>
		<xsl:for-each-group select="$listitems" group-starting-with="list_item[@ilvl=$level]">
			<xsl:element name="{local-name(current-group()[1])}">
				<xsl:copy-of select="current-group()[1]/attribute()"/>
				<xsl:copy-of select="current-group()[1]/element()[some $x in ('bookmark','WOMI','table','para') satisfies $x=local-name(.)]"/>
				<xsl:if test="current-group()[1 &lt; position()]">
					<xsl:if test="current-group()[2]/@ilvl!=number($level)+1">
						<error type="list_with_level_gap" ilvl="{number($level)+1}">
							<xsl:copy-of select="current-group()[2]"/>
						</error>
					</xsl:if>
					<xsl:copy-of select="epconvert:process_list_structure(current-group()[1 &lt; position()],number($level)+1)"/>
				</xsl:if>
			</xsl:element>
		</xsl:for-each-group>
	</xsl:function>
	<xsl:function name="epconvert:merge_section_headers">
		<xsl:param name="document" as="element()"/>
		<xsl:element name="{local-name($document)}">
			<xsl:for-each select="$document/@*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:for-each-group select="$document/*" group-adjacent="local-name(self::*)">
				<xsl:choose>
					<xsl:when test="count(current-group()) &gt; 1 and (some $x in ('module','header1','header2','header3') satisfies current-grouping-key()=$x)">
						<xsl:element name="{current-grouping-key()}">
							<xsl:attribute name="position_start" select="current-group()[1]/@position"/>
							<xsl:attribute name="position_end" select="current-group()[last()]/@position"/>
							<xsl:for-each select="current-group()/bookmark">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:introduct_sections">
		<xsl:param name="document" as="element()"/>
		<xsl:element name="{local-name($document)}">
			<xsl:for-each select="$document/@*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:element name="separator"/>
			<xsl:if test="$document/module[1]/preceding-sibling::*[not(local-name()='separator')]">
				<error type="content_before_module" position="{$document/module[1]/preceding-sibling::*[not(local-name()='separator')][last()]/@position}"/>
			</xsl:if>
			<xsl:copy-of select="$document/module[1]/preceding-sibling::*[position() &lt; last()]"/>
			<xsl:choose>
				<xsl:when test="$document/module">
					<xsl:apply-templates select="$document/module" mode="PARAGRAPHS_MAP_SECTIONS"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="content_with_starting_module">
						<xsl:element name="module">
							<xsl:attribute name="position" select="'0'"/>
						</xsl:element>
						<xsl:copy-of select="$document/element()"/>
					</xsl:variable>
					<xsl:apply-templates select="$content_with_starting_module/module" mode="PARAGRAPHS_MAP_SECTIONS"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:function>
	<xsl:template match="module" mode="PARAGRAPHS_MAP_SECTIONS">
		<xsl:variable name="all_elements" select="following-sibling::*[local-name()!='module']"/>
		<xsl:variable name="next_module" select="following-sibling::module[1]"/>
		<xsl:variable name="next_header1" select="following-sibling::header1[1]"/>
		<xsl:element name="module">
			<xsl:for-each select="attribute()|bookmark">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:if test="not(generate-id($next_header1)=generate-id(following-sibling::element()[1]))">
				<xsl:variable name="all_elements_2" select="following-sibling::*[not(some $x in ('module','header1') satisfies local-name()=$x)]"/>
				<xsl:for-each select="following-sibling::element()">
					<xsl:variable name="position" select="position()"/>
					<xsl:if test="generate-id($all_elements_2[$position])=generate-id(.)">
						<xsl:choose>
							<xsl:when test="local-name()='header2'">
								<error type="header2_not_under_header1" position="{@position}"/>
							</xsl:when>
							<xsl:when test="local-name()='header3'">
								<error type="header3_not_under_header1" position="{@position}"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="following-sibling::element()">
				<xsl:variable name="position" select="position()"/>
				<xsl:if test="local-name()='header1' and generate-id($all_elements[$position])=generate-id(.)">
					<xsl:element name="separator"/>
					<xsl:apply-templates select="." mode="PARAGRAPHS_MAP_SECTIONS"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		<xsl:if test="$next_module">
			<error type="multiple_modules"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="header1" mode="PARAGRAPHS_MAP_SECTIONS">
		<xsl:variable name="all_elements" select="following-sibling::*[not(some $x in ('module','header1') satisfies local-name()=$x)]"/>
		<xsl:variable name="next_header2" select="following-sibling::header2[1]"/>
		<xsl:element name="header1">
			<xsl:for-each select="attribute()|bookmark">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:if test="not(generate-id($next_header2)=generate-id(following-sibling::element()[1]))">
				<xsl:variable name="all_elements_2" select="following-sibling::*[not(some $x in ('module','header1','header2') satisfies local-name()=$x)]"/>
				<xsl:for-each select="following-sibling::element()">
					<xsl:variable name="position" select="position()"/>
					<xsl:if test="generate-id($all_elements_2[$position])=generate-id(.)">
						<xsl:choose>
							<xsl:when test="local-name()='header3'">
								<error type="header3_not_under_header2" position="{@position}"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="following-sibling::element()">
				<xsl:variable name="position" select="position()"/>
				<xsl:if test="local-name()='header2' and generate-id($all_elements[$position])=generate-id(.)">
					<xsl:element name="separator"/>
					<xsl:apply-templates select="." mode="PARAGRAPHS_MAP_SECTIONS"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="header2" mode="PARAGRAPHS_MAP_SECTIONS">
		<xsl:variable name="all_elements" select="following-sibling::*[not(some $x in ('module','header1','header2') satisfies local-name()=$x)]"/>
		<xsl:variable name="next_header3" select="following-sibling::header3[1]"/>
		<xsl:element name="header2">
			<xsl:for-each select="attribute()|bookmark">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:if test="not(generate-id($next_header3)=generate-id(following-sibling::element()[1]))">
				<xsl:variable name="all_elements_2" select="following-sibling::*[not(some $x in ('module','header1','header2','header3') satisfies local-name()=$x)]"/>
				<xsl:for-each select="following-sibling::element()">
					<xsl:variable name="position" select="position()"/>
					<xsl:if test="generate-id($all_elements_2[$position])=generate-id(.)">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="following-sibling::element()">
				<xsl:variable name="position" select="position()"/>
				<xsl:if test="local-name()='header3' and generate-id($all_elements[$position])=generate-id(.)">
					<xsl:element name="separator"/>
					<xsl:apply-templates select="." mode="PARAGRAPHS_MAP_SECTIONS"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="header3" mode="PARAGRAPHS_MAP_SECTIONS">
		<xsl:variable name="all_elements" select="following-sibling::*[not(some $x in ('module','header1','header2','header3') satisfies local-name()=$x)]"/>
		<xsl:element name="header3">
			<xsl:for-each select="attribute()|bookmark">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<xsl:for-each select="following-sibling::element()">
				<xsl:variable name="position" select="position()"/>
				<xsl:if test="generate-id($all_elements[$position])=generate-id(.)">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:function name="epconvert:clear_separators">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($element)">
				<xsl:copy-of select="$element"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name($element)}">
					<xsl:for-each select="$element/@*">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<xsl:for-each-group select="$element/*" group-adjacent="local-name(self::*)">
						<xsl:choose>
							<xsl:when test="current-grouping-key()='separator'">
								<xsl:if test="not(position()=last())">
									<xsl:element name="separator"/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="current-group()">
									<xsl:choose>
										<xsl:when test="element()">
											<xsl:copy-of select="epconvert:clear_separators(.)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:copy-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_for_empty_sections">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($element)">
				<xsl:copy-of select="$element"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name($element)}">
					<xsl:copy-of select="$element/attribute()"/>
					<xsl:if test="'module'=local-name($element) and $element/special_table[starts-with(@type,'section_metadata_')] and 0=count($element/para|$element/table|$element/list|$element/WOMI)">
						<error type="empty_noname_section" position="{$element/@position}"/>
					</xsl:if>
					<xsl:for-each select="$element/element()">
						<xsl:choose>
							<xsl:when test="element()[not(some $x in ('special_table','separator') satisfies $x=local-name())]">
								<xsl:copy-of select="epconvert:check_for_empty_sections(.)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="element()['special_table'=local-name() and 'quiz_WOMI_with_alternative_metadata'=@type]">
										<xsl:copy-of select="."/>
									</xsl:when>
									<xsl:when test="some $x in ('header1','header2','header3') satisfies local-name()=$x">
										<xsl:element name="{local-name()}">
											<xsl:copy-of select="attribute()"/>
											<error type="empty_section" position="{@position}"/>
											<xsl:copy-of select="element()"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:inspect_type_and_style" as="element()">
		<xsl:param name="context_node"/>
		<xsl:param name="current_position"/>
		<xsl:variable name="preceding_siblings_type_and_style" select="epconvert:inspect_preceding_siblings_type_and_style($context_node, $current_position)"/>
		<xsl:variable name="am_I_para" select="local-name($context_node)='p'"/>
		<xsl:variable name="am_I_list_item" select="$am_I_para and $context_node/w:pPr/w:numPr"/>
		<xsl:variable name="am_I_table" select="local-name($context_node)='tbl'"/>
		<xsl:variable name="am_I_WOMI" select="$am_I_table and (matches($context_node/w:tblPr/w:tblDescription/@w:val, '^WOMI_REFERENCE_(IMAGE|ICON|VIDEO|AUDIO|OINT)_(\d+)$') or $context_node/w:tblPr/w:tblDescription/@w:val='WOMI_V2_REFERENCE' or $context_node/w:tblPr/w:tblDescription/@w:val='EP_WOMI_GALLERY')"/>
		<xsl:variable name="my_style">
			<xsl:choose>
				<xsl:when test="$am_I_para">
					<xsl:choose>
						<xsl:when test="$am_I_list_item">
							<xsl:value-of select="if($context_node/w:pPr/w:pStyle/@w:val and not(some $x in $MS_WORD_STYLES/style[@key='list']/name/text() satisfies $context_node/w:pPr/w:pStyle/@w:val=$x)) then $context_node/w:pPr/w:pStyle/@w:val else 'normal'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="if($context_node/w:pPr/w:pStyle/@w:val) then $context_node/w:pPr/w:pStyle/@w:val else 'normal'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$am_I_WOMI">
					<xsl:value-of select="if($context_node/w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val) then $context_node/w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val else 'normal'"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="am_I_header" select="$am_I_para and (some $x in ('EPTytumoduu', 'EPNagwek1', 'EPNagwek2', 'EPNagwek3') satisfies $my_style=$x)"/>
		<xsl:variable name="bookmarks">
			<xsl:for-each select="$context_node/descendant-or-self::w:bookmarkStart">
				<xsl:variable name="bookmark_name" select="@w:name"/>
				<xsl:if test="@w:name!='_GoBack'">
					<xsl:element name="bookmark">
						<xsl:attribute name="id" select="$DOCXM_MAP_MY_ENTRY/bookmark[name/text()=$bookmark_name]/id/text()"/>
						<xsl:attribute name="name" select="$bookmark_name"/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:element name="output">
			<xsl:element name="me">
				<xsl:choose>
					<xsl:when test="$am_I_header">
						<xsl:element name="type">
							<xsl:choose>
								<xsl:when test="$my_style='EPNagwek1'">header1</xsl:when>
								<xsl:when test="$my_style='EPNagwek2'">header2</xsl:when>
								<xsl:when test="$my_style='EPNagwek3'">header3</xsl:when>
								<xsl:otherwise>module</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$am_I_list_item">
						<xsl:element name="type">list_item</xsl:element>
						<xsl:element name="style">
							<xsl:value-of select="$my_style"/>
						</xsl:element>
						<xsl:element name="ilvl">
							<xsl:value-of select="$context_node/w:pPr/w:numPr/w:ilvl/@w:val"/>
						</xsl:element>
						<xsl:element name="numId">
							<xsl:value-of select="$context_node/w:pPr/w:numPr/w:numId/@w:val"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$am_I_para">
						<xsl:element name="type">para</xsl:element>
						<xsl:element name="style">
							<xsl:value-of select="$my_style"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$am_I_WOMI">
						<xsl:element name="type">WOMI</xsl:element>
						<xsl:element name="style">
							<xsl:value-of select="$my_style"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="type">table</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:copy-of select="$bookmarks"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="$am_I_header and $preceding_siblings_type_and_style/type/text()='header'">
					<xsl:choose>
						<xsl:when test="$my_style=$preceding_siblings_type_and_style/style/text()">
							<xsl:element name="style_inherited_from">
								<xsl:element name="type">header</xsl:element>
								<xsl:element name="style">
									<xsl:value-of select="$my_style"/>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="separator"/>
							<xsl:element name="separation_reason">
								<xsl:element name="type">header</xsl:element>
								<xsl:element name="style">
									<xsl:value-of select="$preceding_siblings_type_and_style/style/text()"/>
								</xsl:element>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="some $x in ('none','header','metadata','author','core_curriculum','empty') satisfies $x=$preceding_siblings_type_and_style/type/text()">
					<xsl:element name="separator"/>
					<xsl:element name="separation_reason">
						<xsl:element name="type">
							<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$preceding_siblings_type_and_style/type/text()='table'">
					<xsl:element name="first_in_a_group">
						<xsl:element name="type">table</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$am_I_para">
							<xsl:choose>
								<xsl:when test="$my_style=$preceding_siblings_type_and_style/style/text()">
									<xsl:element name="style_inherited_from">
										<xsl:element name="type">
											<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
										</xsl:element>
										<xsl:element name="style">
											<xsl:value-of select="$my_style"/>
										</xsl:element>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="separator"/>
									<xsl:element name="separation_reason">
										<xsl:element name="type">
											<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
										</xsl:element>
										<xsl:element name="style">
											<xsl:value-of select="$preceding_siblings_type_and_style/style/text()"/>
										</xsl:element>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$am_I_WOMI">
									<xsl:choose>
										<xsl:when test="$my_style=$preceding_siblings_type_and_style/style/text()">
											<xsl:element name="style_inherited_from">
												<xsl:element name="type">
													<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
												</xsl:element>
												<xsl:element name="style">
													<xsl:value-of select="$my_style"/>
												</xsl:element>
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="separator"/>
											<xsl:element name="separation_reason">
												<xsl:element name="type">
													<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
												</xsl:element>
												<xsl:element name="style">
													<xsl:value-of select="$preceding_siblings_type_and_style/style/text()"/>
												</xsl:element>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="style_inherited_from">
										<xsl:element name="type">
											<xsl:value-of select="$preceding_siblings_type_and_style/type/text()"/>
										</xsl:element>
										<xsl:element name="style">
											<xsl:value-of select="$preceding_siblings_type_and_style/style/text()"/>
										</xsl:element>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:inspect_preceding_siblings_type_and_style" as="element()">
		<xsl:param name="context_node"/>
		<xsl:param name="current_position"/>
		<xsl:variable name="preceding_sibling" select="($context_node/preceding-sibling::w:p|$context_node/preceding-sibling::w:tbl)[last()]"/>
		<xsl:choose>
			<xsl:when test="not($preceding_sibling)">
				<xsl:element name="output">
					<xsl:element name="type">none</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="local-name($preceding_sibling)='p' and (some $x in ('EPTyturozdziau', 'EPTytupodrozdziau1', 'EPTytupodrozdziau2', 'EPTytumoduu', 'EPNagwek1', 'EPNagwek2', 'EPNagwek3') satisfies $preceding_sibling/w:pPr/w:pStyle/@w:val=$x)">
				<xsl:element name="output">
					<xsl:element name="type">header</xsl:element>
					<xsl:element name="style">
						<xsl:value-of select="$preceding_sibling/w:pPr/w:pStyle/@w:val"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="local-name($preceding_sibling)='tbl' and (starts-with($preceding_sibling/w:tblPr/w:tblDescription/@w:val,'EP_METADATA') or starts-with($preceding_sibling/w:tblPr/w:tblDescription/@w:val,'EP_ZAPIS_BIB') or $preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_IGNORE')">
				<xsl:element name="output">
					<xsl:element name="type">metadata</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="local-name($preceding_sibling)='tbl' and $preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_AUTHOR'">
				<xsl:element name="output">
					<xsl:element name="type">author</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="local-name($preceding_sibling)='tbl' and ($preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_CORE_CURRICULUM' or $preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_USPP_CORE_CURRICULUM')">
				<xsl:element name="output">
					<xsl:element name="type">core_curriculum</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="am_I_para" select="local-name($context_node)='p'"/>
				<xsl:choose>
					<xsl:when test="$am_I_para">
						<xsl:choose>
							<xsl:when test="local-name($preceding_sibling)='p'">
								<xsl:choose>
									<xsl:when test="not($preceding_sibling[normalize-space()])">
										<xsl:element name="output">
											<xsl:element name="type">empty</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="not($preceding_sibling//w:r[not(w:rPr/w:rStyle) or w:rPr/w:rStyle/@w:val!='EPKomentarzedycyjny'][normalize-space()] or $preceding_sibling/descendant::m:t[normalize-space()])">
										<xsl:element name="output">
											<xsl:element name="type">empty</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="$preceding_sibling/w:pPr/w:numPr">
										<xsl:element name="output">
											<xsl:element name="type">list_item</xsl:element>
											<xsl:element name="style">
												<xsl:value-of select="if($preceding_sibling/w:pPr/w:pStyle/@w:val and not(some $x in $MS_WORD_STYLES/style[@key='list']/name/text() satisfies  $preceding_sibling/w:pPr/w:pStyle/@w:val=$x)) then $preceding_sibling/w:pPr/w:pStyle/@w:val else 'normal'"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="output">
											<xsl:element name="type">para</xsl:element>
											<xsl:element name="style">
												<xsl:value-of select="if($preceding_sibling/w:pPr/w:pStyle/@w:val) then $preceding_sibling/w:pPr/w:pStyle/@w:val else 'normal'"/>
											</xsl:element>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="is_preceding_sibling_a_WOMI" select="matches($preceding_sibling/w:tblPr/w:tblDescription/@w:val, '^WOMI_REFERENCE_(IMAGE|ICON|VIDEO|AUDIO|OINT)_(\d+)$') or $preceding_sibling/w:tblPr/w:tblDescription/@w:val='WOMI_V2_REFERENCE' or $preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_WOMI_GALLERY'"/>
								<xsl:choose>
									<xsl:when test="$is_preceding_sibling_a_WOMI">
										<xsl:element name="output">
											<xsl:element name="type">WOMI</xsl:element>
											<xsl:element name="style">
												<xsl:value-of select="if($preceding_sibling/w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val) then $preceding_sibling/w:tr[1]/w:tc[1]/w:p/w:pPr/w:pStyle/@w:val else 'normal'"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="pre_preceding_sibling" select="epconvert:inspect_preceding_siblings_type_and_style($preceding_sibling, $current_position - 1)"/>
										<xsl:choose>
											<xsl:when test="some $x in ('none','header','metadata','author','core_curriculum','empty') satisfies $x=$pre_preceding_sibling/type/text()">
												<xsl:element name="output">
													<xsl:element name="type">table</xsl:element>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:element name="output">
													<xsl:element name="type">
														<xsl:value-of select="$pre_preceding_sibling/type/text()"/>
													</xsl:element>
													<xsl:element name="style">
														<xsl:value-of select="$pre_preceding_sibling/style/text()"/>
													</xsl:element>
												</xsl:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$preceding_sibling/w:pPr/w:numPr">
								<xsl:element name="output">
									<xsl:element name="type">para</xsl:element>
									<xsl:element name="style">
										<xsl:value-of select="if($preceding_sibling/w:pPr/w:pStyle/@w:val and not(some $x in $MS_WORD_STYLES/style[@key='list']/name/text() satisfies  $preceding_sibling/w:pPr/w:pStyle/@w:val=$x)) then $preceding_sibling/w:pPr/w:pStyle/@w:val else 'normal'"/>
									</xsl:element>
								</xsl:element>
							</xsl:when>
							<xsl:when test="not($preceding_sibling[normalize-space()]) or not($preceding_sibling/w:r[not(w:rPr/w:rStyle) or w:rPr/w:rStyle/@w:val!='EPKomentarzedycyjny'][normalize-space()] or $preceding_sibling/descendant::m:t[normalize-space()])">
								<xsl:variable name="pre_preceding_sibling" select="($context_node/preceding-sibling::w:p|$context_node/preceding-sibling::w:tbl)[last()-1]"/>
								<xsl:choose>
									<xsl:when test="not($pre_preceding_sibling)">
										<xsl:element name="output">
											<xsl:element name="type">none</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='p' and (some $x in ('EPTyturozdziau', 'EPTytupodrozdziau1', 'EPTytupodrozdziau2', 'EPTytumoduu', 'EPNagwek1', 'EPNagwek2', 'EPNagwek3', 'EPNagwek3') satisfies $pre_preceding_sibling/w:pPr/w:pStyle/@w:val=$x)">
										<xsl:element name="output">
											<xsl:element name="type">header</xsl:element>
											<xsl:element name="style">
												<xsl:value-of select="$pre_preceding_sibling/w:pPr/w:pStyle/@w:val"/>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='tbl' and (starts-with($pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val,'EP_METADATA') or starts-with($pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val,'EP_ZAPIS_BIB') or $pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_IGNORE')">
										<xsl:element name="output">
											<xsl:element name="type">metadata</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='tbl' and $pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_AUTHOR'">
										<xsl:element name="output">
											<xsl:element name="type">author</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='tbl' and ($pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_CORE_CURRICULUM' or $pre_preceding_sibling/w:tblPr/w:tblDescription/@w:val='EP_USPP_CORE_CURRICULUM')">
										<xsl:element name="output">
											<xsl:element name="type">core_curriculum</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='p'">
										<xsl:element name="output">
											<xsl:element name="type">empty</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:when test="local-name($pre_preceding_sibling)='tbl'">
										<xsl:copy-of select="epconvert:inspect_preceding_siblings_type_and_style($preceding_sibling, $current_position - 1)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="output">
											<xsl:element name="type">error</xsl:element>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="output">
									<xsl:element name="type">para</xsl:element>
									<xsl:element name="style">
										<xsl:value-of select="if($preceding_sibling/w:pPr/w:pStyle/@w:val and not(some $x in $MS_WORD_STYLES/style[@key='list']/name/text() satisfies $preceding_sibling/w:pPr/w:pStyle/@w:val=$x)) then $preceding_sibling/w:pPr/w:pStyle/@w:val else 'normal'"/>
									</xsl:element>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_if_following_siblings_is_table_or_WOMI" as="element()">
		<xsl:param name="context_node"/>
		<xsl:variable name="following_sibling" select="($context_node/following-sibling::w:p|$context_node/following-sibling::w:tbl)[1]"/>
		<xsl:choose>
			<xsl:when test="not($following_sibling)">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:when test="local-name($following_sibling)='p' and (some $x in ('EPTyturozdziau', 'EPTytupodrozdziau1', 'EPTytupodrozdziau2', 'EPTytumoduu', 'EPNagwek1', 'EPNagwek2', 'EPNagwek3') satisfies $following_sibling/w:pPr/w:pStyle/@w:val=$x)">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:when test="local-name($following_sibling)='tbl' and (starts-with($following_sibling/w:tblPr/w:tblDescription/@w:val,'EP_METADATA') or starts-with($following_sibling/w:tblPr/w:tblDescription/@w:val,'EP_ZAPIS_BIB') or $following_sibling/w:tblPr/w:tblDescription/@w:val='EP_IGNORE')">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:when test="local-name($following_sibling)='tbl' and $following_sibling/w:tblPr/w:tblDescription/@w:val='EP_AUTHOR'">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:when test="local-name($following_sibling)='tbl' and ($following_sibling/w:tblPr/w:tblDescription/@w:val='EP_CORE_CURRICULUM' or $following_sibling/w:tblPr/w:tblDescription/@w:val='EP_USPP_CORE_CURRICULUM')">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:when test="local-name($following_sibling)='p'">
				<xsl:element name="output"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="output">
					<xsl:element name="table_or_WOMI"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:template match="/w:document/w:body/w:p[descendant::w:r[not(w:rPr/w:rStyle/@w:val)][normalize-space()] or descendant::w:r[w:rPr/w:rStyle/@w:val!='EPKomentarzedycyjny'][normalize-space()] or descendant::m:t[normalize-space()]]" mode="PARAGRAPHS_MAP">
		<xsl:variable name="current_position" select="count(preceding-sibling::w:p|preceding-sibling::w:tbl)+1"/>
		<xsl:variable name="type_and_style" select="epconvert:inspect_type_and_style(.,$current_position)"/>
		<xsl:if test="$type_and_style/separator">
			<xsl:element name="separator"/>
		</xsl:if>
		<xsl:element name="{$type_and_style/me/type/text()}">
			<xsl:attribute name="position" select="$current_position"/>
			<xsl:if test="$type_and_style/me/type/text()='para' or $type_and_style/me/type/text()='list_item'">
				<xsl:attribute name="style" select="$type_and_style/me/style/text()"/>
				<xsl:if test="$type_and_style/me/type/text()='list_item'">
					<xsl:attribute name="ilvl" select="$type_and_style/me/ilvl/text()"/>
					<xsl:attribute name="numId" select="$type_and_style/me/numId/text()"/>
				</xsl:if>
			</xsl:if>
			<xsl:copy-of select="$type_and_style/me/bookmark"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/w:document/w:body/w:p[w:pPr/w:numPr]" mode="PARAGRAPHS_MAP">
		<xsl:variable name="current_position" select="count(preceding-sibling::w:p|preceding-sibling::w:tbl)+1"/>
		<xsl:variable name="type_and_style" select="epconvert:inspect_type_and_style(.,$current_position)"/>
		<xsl:variable name="is_empty" select="not(descendant::w:r[not(w:rPr/w:rStyle/@w:val)][normalize-space()] or descendant::w:r[w:rPr/w:rStyle/@w:val!='EPKomentarzedycyjny'][normalize-space()] or descendant::m:t[normalize-space()])"/>
		<xsl:choose>
			<xsl:when test="$is_empty">
				<xsl:variable name="is_following_sibling_table_or_WOMI" select="if(epconvert:check_if_following_siblings_is_table_or_WOMI(.)/table_or_WOMI) then true() else false()"/>
				<xsl:if test="$is_following_sibling_table_or_WOMI">
					<xsl:if test="$type_and_style/separator">
						<xsl:element name="separator"/>
					</xsl:if>
					<xsl:element name="{$type_and_style/me/type/text()}">
						<xsl:attribute name="position" select="$current_position"/>
						<xsl:if test="$type_and_style/me/type/text()='para' or $type_and_style/me/type/text()='list_item'">
							<xsl:attribute name="style" select="$type_and_style/me/style/text()"/>
							<xsl:if test="$type_and_style/me/type/text()='list_item'">
								<xsl:attribute name="ilvl" select="$type_and_style/me/ilvl/text()"/>
								<xsl:attribute name="numId" select="$type_and_style/me/numId/text()"/>
							</xsl:if>
						</xsl:if>
						<xsl:copy-of select="$type_and_style/me/bookmark"/>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$type_and_style/separator">
					<xsl:element name="separator"/>
				</xsl:if>
				<xsl:element name="{$type_and_style/me/type/text()}">
					<xsl:attribute name="position" select="$current_position"/>
					<xsl:if test="$type_and_style/me/type/text()='para' or $type_and_style/me/type/text()='list_item'">
						<xsl:attribute name="style" select="$type_and_style/me/style/text()"/>
						<xsl:if test="$type_and_style/me/type/text()='list_item'">
							<xsl:attribute name="ilvl" select="$type_and_style/me/ilvl/text()"/>
							<xsl:attribute name="numId" select="$type_and_style/me/numId/text()"/>
						</xsl:if>
					</xsl:if>
					<xsl:copy-of select="$type_and_style/me/bookmark"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="w:tbl[not(w:tblPr/w:tblDescription/@w:val) or (not(starts-with(w:tblPr/w:tblDescription/@w:val,'EP_METADATA')) and not(starts-with(w:tblPr/w:tblDescription/@w:val,'EP_ZAPIS_BIB')) and w:tblPr/w:tblDescription/@w:val!='EP_AUTHOR' and w:tblPr/w:tblDescription/@w:val!='EP_CORE_CURRICULUM' and w:tblPr/w:tblDescription/@w:val!='EP_USPP_CORE_CURRICULUM')]" mode="PARAGRAPHS_MAP">
		<xsl:variable name="current_position" select="count(preceding-sibling::w:p|preceding-sibling::w:tbl)+1"/>
		<xsl:variable name="type_and_style" select="epconvert:inspect_type_and_style(.,$current_position)"/>
		<xsl:if test="$type_and_style/separator">
			<xsl:element name="separator"/>
		</xsl:if>
		<xsl:element name="{$type_and_style/me/type/text()}">
			<xsl:attribute name="position" select="$current_position"/>
			<xsl:if test="$type_and_style/me/type/text()='WOMI'">
				<xsl:attribute name="style" select="$type_and_style/me/style/text()"/>
			</xsl:if>
			<xsl:copy-of select="$type_and_style/me/bookmark"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:tbl[starts-with(w:tblPr/w:tblDescription/@w:val,'EP_METADATA_') or starts-with(w:tblPr/w:tblDescription/@w:val,'EP_ZAPIS_BIB_') or w:tblPr/w:tblDescription/@w:val='EP_IGNORE' or w:tblPr/w:tblDescription/@w:val='EP_METADATA' or w:tblPr/w:tblDescription/@w:val='EP_AUTHOR' or w:tblPr/w:tblDescription/@w:val='EP_CORE_CURRICULUM' or w:tblPr/w:tblDescription/@w:val='EP_USPP_CORE_CURRICULUM']" mode="PARAGRAPHS_MAP">
		<xsl:variable name="current_position" select="count(preceding-sibling::w:p|preceding-sibling::w:tbl)+1"/>
		<xsl:element name="separator"/>
		<xsl:copy-of select="epconvert:process_special_table_attributes(.,$current_position)"/>
	</xsl:template>
	<xsl:template match="*[text()!='']" mode="PARAGRAPHS_MAP"/>
	<xsl:function name="epconvert:core-curriculum_refs_2_entries">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($element) and $element/@type='module_core_curriuculum_uspp' and $element/attribute['core-curriculum_key'=@key]">
				<xsl:element name="{local-name($element)}">
					<xsl:namespace name="mml" select="'http://www.w3.org/1998/Math/MathML'"/>
					<xsl:copy-of select="$element/@*"/>
					<xsl:for-each select="$element/attribute['core-curriculum_key'=@key]">
						<xsl:variable name="key" select="text()"/>
						<xsl:variable name="entry" select="$CORE_CURRICULUM_MAP/core_curriculum_map/uspp/entry[@key=$key]"/>
						<xsl:element name="{local-name($entry)}">
							<xsl:copy-of select="$entry/@*"/>
							<xsl:copy-of select="$entry/element()"/>
							<xsl:copy-of select="$element/error|$element/warn"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$element/descendant::special_table[@type='module_core_curriuculum_uspp']">
				<xsl:element name="{local-name($element)}">
					<xsl:copy-of select="$element/attribute()"/>
					<xsl:for-each select="$element/element()">
						<xsl:copy-of select="epconvert:core-curriculum_refs_2_entries(.)"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:map_old_core-curriculum_top">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="$element/descendant::special_table[@type='module_core_curriuculum']">
				<xsl:element name="{local-name($element)}">
					<xsl:copy-of select="$element/attribute()"/>
					<xsl:copy-of select="epconvert:map_old_core-curriculum($element/element())"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:map_old_core-curriculum">
		<xsl:param name="elements" as="node()*"/>
		<xsl:for-each select="$elements">
			<xsl:choose>
				<xsl:when test="local-name()='special_table' and @type='module_core_curriuculum'">
					<xsl:variable name="special_table" select="."/>
					<xsl:variable name="core_curriculum_element" select="$special_table/element[@id='EP_CORE_CURRICULUM']"/>
					<xsl:for-each select="$core_curriculum_element/error">
						<xsl:element name="special_table">
							<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
							<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
							<xsl:copy-of select="."/>
						</xsl:element>
					</xsl:for-each>
					<xsl:for-each select="$core_curriculum_element/attribute[@name='EP_CORE_CURRICULUM']">
						<xsl:variable name="education_level" select="@group_2"/>
						<xsl:variable name="subject" select="@group_3"/>
						<xsl:choose>
							<xsl:when test="'true'=@multiple_value">
								<xsl:for-each select="value">
									<xsl:variable name="core_curriculum_value" select="text()"/>
									<xsl:choose>
										<xsl:when test="not($core_curriculum_value) or ''=$core_curriculum_value">
											<xsl:element name="special_table">
												<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
												<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
												<xsl:element name="error">
													<xsl:attribute name="type">core_curriculum_unable_to_map</xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:analyze-string select="$core_curriculum_value" regex="^([^:]+):(.+)$">
												<xsl:matching-substring>
													<xsl:variable name="code" select="regex-group(1)"/>
													<xsl:variable name="mapped_code" select="$CORE_CURRICULUM_MAP/core_curriculum_map/old_2_uspp_mapping/entry[@key=concat($EDUCATION_LEVELS_MAP/level[@key=$education_level]/text(),'$',$subject,'$',$code)]/text()"/>
													<xsl:choose>
														<xsl:when test="not($mapped_code) or ''=$mapped_code">
															<xsl:element name="special_table">
																<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
																<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
																<xsl:element name="error">
																	<xsl:attribute name="type">core_curriculum_unable_to_map_no_such_key</xsl:attribute>
																	<xsl:value-of select="$core_curriculum_value"/>
																</xsl:element>
															</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:element name="special_table">
																<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
																<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
																<xsl:element name="attribute">
																	<xsl:attribute name="tag" select="'EP_USPP_CORE_CURRICULUM'"/>
																	<xsl:attribute name="key" select="'core-curriculum_key'"/>
																	<xsl:value-of select="$mapped_code"/>
																</xsl:element>
															</xsl:element>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:matching-substring>
												<xsl:non-matching-substring>
													<xsl:element name="special_table">
														<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
														<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
														<xsl:element name="error">
															<xsl:attribute name="type">core_curriculum_unable_to_map</xsl:attribute>
															<xsl:value-of select="$core_curriculum_value"/>
														</xsl:element>
													</xsl:element>
												</xsl:non-matching-substring>
											</xsl:analyze-string>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="core_curriculum_value" select="text()"/>
								<xsl:choose>
									<xsl:when test="not($core_curriculum_value) or ''=$core_curriculum_value">
										<xsl:element name="special_table">
											<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
											<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
											<xsl:element name="error">
												<xsl:attribute name="type">core_curriculum_unable_to_map</xsl:attribute>
											</xsl:element>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:analyze-string select="$core_curriculum_value" regex="^([^:]+):(.+)$">
											<xsl:matching-substring>
												<xsl:variable name="code" select="regex-group(1)"/>
												<xsl:variable name="mapped_code" select="$CORE_CURRICULUM_MAP/core_curriculum_map/old_2_uspp_mapping/entry[@key=concat($EDUCATION_LEVELS_MAP/level[@key=$education_level]/text(),'$',$subject,'$',$code)]/text()"/>
												<xsl:choose>
													<xsl:when test="not($mapped_code) or ''=$mapped_code">
														<xsl:element name="special_table">
															<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
															<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
															<xsl:element name="error">
																<xsl:attribute name="type">core_curriculum_unable_to_map_no_such_key</xsl:attribute>
																<xsl:value-of select="$core_curriculum_value"/>
															</xsl:element>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise>
														<xsl:element name="special_table">
															<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
															<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
															<xsl:element name="attribute">
																<xsl:attribute name="tag" select="'EP_USPP_CORE_CURRICULUM'"/>
																<xsl:attribute name="key" select="'core-curriculum_key'"/>
																<xsl:value-of select="$mapped_code"/>
															</xsl:element>
														</xsl:element>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:matching-substring>
											<xsl:non-matching-substring>
												<xsl:element name="special_table">
													<xsl:copy-of select="$special_table/@*[not('type'=local-name())]"/>
													<xsl:attribute name="type" select="'module_core_curriuculum_uspp'"/>
													<xsl:element name="error">
														<xsl:attribute name="type">core_curriculum_unable_to_map</xsl:attribute>
														<xsl:value-of select="$core_curriculum_value"/>
													</xsl:element>
												</xsl:element>
											</xsl:non-matching-substring>
										</xsl:analyze-string>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="descendant::special_table[@type='module_core_curriuculum']">
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="epconvert:map_old_core-curriculum(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:check_metadata_top">
		<xsl:param name="element" as="element()"/>
		<xsl:variable name="errors">
			<xsl:element name="global_errors">
				<xsl:if test="not(string-join($ROOT/w:document/w:body/w:p[w:pPr/w:pStyle[@w:val='EPTytumoduu']]/w:r/w:t/text(),''))">
					<xsl:element name="error">
						<xsl:attribute name="type">EM0001</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:for-each select="$element">
					<xsl:if test="not(descendant::special_table[@type='global_metadata'])">
						<xsl:element name="error">
							<xsl:attribute name="type">global_metadata_table_missing</xsl:attribute>
						</xsl:element>
					</xsl:if>
					<xsl:if test="not(descendant::special_table[@type='module_author' and not(descendant::error)])">
						<xsl:element name="error">
							<xsl:attribute name="type">EM0006</xsl:attribute>
						</xsl:element>
					</xsl:if>
					<xsl:if test="not(descendant::special_table[@type='module_core_curriuculum_uspp' and not(descendant::error)])">
						<xsl:element name="error">
							<xsl:attribute name="type">EM0007</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="{local-name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:copy-of select="$errors"/>
			<xsl:copy-of select="epconvert:check_metadata($element/element())"/>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:check_metadata">
		<xsl:param name="elements" as="node()*"/>
		<xsl:for-each select="$elements">
			<xsl:choose>
				<xsl:when test="local-name()='error'">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:when test="local-name()='warn'">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:when test="(ancestor::element()[@special_block] or @type='ignore_metadata') and local-name()='special_table'">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:when test="@type='global_metadata' and local-name()='special_table'">
					<xsl:choose>
						<xsl:when test="preceding::special_table[@type='global_metadata']">
							<xsl:element name="error">
								<xsl:attribute name="type">global_metadata_table_duplicate</xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="errors">
								<xsl:choose>
									<xsl:when test="'FREEFORM'=attribute[@key='ep:template']">
										<xsl:if test="not(attribute[@key='ep:grid-width']/text())">
											<xsl:element name="error">
												<xsl:attribute name="type">global_metadata_template_freeform_but_no_grid_width</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="not(attribute[@key='ep:grid-height']/text())">
											<xsl:element name="error">
												<xsl:attribute name="type">global_metadata_template_freeform_but_no_grid_height</xsl:attribute>
											</xsl:element>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="attribute[@key='ep:grid-width']/text()">
											<xsl:element name="warn">
												<xsl:attribute name="type">global_metadata_template_not_freeform_but_grid_width</xsl:attribute>
											</xsl:element>
										</xsl:if>
										<xsl:if test="attribute[@key='ep:grid-height']/text()">
											<xsl:element name="warn">
												<xsl:attribute name="type">global_metadata_template_not_freeform_but_grid_height</xsl:attribute>
											</xsl:element>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="{local-name()}">
								<xsl:copy-of select="attribute()"/>
								<xsl:copy-of select="$errors"/>
								<xsl:copy-of select="element()"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@type='module_author' and local-name()='special_table'">
					<xsl:variable name="author" select="."/>
					<xsl:variable name="errors">
						<xsl:for-each select="preceding::special_table[@type='module_author']">
							<xsl:if test="./attribute[@key='first_name']=$author/attribute[@key='first_name'] and ./attribute[@key='second_name']=$author/attribute[@key='second_name'] and ./attribute[@key='email']=$author/attribute[@key='email']">
								<xsl:element name="error">
									<xsl:attribute name="type">author_duplicate</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="element()"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="@type='module_core_curriuculum_uspp' and local-name()='special_table'">
					<xsl:choose>
						<xsl:when test="attribute">
							<xsl:variable name="value" select="attribute/text()"/>
							<xsl:choose>
								<xsl:when test="0 &lt; count(preceding::special_table[@type='module_core_curriuculum_uspp']/attribute[text()=$value])">
									<xsl:element name="special_table">
										<xsl:copy-of select="@*"/>
										<xsl:copy-of select="attribute"/>
										<xsl:element name="warn">
											<xsl:attribute name="type">core_curriculum_metadata_duplicate_value_2</xsl:attribute>
											<xsl:attribute name="count" select="count(preceding::special_table[@type='module_core_curriuculum_uspp']/attribute[text()=$value])+1"/>
											<xsl:attribute name="code" select="$value"/>
										</xsl:element>
									</xsl:element>
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
				</xsl:when>
				<xsl:when test="@type='module_keyword' and local-name()='special_table'">
					<xsl:variable name="keyword" select="."/>
					<xsl:variable name="errors">
						<xsl:for-each select="preceding::special_table[@type='module_keyword']">
							<xsl:if test="./attribute[@key='md:keyword']=$keyword/attribute[@key='md:keyword']">
								<xsl:element name="warn">
									<xsl:attribute name="type">keyword_already_defined_in_this_module</xsl:attribute>
									<xsl:element name="name">
										<xsl:value-of select="$keyword/attribute[@key='md:keyword']"/>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="'HIST4_5'=$GLOBAL_METADATA/subtype/text() and (not($keyword/@subtype) or $keyword/@subtype!=$GLOBAL_METADATA/subtype/text())">
							<xsl:element name="error">
								<xsl:attribute name="type">keyword_metadata_subtype_different_then_module_metadata_subtype</xsl:attribute>
								<xsl:attribute name="global" select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$GLOBAL_METADATA/subtype]/name"/>
							</xsl:element>
						</xsl:if>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="element()"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="local-name()='header1'">
					<xsl:variable name="type" select="$GLOBAL_METADATA/ep:type"/>
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:variable name="errors">
						<xsl:if test="not(special_table[starts-with(@type,'section_metadata_')])">
							<xsl:if test="not(some $x in ('NONE','COLUMNS') satisfies $x=$template)">
								<xsl:element name="error">
									<xsl:attribute name="type">global_metadata_template_is_set_but_no_section_metadata</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="'COLUMNS'=$template and special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']">
							<xsl:variable name="columns" select="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:columns']"/>
							<xsl:if test="1 &lt; $columns">
								<xsl:if test="count(header2) != $columns">
									<xsl:element name="error">
										<xsl:attribute name="type">section_metadata_linear_columns_mismatch_no_of_subsections</xsl:attribute>
										<xsl:attribute name="columns" select="$columns"/>
										<xsl:attribute name="subsections" select="count(header2)"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="0 &lt; count(para|table|WOMI|list)">
									<xsl:element name="error">
										<xsl:attribute name="type">section_metadata_linear_but_content_in_section1</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:if>
						</xsl:if>
						<xsl:if test="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']">
							<xsl:variable name="recipient" select="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:recipient']"/>
							<xsl:variable name="status" select="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:status']"/>
							<xsl:if test="'teacher'=$recipient and 'teacher'=$GLOBAL_METADATA/ep:recipient">
								<xsl:element name="warn">
									<xsl:attribute name="type">teacher_recipient_in_teacher_module</xsl:attribute>
								</xsl:element>
							</xsl:if>
							<xsl:if test="(some $x in ('expanding','supplemental') satisfies $x=$status) and not($GLOBAL_METADATA/ep:status='canon')">
								<xsl:element name="error">
									<xsl:attribute name="type">expanding_or_supplemental_status_not_in_canon_module</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="'COLUMNS'=$template and not(special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear'])">
							<xsl:if test="header2/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear_l2']">
								<xsl:element name="error">
									<xsl:attribute name="type">section_metadata_linear_missing_while_section_metadata_l2</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:if>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="epconvert:check_metadata(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="local-name()='module'">
					<xsl:variable name="type" select="$GLOBAL_METADATA/ep:type"/>
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:variable name="errors">
						<xsl:if test="not(some $x in ('NONE','COLUMNS','FREEFORM') satisfies $x=$template)">
							<xsl:variable name="noname_subsection" select="0 &lt; count(para|table|WOMI|list)"/>
							<xsl:variable name="subsections" select="if ($noname_subsection) then 1+count(header1) else count(header1) "/>
							<xsl:variable name="tiles" select="count($TEMPLATE_MAPPINGS/template[key=$template]/tile)"/>
							<xsl:if test="$tiles &lt; $subsections">
								<xsl:element name="error">
									<xsl:attribute name="type">global_metadata_template_tiles_no_mismatch_sections_no</xsl:attribute>
									<xsl:attribute name="subsections" select="$subsections"/>
									<xsl:attribute name="tiles" select="$tiles"/>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="0 &lt; count(para|table|WOMI|list)">
							<xsl:if test="not(special_table[starts-with(@type,'section_metadata_')])">
								<xsl:if test="not(some $x in ('NONE','COLUMNS') satisfies $x=$template)">
									<xsl:element name="error">
										<xsl:attribute name="type">global_metadata_template_is_set_but_no_section_metadata</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:if>
							<xsl:if test="'COLUMNS'=$template and special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']">
								<xsl:variable name="columns" select="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:columns']"/>
								<xsl:if test="1 &lt; $columns">
									<xsl:element name="error">
										<xsl:attribute name="type">noname_section_metadata_linear_with_columns_more_than_1</xsl:attribute>
										<xsl:attribute name="columns" select="$columns"/>
									</xsl:element>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="epconvert:check_metadata(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="local-name()='header2'">
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:variable name="errors">
						<xsl:if test="'COLUMNS'=$template">
							<xsl:variable name="special_table" select="special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear_l2']"/>
							<xsl:if test="not($special_table)">
								<xsl:variable name="columns" select="parent::header1/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:columns']"/>
								<xsl:if test="$columns and 1 &lt; $columns">
									<xsl:element name="error">
										<xsl:attribute name="type">section_metadata_linear_but_no_l2_section_metadata</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="epconvert:check_metadata(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="@type='section_metadata_linear_l2' and local-name()='special_table'">
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:choose>
						<xsl:when test="'COLUMNS'=$template">
							<xsl:choose>
								<xsl:when test="'header2'!=local-name(parent::element())">
									<xsl:element name="error">
										<xsl:attribute name="type">section_metadata_l2_not_supported_in_this_context</xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="preceding-sibling::special_table[@type='section_metadata_linear_l2']">
											<xsl:element name="error">
												<xsl:attribute name="type">section_metadata_l2_duplicate</xsl:attribute>
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="errors">
												<xsl:choose>
													<xsl:when test="not(ancestor::header1/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear'])">
														
	
														
														
													</xsl:when>
													<xsl:when test="1=ancestor::header1/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_linear']/attribute[@key='ep:columns']">
														<xsl:element name="error">
															<xsl:attribute name="type">section_metadata_l2_not_supported_in_this_context_parent_no_columns_1</xsl:attribute>
														</xsl:element>
													</xsl:when>
												</xsl:choose>
											</xsl:variable>
											<xsl:element name="{local-name()}">
												<xsl:copy-of select="attribute()"/>
												<xsl:copy-of select="$errors"/>
												<xsl:copy-of select="element()"/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="'header2'!=local-name(parent::element())">
								<xsl:element name="error">
									<xsl:attribute name="type">section_metadata_l2_not_supported_in_this_context</xsl:attribute>
								</xsl:element>
							</xsl:if>
							<xsl:element name="error">
								<xsl:attribute name="type">section_metadata_not_linear_but_l2_section_metadata</xsl:attribute>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="starts-with(@type, 'section_metadata_') and local-name()='special_table'">
					<xsl:variable name="special_table" select="."/>
					<xsl:variable name="special_table_type" select="@type"/>
					<xsl:variable name="special_table_subtype" select="@subtype"/>
					<xsl:variable name="type" select="$GLOBAL_METADATA/ep:type"/>
					<xsl:variable name="template" select="$GLOBAL_METADATA/ep:template"/>
					<xsl:choose>
						<xsl:when test="preceding-sibling::special_table[starts-with(@type,'section_metadata_') and not(@type='section_metadata_linear_l2')]">
							<xsl:if test="not(some $x in ('module','header1') satisfies $x=local-name(parent::element()))">
								<xsl:element name="error">
									<xsl:attribute name="type">section_metadata_l1_not_supported_in_this_context</xsl:attribute>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$GLOBAL_METADATA/subtype!=$special_table_subtype">
								<xsl:element name="error">
									<xsl:attribute name="type">section_metadata_l1_subtype_different_then_module_metadata_subtype</xsl:attribute>
									<xsl:attribute name="global" select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$GLOBAL_METADATA/subtype]/name"/>
									<xsl:attribute name="local" select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$special_table_subtype]/name"/>
								</xsl:element>
							</xsl:if>
							<xsl:element name="error">
								<xsl:attribute name="type">section_metadata_l1_duplicate</xsl:attribute>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="not(some $x in ('module','header1') satisfies $x=local-name(parent::element()))">
									<xsl:element name="error">
										<xsl:attribute name="type">section_metadata_l1_not_supported_in_this_context</xsl:attribute>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$GLOBAL_METADATA/subtype!=$special_table_subtype">
											<xsl:element name="error">
												<xsl:attribute name="type">section_metadata_l1_subtype_different_then_module_metadata_subtype</xsl:attribute>
												<xsl:attribute name="global" select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$GLOBAL_METADATA/subtype]/name"/>
												<xsl:attribute name="local" select="$TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$special_table_subtype]/name"/>
											</xsl:element>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="not(some $x in ('NONE', 'COLUMNS') satisfies $x=$template) and 'section_metadata_linear'=$special_table_type">
													<xsl:element name="error">
														<xsl:attribute name="type">section_metadata_linear_but_not_linear_module</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:when test="'FREEFORM'!=$template and 'section_metadata_freeform'=$special_table_type">
													<xsl:element name="error">
														<xsl:attribute name="type">section_metadata_freeform_but_not_freeform_module</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:when test="(some $x in ('NONE', 'COLUMNS', 'FREEFORM') satisfies $x=$template) and 'section_metadata_tile'=$special_table_type">
													<xsl:element name="error">
														<xsl:attribute name="type">section_metadata_tile_but_not_tile_module</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:variable name="errors">
														<xsl:variable name="role" select="$special_table/attribute[@key='ep:role']"/>
														<xsl:if test="'NONE'!=$role">
															<xsl:choose>
																<xsl:when test="'NONE'!=$type">
																	<xsl:if test="not($TEMPLATE_MAPPINGS/moduleTypesSet[typesSetCode=$special_table_subtype]/module[type=$type]/descendant::section[role=$role])">
																		<xsl:element name="error">
																			<xsl:attribute name="type">section_metadata_l1_role_not_from_that_module_type</xsl:attribute>
																		</xsl:element>
																	</xsl:if>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:element name="error">
																		<xsl:attribute name="type">section_metadata_no_module_type_but_role</xsl:attribute>
																	</xsl:element>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<xsl:if test="'section_metadata_tile'=$special_table_type">
															<xsl:variable name="tile" select="$special_table/attribute[@key='ep:tile']"/>
															<xsl:if test="not($TEMPLATE_MAPPINGS/template[key=$template]/tile[key=$tile])">
																<xsl:element name="error">
																	<xsl:attribute name="type">section_metadata_l1_tile_not_from_that_template</xsl:attribute>
																</xsl:element>
															</xsl:if>
															<xsl:if test="some $x in (parent::header1/preceding-sibling::header1/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_tile']/attribute[@key='ep:tile']/text(),parent::header1/parent::module/special_table[starts-with(@type,'section_metadata_')][1][@type='section_metadata_tile']/attribute[@key='ep:tile']/text()) satisfies $x=$tile">
																<xsl:element name="error">
																	<xsl:attribute name="type">section_metadata_tile_duplicate</xsl:attribute>
																	<xsl:attribute name="tile" select="$TEMPLATE_MAPPINGS/template[key=$template]/tile[key=$tile]/name"/>
																</xsl:element>
															</xsl:if>
														</xsl:if>
														<xsl:if test="'NONE'=$template and 1 &lt; $special_table/attribute[@key='ep:columns']">
															<xsl:element name="error">
																<xsl:attribute name="type">section_metadata_linear_old_but_columns_more_then_1</xsl:attribute>
															</xsl:element>
														</xsl:if>
													</xsl:variable>
													<xsl:element name="{local-name()}">
														<xsl:copy-of select="attribute()"/>
														<xsl:copy-of select="$errors"/>
														<xsl:copy-of select="element()"/>
													</xsl:element>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="@type='bibliography_entry' and local-name()='special_table'">
					<xsl:variable name="errors">
						<xsl:variable name="validate" select="attribute[@key='validate']"/>
						<xsl:if test="some $x in ('article','book','bookpart','report') satisfies $x=$validate">
							<xsl:if test="0 = count(element[@id='author'])">
								<xsl:element name="error">
									<xsl:attribute name="type">bibliography_minimum_1_author_required</xsl:attribute>
								</xsl:element>
							</xsl:if>
						</xsl:if>
						<xsl:if test="element[@id='author'] and not(element[@id='author']/error)">
							<xsl:variable name="persons" select="element[@id='author']"/>
							<xsl:if test="$persons/attribute[@multiple_value='true']">
								<xsl:variable name="count" select="count($persons/attribute[@key='surname']/value)"/>
								<xsl:for-each select="1 to $count">
									<xsl:variable name="i" select="."/>
									<xsl:variable name="detect_errors" as="element()">
										<errors>
											<xsl:for-each select="1 to $i">
												<xsl:variable name="j" select="."/>
												<xsl:if test="$j!=$i">
													<xsl:if test="$persons/attribute[@key='surname']/value[$i]=$persons/attribute[@key='surname']/value[$j] and $persons/attribute[@key='name']/value[$i]=$persons/attribute[@key='name']/value[$j]">
														<error/>
													</xsl:if>
												</xsl:if>
											</xsl:for-each>
										</errors>
									</xsl:variable>
									<xsl:if test="$detect_errors/error">
										<xsl:element name="warn">
											<xsl:attribute name="type">bibliography_author_duplicate</xsl:attribute>
											<xsl:element name="name">
												<xsl:value-of select="$persons/attribute[@key='surname']/value[$i]"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="$persons/attribute[@key='name']/value[$i]"/>
											</xsl:element>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:if>
						<xsl:if test="element[@id='editor'] and not(element[@id='editor']/error)">
							<xsl:variable name="persons" select="element[@id='editor']"/>
							<xsl:if test="$persons/attribute[@multiple_value='true']">
								<xsl:variable name="count" select="count($persons/attribute[@key='surname']/value)"/>
								<xsl:for-each select="1 to $count">
									<xsl:variable name="i" select="."/>
									<xsl:variable name="detect_errors" as="element()">
										<errors>
											<xsl:for-each select="1 to $i">
												<xsl:variable name="j" select="."/>
												<xsl:if test="$j!=$i">
													<xsl:if test="$persons/attribute[@key='surname']/value[$i]=$persons/attribute[@key='surname']/value[$j] and $persons/attribute[@key='name']/value[$i]=$persons/attribute[@key='name']/value[$j]">
														<error/>
													</xsl:if>
												</xsl:if>
											</xsl:for-each>
										</errors>
									</xsl:variable>
									<xsl:if test="$detect_errors/error">
										<xsl:element name="warn">
											<xsl:attribute name="type">bibliography_editor_duplicate</xsl:attribute>
											<xsl:element name="name">
												<xsl:value-of select="$persons/attribute[@key='surname']/value[$i]"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="$persons/attribute[@key='name']/value[$i]"/>
											</xsl:element>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:if>
						<xsl:variable name="pages-start" select="attribute[@key='pages-start']/text()"/>
						<xsl:variable name="pages-end" select="attribute[@key='pages-end']/text()"/>
						<xsl:if test="$pages-start and $pages-end and (number($pages-end) &lt; number($pages-start))">
							<xsl:element name="error">
								<xsl:attribute name="type">bibliography_pages_start_greather_than_pages_end</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:variable>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="$errors"/>
						<xsl:copy-of select="element()"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="epconvert:check_metadata(element())"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:clean_meanings_styles_top">
		<xsl:param name="element" as="element()"/>
		<xsl:element name="{local-name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:copy-of select="epconvert:clean_meanings_styles($element/element())"/>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:clean_meanings_styles">
		<xsl:param name="elements" as="node()*"/>
		<xsl:for-each select="$elements">
			<xsl:choose>
				<xsl:when test="local-name()='error'">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:when test="(ancestor::element()[@special_block] or starts-with(@tag,'EP_METADATA_SECTION_') or @type='ignore_metadata' or @type='global_metadata' or @type='module_author' or @type='module_core_curriuculum' or @type='module_core_curriuculum_uspp' or @type='module_keyword' or @type='bibliography_entry' or @type='womi_gallery_metadata' or starts-with(@type,'section_metadata_')) and local-name()='special_table'">
					<xsl:copy-of select="."/>
				</xsl:when>
				<xsl:when test="local-name()='special_table'">
					<xsl:variable name="tag" select="@tag"/>
					<warn type="special_table_not_supported_in_this_context">
						<xsl:choose>
							<xsl:when test="$tag">
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@tag=$tag]/name"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='']/name"/>
							</xsl:otherwise>
						</xsl:choose>
					</warn>
				</xsl:when>
				<xsl:when test="not(@style)">
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="epconvert:clean_meanings_styles(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="ancestor::element()[@special_block]">
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()[local-name()!='style']"/>
						<xsl:copy-of select="epconvert:clean_meanings_styles(element())"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="not(some $x in ('normal','EPNotatka-wskazwka','EPNotatka-ostrzeenie','EPNotatka-wane','EPNotka-wskazwka','EPNotka-ostrzeenie','EPNotka-wane','EPNotka-ciekawostka','EPNotka-zapamitaj','EPCytatakapit','EPKodakapit','EPKomentarztechniczny','EPPrzykad','EPPolecenie','EPLead','EPIntro','EPPrzygotujprzedlekcj','EPNauczyszsi','EPPrzypomnijsobie','EPOdziele','EPStreszczenie') satisfies @style=$x)">
					<xsl:choose>
						<xsl:when test="'EPZadanie'=@style and 'WOMI'=local-name()">
							<xsl:variable name="special_table" select="epconvert:process_special_table_attributes(epconvert:select_element_for_processing(@position),0)"/>
							<xsl:variable name="WOMI_id" select="$special_table/element[1]/@id"/>
							<xsl:variable name="WOMI_type" select="$special_table/element[1]/attribute[@key='ep:id']/@group_2"/>
							<xsl:choose>
								<xsl:when test="'OINT'=$WOMI_type">
									<xsl:element name="exercise_WOMI">
										<xsl:attribute name="special_block" select="true()"/>
										<xsl:attribute name="WOMI_id" select="$WOMI_id"/>
										<xsl:copy-of select="@position"/>
									</xsl:element>
								</xsl:when>
								<xsl:otherwise>
									<error type="exercise_WOMI_not_OINT" WOMI_id="{$WOMI_id}"/>
									<xsl:element name="{local-name()}">
										<xsl:copy-of select="attribute()[local-name()!='style']"/>
										<xsl:attribute name="style">normal</xsl:attribute>
										<xsl:copy-of select="epconvert:clean_meanings_styles(element())"/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<warn type="style_not_supported_in_this_context">
								<xsl:value-of select="@style"/>
							</warn>
							<xsl:element name="{local-name()}">
								<xsl:copy-of select="attribute()[local-name()!='style']"/>
								<xsl:attribute name="style">normal</xsl:attribute>
								<xsl:copy-of select="epconvert:clean_meanings_styles(element())"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="{local-name()}">
						<xsl:copy-of select="attribute()"/>
						<xsl:copy-of select="epconvert:clean_meanings_styles(element())"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:bubble_bookmarks">
		<xsl:param name="element" as="element()"/>
		<xsl:if test="some $x in ('procedure-instructions','codeblock','list','cite','rule','exercise','definition','concept','quiz','experiment','observation','biography','event') satisfies $x=local-name($element)">
			<xsl:copy-of select="$element/descendant::name/para/bookmark"/>
		</xsl:if>
		<xsl:element name="{name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:for-each select="$element/node()">
				<xsl:choose>
					<xsl:when test="self::element()">
						<xsl:choose>
							<xsl:when test="'bookmark'=local-name(.) and ancestor::name"/>
							<xsl:otherwise>
								<xsl:copy-of select="epconvert:bubble_bookmarks(.)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="self::text()">
						<xsl:value-of select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_sequences_top">
		<xsl:param name="element" as="element()"/>
		<xsl:element name="{local-name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:for-each select="$element/element()">
				<xsl:copy-of select="epconvert:check_meanings_sequences(.)"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_sequences">
		<xsl:param name="elements" as="node()*"/>
		<xsl:choose>
			<xsl:when test="$elements[local-name()='commentStart']">
				<xsl:variable name="commentStart" select="$elements[local-name()='commentStart'][1]"/>
				<xsl:for-each-group select="$elements" group-starting-with="commentStart[@id=$commentStart/@id]">
					<xsl:for-each-group select="current-group()" group-ending-with="commentEnd[@id=$commentStart/@id]">
						<xsl:choose>
							<xsl:when test="generate-id($commentStart)=generate-id(current-group()[1])">
								<xsl:copy-of select="epconvert:check_meanings_sequences_comment_block(current-group())"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="epconvert:check_meanings_sequences(current-group())"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$elements">
					<xsl:choose>
						<xsl:when test="'special_table'=local-name(.)">
							<xsl:copy-of select="."/>
						</xsl:when>
						<xsl:when test="./element()">
							<xsl:element name="{local-name()}">
								<xsl:copy-of select="attribute()"/>
								<xsl:copy-of select="epconvert:check_meanings_sequences(./element())"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_sequences_comment_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="comment" select="$elements[1]"/>
		<xsl:variable name="elements_in_comment" select="$elements[(1 &lt; position()) and (position() &lt; last())]"/>
		<xsl:choose>
			<xsl:when test="$elements_in_comment[local-name()='commentStart']">
				<xsl:variable name="commentStart" select="$elements[local-name()='commentStart'][1]"/>
				<xsl:variable name="group_with_processed_subcomments">
					<xsl:for-each-group select="$elements_in_comment" group-starting-with="commentStart[@id=$commentStart/@id]">
						<xsl:for-each-group select="current-group()" group-ending-with="commentEnd[@id=$commentStart/@id]">
							<xsl:choose>
								<xsl:when test="generate-id($commentStart)=generate-id(current-group()[1])">
									<xsl:copy-of select="epconvert:check_meanings_sequences_comment_block(current-group())"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="epconvert:check_meanings_sequences(current-group())"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each-group>
					</xsl:for-each-group>
				</xsl:variable>
				<xsl:copy-of select="epconvert:check_meanings_sequences_comment_simple_block($group_with_processed_subcomments/element(),$comment)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="epconvert:check_meanings_sequences_comment_simple_block($elements_in_comment, $comment)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_sequences_comment_simple_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:param name="comment" as="element()"/>
		<xsl:variable name="meanings_count" select="count($comment/@*[some $x in ('definition','concept','exercise','command','homework','list','cite','quiz','exercise_WOMI','exercise_set','experiment','observation','biography','event','tooltip','procedure-instructions','code','rule','glossary-declaration','glossary-reference','concept-reference','tooltip-reference','event-reference','biography-reference','bibliography-reference') satisfies local-name()=$x][.='true'])"/>
		<xsl:variable name="nesting_errors">
			<xsl:choose>
				<xsl:when test="1 = $meanings_count">
					<xsl:choose>
						<xsl:when test="not($comment/@glossary-declaration='true')"/>
						<xsl:otherwise>
							<error type="glossary_declaration_orphan"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="2 = $meanings_count">
					<xsl:choose>
						<xsl:when test="$comment/@glossary-declaration='true'">
							<xsl:choose>
								<xsl:when test="$comment/@definition='true' or $comment/@rule='true'"/>
								<xsl:otherwise>
									<error type="comment_to_much_meanings">
										<xsl:for-each select="$comment/attribute()">
											<xsl:if test=".='true'">
												<xsl:copy-of select="."/>
											</xsl:if>
										</xsl:for-each>
									</error>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<error type="comment_to_much_meanings">
								<xsl:for-each select="$comment/attribute()">
									<xsl:if test=".='true'">
										<xsl:copy-of select="."/>
									</xsl:if>
								</xsl:for-each>
							</error>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<error type="comment_to_much_meanings">
						<xsl:for-each select="$comment/attribute()">
							<xsl:if test=".='true'">
								<xsl:copy-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</error>
					<error type="MC_{$meanings_count}">
						<xsl:copy-of select="$comment"/>
					</error>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$nesting_errors/element()">
				<xsl:copy-of select="$nesting_errors"/>
				<xsl:copy-of select="$elements"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$comment/@glossary-reference">
						<xsl:for-each select="$elements">
							<xsl:element name="{local-name()}">
								<xsl:copy-of select="attribute()"/>
								<xsl:copy-of select="element()"/>
								<xsl:element name="comment">
									<xsl:attribute name="id" select="$comment/@id"/>
									<xsl:attribute name="glossary-reference">true</xsl:attribute>
									<xsl:attribute name="value" select="$comment/glossary-reference/text()"/>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="$comment/@homework">
						<xsl:variable name="errors" select="epconvert:check_homework_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements//@position)"/>
								<xsl:variable name="position_end" select="max($elements//@position)"/>
								<xsl:element name="homework">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each select="$elements">
										<xsl:choose>
											<xsl:when test="'WOMI'=local-name()">
												<xsl:variable name="special_table" select="epconvert:process_special_table_attributes(epconvert:select_element_for_processing(@position),0)"/>
												<xsl:variable name="WOMI_id" select="$special_table/element[1]/@id"/>
												<xsl:element name="exercise_WOMI">
													<xsl:attribute name="special_block" select="true()"/>
													<xsl:attribute name="WOMI_id" select="$WOMI_id"/>
													<xsl:copy-of select="@position"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:copy-of select="."/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@tooltip">
						<xsl:variable name="errors" select="epconvert:check_tooltip_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position)"/>
								<xsl:variable name="position_end" select="max($elements/@position)"/>
								<xsl:variable name="local_metadata" select="$elements[local-name()='special_table' and @type='tooltip_metadata']"/>
								<xsl:element name="tooltip">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:if test="$local_metadata">
										<xsl:attribute name="ep:type" select="$local_metadata/attribute[@key='ep:type']"/>
									</xsl:if>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDymek'">
												<xsl:element name="content">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@procedure-instructions">
						<xsl:variable name="errors" select="epconvert:check_procedure-instructions_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position)"/>
								<xsl:variable name="position_end" select="max($elements/@position)"/>
								<xsl:element name="procedure-instructions">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise>
												<xsl:element name="step">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@code">
						<xsl:choose>
							<xsl:when test="not($elements[@style='EPKodakapit'])">
								<xsl:for-each select="$elements">
									<xsl:element name="{local-name()}">
										<xsl:copy-of select="attribute()"/>
										<xsl:copy-of select="element()"/>
										<xsl:element name="comment">
											<xsl:attribute name="id" select="$comment/@id"/>
											<xsl:attribute name="code">true</xsl:attribute>
											<xsl:attribute name="language" select="$comment/code/text()"/>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="errors" select="epconvert:check_code_block($elements)"/>
								<xsl:choose>
									<xsl:when test="$errors">
										<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="position_start" select="min($elements/@position)"/>
										<xsl:variable name="position_end" select="max($elements/@position)"/>
										<xsl:variable name="local_metadata" select="$elements[local-name()='special_table' and @type='code_metadata']"/>
										<xsl:element name="codeblock">
											<xsl:attribute name="special_block" select="true()"/>
											<xsl:attribute name="position_start" select="$position_start"/>
											<xsl:attribute name="position_end" select="$position_end"/>
											<xsl:choose>
												<xsl:when test="$local_metadata">
													<xsl:variable name="language" select="$local_metadata/attribute[@key='language']"/>
													<xsl:variable name="language2" select="$local_metadata/attribute[@key='language2']"/>
													<xsl:choose>
														<xsl:when test="'NONE'=$language">
															<xsl:attribute name="language" select="$language2"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="language" select="$language"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="language" select="$comment/code/text()"/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if test="$elements[@style='EPNazwa']">
												<xsl:element name="name">
													<xsl:copy-of select="$elements[@style='EPNazwa']"/>
												</xsl:element>
											</xsl:if>
											<xsl:element name="content">
												<xsl:copy-of select="$elements[@style='EPKodakapit']"/>
											</xsl:element>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@list">
						<xsl:variable name="errors" select="epconvert:check_list_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="list">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:attribute name="style" select="$elements[local-name()='list']/@style"/>
									<xsl:element name="name">
										<xsl:copy-of select="$elements[@style='EPNazwa']"/>
									</xsl:element>
									<xsl:copy-of select="$elements[local-name()='list']/element()"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@cite">
						<xsl:variable name="errors" select="epconvert:check_cite_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:variable name="local_metadata" select="$elements[local-name()='special_table' and @type='cite_metadata']"/>
								<xsl:variable name="cite_length" select="sum(for $ca in $elements[@style='EPCytatakapit'] return string-length(string-join((epconvert:select_text_for_element($ca),''),'')))"/>
								<xsl:element name="cite">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:if test="$local_metadata">
										<xsl:attribute name="cite_subtype" select="$local_metadata/@subtype"/>
										<xsl:if test="$local_metadata/attribute[@key='type']">
											<xsl:attribute name="type" select="$local_metadata/attribute[@key='type']"/>
										</xsl:if>
										<xsl:if test="$local_metadata/attribute[@key='ep:readability']!='NONE'">
											<xsl:attribute name="ep:readability" select="$local_metadata/attribute[@key='ep:readability']"/>
										</xsl:if>
										<xsl:if test="''!=$local_metadata/attribute[@key='ep:start-numbering']">
											<xsl:attribute name="ep:start-numbering" select="$local_metadata/attribute[@key='ep:start-numbering']"/>
										</xsl:if>
										<xsl:if test="$local_metadata/@subtype='JPOL' and 699 &lt; $cite_length">
											<xsl:attribute name="ep:presentation" select="'fold'"/>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$elements[@style='EPNazwa']">
										<xsl:element name="name">
											<xsl:copy-of select="$elements[@style='EPNazwa']"/>
										</xsl:element>
									</xsl:if>
									<xsl:for-each select="$elements[@style='EPAutor']">
										<xsl:element name="author">
											<xsl:copy-of select="."/>
										</xsl:element>
									</xsl:for-each>
									<xsl:if test="$elements[@style='EPCytatakapit-komentarz']">
										<xsl:element name="comment">
											<xsl:copy-of select="$elements[@style='EPCytatakapit-komentarz']"/>
										</xsl:element>
									</xsl:if>
									<xsl:element name="content">
										<xsl:copy-of select="$elements[@style='EPCytatakapit']"/>
									</xsl:element>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@rule">
						<xsl:variable name="errors" select="epconvert:check_rule_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="rule">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:choose>
										<xsl:when test="0=count($elements[@type='rule_metadata'])">
											<xsl:if test="$comment/rule">
												<xsl:attribute name="type" select="$comment/rule/text()"/>
											</xsl:if>
											<xsl:if test="$comment/@glossary-declaration='true'">
												<xsl:copy-of select="$comment/@glossary-declaration"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="$elements[@type='rule_metadata']/attribute">
												<xsl:attribute name="{@key}" select="text()"/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPRegua-twierdzenie'">
												<xsl:element name="statement">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPRegua-dowd'">
												<xsl:element name="proof">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPPrzykad'">
												<xsl:element name="example">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@exercise">
						<xsl:variable name="errors" select="epconvert:check_exercise_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="exercise">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:if test="1=count($elements[@type='exercise_metadata'])">
										<xsl:variable name="local_metadata" select="$elements[@type='exercise_metadata']"/>
										<xsl:attribute name="exercise_subtype" select="$local_metadata/@subtype"/>
										<xsl:for-each select="$local_metadata/attribute">
											<xsl:attribute name="{@key}" select="text()"/>
										</xsl:for-each>
										<xsl:if test="$local_metadata/element">
											<xsl:attribute name="alternative_WOMI" select="$local_metadata/element/@id"/>
											<xsl:attribute name="exercise_metadata_position" select="$local_metadata/@position"/>
										</xsl:if>
									</xsl:if>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPwiczenie-problem'">
												<xsl:element name="problem">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPNotka-wskazwka'">
												<xsl:element name="tip">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPwiczenie-rozwizanie'">
												<xsl:element name="solution">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPPrzykad'">
												<xsl:element name="example">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPwiczenie-wyjanienie'">
												<xsl:element name="commentary">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@command">
						<xsl:variable name="errors" select="epconvert:check_command_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="command">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()/@style='EPPolecenie'">
												<xsl:element name="problem">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wskazwka','EPNotka-wskazwka') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'tip'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-ostrzeenie','EPNotka-ostrzeenie') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'warning'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wane','EPNotka-wane') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'important'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@definition">
						<xsl:variable name="errors" select="epconvert:check_definition_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="definition">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:choose>
										<xsl:when test="0=count($elements[@type='definition_metadata'])">
											<xsl:if test="$comment/@glossary-declaration='true'">
												<xsl:copy-of select="$comment/@glossary-declaration"/>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="$elements[@type='definition_metadata']/attribute">
												<xsl:attribute name="{@key}" select="text()"/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDefinicja-znaczenie'">
												<xsl:element name="meaning">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPPrzykad'">
												<xsl:element name="example">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@concept">
						<xsl:variable name="errors" select="epconvert:check_definition_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="concept">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each select="$elements[@type='definition_metadata']/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDefinicja-znaczenie'">
												<xsl:element name="meaning">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPPrzykad'">
												<xsl:element name="example">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@quiz">
						<xsl:variable name="errors" select="epconvert:check_quiz_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="quiz">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:choose>
										<xsl:when test="0=count($elements[@type='quiz_metadata' or @type='quiz_metadata_random'])">
											<xsl:attribute name="quiz_type" select="epconvert:determine_quiz_type($elements)/@quiz_type"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="local_metadata" select="$elements[@type='quiz_metadata' or @type='quiz_metadata_random']"/>
											<xsl:attribute name="quiz_subtype" select="$local_metadata/@subtype"/>
											<xsl:for-each select="$local_metadata/attribute[@key!='quiz_type']">
												<xsl:attribute name="{@key}" select="text()"/>
											</xsl:for-each>
											<xsl:attribute name="quiz_type" select="if ($local_metadata/attribute[@key='quiz_type']='auto') then epconvert:determine_quiz_type($elements)/@quiz_type else $local_metadata/attribute[@key='quiz_type']"/>
											<xsl:if test="$local_metadata/element">
												<xsl:attribute name="alternative_WOMI" select="$local_metadata/element/@id"/>
												<xsl:attribute name="quiz_metadata_position" select="$local_metadata/@position"/>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="0=count($elements[@type='quiz_metadata_random'])">
											<xsl:for-each-group select="$elements" group-ending-with="separator">
												<xsl:choose>
													<xsl:when test="current-group()[1]/@style='EPNazwa'">
														<xsl:element name="name">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQPytanie'">
														<xsl:element name="question">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQOdpowied-poprawna'">
														<xsl:element name="answer">
															<xsl:attribute name="correct">true</xsl:attribute>
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQOdpowied-bdna'">
														<xsl:element name="answer">
															<xsl:attribute name="correct">false</xsl:attribute>
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQWskazwka'">
														<xsl:element name="hint">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQWyjanienie'">
														<xsl:element name="feedback">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</xsl:for-each-group>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="local_metadata" select="$elements[@type='quiz_metadata_random']"/>
											<xsl:if test="$elements[@style='EPNazwa']">
												<xsl:element name="name">
													<xsl:copy-of select="$elements[@style='EPNazwa']"/>
												</xsl:element>
											</xsl:if>
											<xsl:for-each-group select="$elements" group-ending-with="separator">
												<xsl:choose>
													<xsl:when test="current-group()/@style='EPQPytanie'">
														<xsl:element name="question">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</xsl:for-each-group>
											<xsl:variable name="temporary_answers" as="element()">
												<temporary_answers>
													<xsl:for-each-group select="$elements" group-ending-with="separator">
														<xsl:choose>
															<xsl:when test="current-group()/@style='EPQOdpowied-poprawna'">
																<xsl:element name="answer">
																	<xsl:attribute name="correct">true</xsl:attribute>
																	<xsl:copy-of select="current-group()[local-name()!='separator']"/>
																</xsl:element>
															</xsl:when>
															<xsl:when test="current-group()/@style='EPQOdpowied-bdna'">
																<xsl:element name="answer">
																	<xsl:attribute name="correct">false</xsl:attribute>
																	<xsl:copy-of select="current-group()[local-name()!='separator']"/>
																</xsl:element>
															</xsl:when>
															<xsl:when test="current-group()/@style='EPQPodpowiedz'">
																<xsl:element name="hint">
																	<xsl:copy-of select="current-group()[local-name()!='separator']"/>
																</xsl:element>
															</xsl:when>
															<xsl:otherwise/>
														</xsl:choose>
													</xsl:for-each-group>
												</temporary_answers>
											</xsl:variable>
											<xsl:variable name="temporary_answers_2" as="element()">
												<temporary_answers_2>
													<xsl:for-each select="$temporary_answers/answer">
														<xsl:element name="answer-group">
															<xsl:copy-of select="@*"/>
															<xsl:copy-of select="."/>
															<xsl:copy-of select="following-sibling::element()[1][local-name()='hint']"/>
														</xsl:element>
													</xsl:for-each>
												</temporary_answers_2>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="ends-with($local_metadata/attribute[@key='ep:behaviour'],'-sets') ">
													<xsl:variable name="number_of_answers" select="count($temporary_answers_2/answer-group)"/>
													<xsl:variable name="number_of_presented_answers" select="$local_metadata/attribute[@key='ep:presented-answers']"/>
													<xsl:for-each select="1 to xs:integer(floor($number_of_answers div $number_of_presented_answers))">
														<xsl:variable name="set" select="."/>
														<xsl:variable name="start" select="xs:integer(($set - 1) * $number_of_presented_answers + 1)"/>
														<xsl:variable name="stop" select="xs:integer($start + $number_of_presented_answers - 1)"/>
														<xsl:element name="answer-set">
															<xsl:attribute name="ep:in-set" select="."/>
															<xsl:copy-of select="$temporary_answers_2/answer-group[some $x in ($start to $stop) satisfies $x=position()]"/>
														</xsl:element>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:copy-of select="$temporary_answers_2/answer-group"/>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:for-each-group select="$elements" group-ending-with="separator">
												<xsl:choose>
													<xsl:when test="current-group()/@style='EPQWskazwka'">
														<xsl:element name="hint">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQWyjanienie'">
														<xsl:element name="feedback">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQKomunkat-odpowiedpoprawna'">
														<xsl:element name="feedback_correct">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:when test="current-group()/@style='EPQKomunikat-odpowiedbdna'">
														<xsl:element name="feedback_incorrect">
															<xsl:copy-of select="current-group()[local-name()!='separator']"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</xsl:for-each-group>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@exercise_WOMI">
						<xsl:variable name="errors" select="epconvert:check_exercise_WOMI_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="exercise_WOMI">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:variable name="local_metadata" select="$elements[@type='quiz_WOMI_with_alternative_metadata']"/>
									<xsl:attribute name="exercise_subtype" select="$local_metadata/@subtype"/>
									<xsl:for-each select="$local_metadata/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:attribute name="WOMI_id" select="$local_metadata/element/@id"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@exercise_set">
						<xsl:variable name="errors" select="epconvert:check_exercise_set_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="exercise_set">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:variable name="local_metadata" select="$elements[@type='quiz_WOMI_set_metadata']"/>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()[1]/@style='EPPolecenie'">
												<xsl:element name="command">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
									<xsl:for-each select="$local_metadata/element">
										<xsl:element name="WOMI_exercise">
											<xsl:attribute name="id" select="@id"/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@experiment">
						<xsl:variable name="errors" select="epconvert:check_experiment_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="experiment">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each select="$elements[@type='experiment_metadata']/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="$elements[@style='EPNazwa']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-problembadawczy'">
												<xsl:element name="problem">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-hipoteza'">
												<xsl:element name="hypothesis">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-cel'">
												<xsl:element name="objective">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-materiayiprzyrzdy'">
												<xsl:element name="instruments">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-instrukcja'">
												<xsl:element name="instructions">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-podsumowanie'">
												<xsl:element name="conclusions">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wskazwka','EPNotka-wskazwka') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'tip'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-ostrzeenie','EPNotka-ostrzeenie') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'warning'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wane','EPNotka-wane') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'important'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@observation">
						<xsl:variable name="errors" select="epconvert:check_observation_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="observation">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:for-each select="$elements[@type='observation_metadata']/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:for-each-group select="$elements" group-ending-with="separator">
										<xsl:choose>
											<xsl:when test="current-group()/@style='EPNazwa'">
												<xsl:element name="name">
													<xsl:copy-of select="$elements[@style='EPNazwa']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-cel'">
												<xsl:element name="objective">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-materiayiprzyrzdy'">
												<xsl:element name="instruments">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-instrukcja'">
												<xsl:element name="instructions">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="current-group()/@style='EPDowiadczenie-podsumowanie'">
												<xsl:element name="conclusions">
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wskazwka','EPNotka-wskazwka') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'tip'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-ostrzeenie','EPNotka-ostrzeenie') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'warning'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:when test="some $x in ('EPNotatka-wane','EPNotka-wane') satisfies current-group()/@style=$x">
												<xsl:element name="note">
													<xsl:attribute name="type" select="'important'"/>
													<xsl:copy-of select="current-group()[local-name()!='separator']"/>
												</xsl:element>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each-group>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@biography">
						<xsl:variable name="errors" select="epconvert:check_biography_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="biography">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:variable name="local_metadata" select="$elements[@type='biography_metadata'][1]"/>
									<xsl:for-each select="$local_metadata/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:if test="$local_metadata/element">
										<xsl:attribute name="biography_metadata_position" select="$local_metadata/@position"/>
									</xsl:if>
									<xsl:element name="special_table">
										<xsl:copy-of select="$local_metadata/element"/>
										<xsl:if test="'lack'!=$local_metadata/attribute[@key='ep:birth_date_type'] or ''!=$local_metadata/attribute[@key='ep:birth_place']">
											<xsl:variable name="birth_date_type" select="$local_metadata/attribute[@key='ep:birth_date_type']"/>
											<xsl:variable name="birth_date_value" select="$local_metadata/attribute[@key='ep:birth_date_value']"/>
											<xsl:variable name="birth_date_bc" select="'BC'=$local_metadata/attribute[@key='ep:birth_date_era']"/>
											<xsl:element name="birth">
												<xsl:choose>
													<xsl:when test="'exact'=$birth_date_type">
														<xsl:analyze-string select="$birth_date_value" regex="^(\d+)/(\d+)/(\d+)$">
															<xsl:matching-substring>
																<xsl:element name="date">
																	<xsl:element name="start">
																		<xsl:element name="year">
																			<xsl:value-of select="if(not($birth_date_bc)) then regex-group(3) else -1 * number(regex-group(3))"/>
																		</xsl:element>
																		<xsl:element name="month">
																			<xsl:value-of select="regex-group(2)"/>
																		</xsl:element>
																		<xsl:element name="day">
																			<xsl:value-of select="regex-group(1)"/>
																		</xsl:element>
																	</xsl:element>
																</xsl:element>
															</xsl:matching-substring>
														</xsl:analyze-string>
													</xsl:when>
													<xsl:when test="some $x in ('year','around-year') satisfies $x=$birth_date_type">
														<xsl:element name="date">
															<xsl:element name="start">
																<xsl:element name="year">
																	<xsl:value-of select="if(not($birth_date_bc)) then $birth_date_value else -1 * number($birth_date_value)"/>
																</xsl:element>
															</xsl:element>
														</xsl:element>
													</xsl:when>
													<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$birth_date_type">
														<xsl:element name="date">
															<xsl:copy-of select="epconvert:century_to_year($birth_date_value, $birth_date_bc)"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
												<xsl:if test="''!=$local_metadata/attribute[@key='ep:birth_place']">
													<xsl:element name="location">
														<xsl:value-of select="$local_metadata/attribute[@key='ep:birth_place']"/>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:if>
										<xsl:if test="'lack'!=$local_metadata/attribute[@key='ep:death_date_type'] or ''!=$local_metadata/attribute[@key='ep:death_place']">
											<xsl:variable name="death_date_type" select="$local_metadata/attribute[@key='ep:death_date_type']"/>
											<xsl:variable name="death_date_value" select="$local_metadata/attribute[@key='ep:death_date_value']"/>
											<xsl:variable name="death_date_bc" select="'BC'=$local_metadata/attribute[@key='ep:death_date_era']"/>
											<xsl:element name="death">
												<xsl:choose>
													<xsl:when test="'exact'=$death_date_type">
														<xsl:analyze-string select="$death_date_value" regex="^(\d+)/(\d+)/(\d+)$">
															<xsl:matching-substring>
																<xsl:element name="date">
																	<xsl:element name="start">
																		<xsl:element name="year">
																			<xsl:value-of select="if(not($death_date_bc)) then regex-group(3) else -1 * number(regex-group(3))"/>
																		</xsl:element>
																		<xsl:element name="month">
																			<xsl:value-of select="regex-group(2)"/>
																		</xsl:element>
																		<xsl:element name="day">
																			<xsl:value-of select="regex-group(1)"/>
																		</xsl:element>
																	</xsl:element>
																</xsl:element>
															</xsl:matching-substring>
														</xsl:analyze-string>
													</xsl:when>
													<xsl:when test="some $x in ('year','around-year') satisfies $x=$death_date_type">
														<xsl:element name="date">
															<xsl:element name="start">
																<xsl:element name="year">
																	<xsl:value-of select="if(not($death_date_bc)) then $death_date_value else -1 * number($death_date_value)"/>
																</xsl:element>
															</xsl:element>
														</xsl:element>
													</xsl:when>
													<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$death_date_type">
														<xsl:element name="date">
															<xsl:copy-of select="epconvert:century_to_year($death_date_value, $death_date_bc)"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
												<xsl:if test="''!=$local_metadata/attribute[@key='ep:death_place']">
													<xsl:element name="location">
														<xsl:value-of select="$local_metadata/attribute[@key='ep:death_place']"/>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<xsl:element name="name">
										<xsl:copy-of select="$elements[@style='EPNazwa']"/>
									</xsl:element>
									<xsl:element name="content">
										<xsl:copy-of select="$elements[@style='EPOpis']"/>
									</xsl:element>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$comment/@event">
						<xsl:variable name="errors" select="epconvert:check_event_block($elements)"/>
						<xsl:choose>
							<xsl:when test="$errors">
								<xsl:copy-of select="epconvert:process_block_as_error($errors,$elements)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="position_start" select="min($elements/@position | $elements/@position_start)"/>
								<xsl:variable name="position_end" select="max($elements/@position | $elements/@position_end)"/>
								<xsl:element name="event">
									<xsl:attribute name="special_block" select="true()"/>
									<xsl:attribute name="position_start" select="$position_start"/>
									<xsl:attribute name="position_end" select="$position_end"/>
									<xsl:variable name="local_metadata" select="$elements[@type='event_metadata'][1]"/>
									<xsl:for-each select="$local_metadata/attribute">
										<xsl:attribute name="{@key}" select="text()"/>
									</xsl:for-each>
									<xsl:if test="$local_metadata/element">
										<xsl:attribute name="event_metadata_position" select="$local_metadata/@position"/>
									</xsl:if>
									<xsl:element name="special_table">
										<xsl:copy-of select="$local_metadata/element"/>
										<xsl:if test="'lack'!=$local_metadata/attribute[@key='ep:start_date_type'] or ''!=$local_metadata/attribute[@key='ep:start_place']">
											<xsl:variable name="start_date_type" select="$local_metadata/attribute[@key='ep:start_date_type']"/>
											<xsl:variable name="start_date_value" select="$local_metadata/attribute[@key='ep:start_date_value']"/>
											<xsl:variable name="start_date_bc" select="'BC'=$local_metadata/attribute[@key='ep:start_date_era']"/>
											<xsl:element name="start">
												<xsl:choose>
													<xsl:when test="'exact'=$start_date_type">
														<xsl:analyze-string select="$start_date_value" regex="^(\d+)/(\d+)/(\d+)$">
															<xsl:matching-substring>
																<xsl:element name="date">
																	<xsl:element name="start">
																		<xsl:element name="year">
																			<xsl:value-of select="if(not($start_date_bc)) then regex-group(3) else -1 * number(regex-group(3))"/>
																		</xsl:element>
																		<xsl:element name="month">
																			<xsl:value-of select="regex-group(2)"/>
																		</xsl:element>
																		<xsl:element name="day">
																			<xsl:value-of select="regex-group(1)"/>
																		</xsl:element>
																	</xsl:element>
																</xsl:element>
															</xsl:matching-substring>
														</xsl:analyze-string>
													</xsl:when>
													<xsl:when test="some $x in ('year','around-year') satisfies $x=$start_date_type">
														<xsl:element name="date">
															<xsl:element name="start">
																<xsl:element name="year">
																	<xsl:value-of select="if(not($start_date_bc)) then $start_date_value else -1 * number($start_date_value)"/>
																</xsl:element>
															</xsl:element>
														</xsl:element>
													</xsl:when>
													<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$start_date_type">
														<xsl:element name="date">
															<xsl:copy-of select="epconvert:century_to_year($start_date_value, $start_date_bc)"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
												<xsl:if test="''!=$local_metadata/attribute[@key='ep:start_place']">
													<xsl:element name="location">
														<xsl:value-of select="$local_metadata/attribute[@key='ep:start_place']"/>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:if>
										<xsl:if test="'lack'!=$local_metadata/attribute[@key='ep:end_date_type'] or ''!=$local_metadata/attribute[@key='ep:end_place']">
											<xsl:variable name="end_date_type" select="$local_metadata/attribute[@key='ep:end_date_type']"/>
											<xsl:variable name="end_date_value" select="$local_metadata/attribute[@key='ep:end_date_value']"/>
											<xsl:variable name="end_date_bc" select="'BC'=$local_metadata/attribute[@key='ep:end_date_era']"/>
											<xsl:element name="end">
												<xsl:choose>
													<xsl:when test="'exact'=$end_date_type">
														<xsl:analyze-string select="$end_date_value" regex="^(\d+)/(\d+)/(\d+)$">
															<xsl:matching-substring>
																<xsl:element name="date">
																	<xsl:element name="start">
																		<xsl:element name="year">
																			<xsl:value-of select="if(not($end_date_bc)) then regex-group(3) else -1 * number(regex-group(3))"/>
																		</xsl:element>
																		<xsl:element name="month">
																			<xsl:value-of select="regex-group(2)"/>
																		</xsl:element>
																		<xsl:element name="day">
																			<xsl:value-of select="regex-group(1)"/>
																		</xsl:element>
																	</xsl:element>
																</xsl:element>
															</xsl:matching-substring>
														</xsl:analyze-string>
													</xsl:when>
													<xsl:when test="some $x in ('year','around-year') satisfies $x=$end_date_type">
														<xsl:element name="date">
															<xsl:element name="start">
																<xsl:element name="year">
																	<xsl:value-of select="if(not($end_date_bc)) then $end_date_value else -1 * number($end_date_value)"/>
																</xsl:element>
															</xsl:element>
														</xsl:element>
													</xsl:when>
													<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$end_date_type">
														<xsl:element name="date">
															<xsl:copy-of select="epconvert:century_to_year($end_date_value, $end_date_bc)"/>
														</xsl:element>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
												<xsl:if test="''!=$local_metadata/attribute[@key='ep:end_place']">
													<xsl:element name="location">
														<xsl:value-of select="$local_metadata/attribute[@key='ep:end_place']"/>
													</xsl:element>
												</xsl:if>
											</xsl:element>
										</xsl:if>
									</xsl:element>
									<xsl:element name="name">
										<xsl:copy-of select="$elements[@style='EPNazwa']"/>
									</xsl:element>
									<xsl:element name="content">
										<xsl:copy-of select="$elements[@style='EPOpis']"/>
									</xsl:element>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<error type="processing_meaning_error"/>
						<xsl:copy-of select="$elements"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:process_block_as_error">
		<xsl:param name="errors" as="node()*"/>
		<xsl:param name="elements" as="node()*"/>
		<xsl:for-each select="$errors">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="$elements[not(local-name()='special_table')]">
			<xsl:element name="{local-name()}">
				<xsl:copy-of select="attribute()[not(local-name()='style')]"/>
				<xsl:if test="attribute()[local-name()='style']">
					<xsl:attribute name="style">normal</xsl:attribute>
				</xsl:if>
				<xsl:copy-of select="element()"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:check_homework_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:choose>
			<xsl:when test="not(every $x in $elements/local-name() satisfies $x=('separator','exercise','exercise_WOMI','command','observation','experiment','quiz','WOMI'))">
				<error type="homework_disallowed_elements">
					<xsl:for-each select="$elements[not(some $x in ('separator','exercise','exercise_WOMI','command','observation','experiment','quiz','WOMI','error','warn') satisfies $x=local-name(.))]">
						<block name="{local-name()}"/>
					</xsl:for-each>
				</error>
			</xsl:when>
			<xsl:when test="$elements['WOMI'=local-name() and not('EPZadanie'=@style)]">
				<error type="homework_disallowed_elements">
					<block name="WOMI"/>
				</error>
			</xsl:when>
		</xsl:choose>
		<xsl:for-each select="$elements['WOMI'=local-name() and 'EPZadanie'=@style]">
			<xsl:variable name="special_table" select="epconvert:process_special_table_attributes(epconvert:select_element_for_processing(@position),0)"/>
			<xsl:variable name="WOMI_id" select="$special_table/element[1]/@id"/>
			<xsl:variable name="WOMI_type" select="$special_table/element[1]/attribute[@key='ep:id']/@group_2"/>
			<xsl:if test="'OINT'!=$WOMI_type">
				<error type="homework_exercise_WOMI_not_OINT" WOMI_id="{$WOMI_id}"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:check_tooltip_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="$elements[@type='tooltip_metadata']">
			<xsl:if test="1 &lt; count($elements[@type='tooltip_metadata'])">
				<error type="tooltip_local_metadata_duplicate"/>
			</xsl:if>
			<xsl:copy-of select="$elements[@type='tooltip_metadata'][1]/error"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="tooltip_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="tooltip_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDymek'])">
			<error type="tooltip_content_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDymek'][following-sibling::separator[following-sibling::element()[@style='EPDymek']]]">
			<error type="tooltip_content_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='tooltip_metadata') and not(some $x in ('EPNazwa','EPDymek') satisfies @style=$x)]">
			<error type="tooltip_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='tooltip_metadata') and not(some $x in ('EPNazwa','EPDymek') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[@style='EPDymek']]">
			<warn type="tooltip_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_procedure-instructions_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="procedure-instructions_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="procedure-instructions_name_duplicate"/>
		</xsl:if>
		<xsl:if test="0 = count($elements[@style='EPKrok'])">
			<error type="procedure-instructions_step_missing"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(some $x in ('EPNazwa','EPKrok') satisfies @style=$x)]">
			<error type="procedure-instructions_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(some $x in ('EPNazwa','EPKrok') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[@style='EPKrok']]">
			<warn type="procedure-instructions_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_code_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="code_name_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[@type='code_metadata']">
			<xsl:if test="1 &lt; count($elements[@type='code_metadata'])">
				<error type="code_local_metadata_duplicate"/>
			</xsl:if>
			<xsl:variable name="local_metadata" select="$elements[@type='code_metadata'][1]"/>
			<xsl:variable name="language" select="$local_metadata/attribute[@key='language']/text()"/>
			<xsl:variable name="language2" select="$local_metadata/attribute[@key='language2']/text()"/>
			<xsl:choose>
				<xsl:when test="$language='NONE'">
					<xsl:if test="not($language2)">
						<error type="code_language_not_from_list_option_selected_but_language2_empty"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$language2">
						<error type="code_language_from_list_option_selected_but_language2_not_empty"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:copy-of select="$local_metadata/error"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='code_metadata') and not(some $x in ('EPNazwa','EPKodakapit') satisfies @style=$x)]">
			<error type="code_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='code_metadata') and not(some $x in ('EPNazwa','EPKodakapit') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[@style='EPKodakapit']]">
			<warn type="code_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_list_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<warn type="list_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="list_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[local-name()='list'])">
			<error type="list_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[local-name()='list'])">
			<error type="list_duplicate">
				<xsl:value-of select="count($elements[local-name()='list'])"/>
			</error>
		</xsl:if>
		<xsl:if test="$elements[not(some $x in ('separator','list') satisfies local-name()=$x) and not(@style='EPNazwa')]">
			<error type="list_disallowed_elements">
				<xsl:copy-of select="$elements[not(some $x in ('separator','list') satisfies local-name()=$x) and not(@style='EPNazwa')]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::list]">
			<warn type="list_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_cite_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="$elements[@type='cite_metadata']">
			<xsl:if test="1 &lt; count($elements[@type='cite_metadata'])">
				<error type="cite_local_metadata_duplicate"/>
			</xsl:if>
			<xsl:variable name="local_metadata" select="$elements[@type='cite_metadata'][1]"/>
			<xsl:variable name="cite_length" select="sum(for $ca in $elements[@style='EPCytatakapit'] return string-length(string-join((epconvert:select_text_for_element($ca),''),'')))"/>
			<xsl:if test="$local_metadata/attribute[@key='ep:readability']!='NONE'">
				<xsl:if test="$cite_length &lt; 700">
					<error type="cite_readability_set_while_length_less_than_700">
						<xsl:value-of select="$cite_length"/>
					</error>
				</xsl:if>
				<xsl:if test="some $x in ('poetry','historical-poetry') satisfies $x=$local_metadata/attribute[@key='type']">
					<error type="cite_readability_set_while_poetry_type"/>
				</xsl:if>
			</xsl:if>
			<xsl:copy-of select="$local_metadata/error"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="cite_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[some $x in ('EPNazwa','EPAutor') satisfies @style=$x])">
			<warn type="cite_name_or_author_missing"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPCytatakapit'])">
			<error type="cite_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPCytatakapit'][following-sibling::separator[following-sibling::element()[@style='EPCytatakapit']]]">
			<error type="cite_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPCytatakapit-komentarz'][following-sibling::separator[following-sibling::element()[@style='EPCytatakapit-komentarz']]]">
			<error type="cite_comment_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='cite_metadata') and not(some $x in ('EPNazwa','EPAutor','EPCytatakapit','EPCytatakapit-komentarz') satisfies @style=$x)]">
			<error type="cite_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='cite_metadata') and not(some $x in ('EPNazwa','EPAutor','EPCytatakapit','EPCytatakapit-komentarz') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPAutor','EPCytatakapit','EPCytatakapit-komentarz') satisfies @style=$x]] or $teb/TEB/element()[@style='EPAutor'][preceding-sibling::element()[some $x in ('EPCytatakapit','EPCytatakapit-komentarz') satisfies @style=$x]] or $teb/TEB/element()[@style='EPCytatakapit'][preceding-sibling::element()[@style='EPCytatakapit-komentarz']]">
			<warn type="cite_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_rule_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="1 &lt; count($elements[@type='rule_metadata'])">
			<error type="rule_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='rule_metadata']/error"/>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="rule_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="rule_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPRegua-twierdzenie'])">
			<error type="rule_missing"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='rule_metadata') and not(some $x in ('EPNazwa','EPRegua-twierdzenie','EPRegua-dowd','EPPrzykad') satisfies @style=$x)]">
			<error type="rule_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='rule_metadata') and not(some $x in ('EPNazwa','EPRegua-twierdzenie','EPRegua-dowd','EPPrzykad') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPRegua-twierdzenie','EPRegua-dowd','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPRegua-twierdzenie'][preceding-sibling::element()[some $x in ('EPRegua-dowd','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPRegua-dowd'][preceding-sibling::element()[@style='EPPrzykad']]">
			<warn type="rule_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_exercise_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="$elements[@type='exercise_metadata']">
			<xsl:if test="1 &lt; count($elements[@type='exercise_metadata'])">
				<error type="exercise_local_metadata_duplicate"/>
			</xsl:if>
			<xsl:variable name="local_metadata" select="$elements[@type='exercise_metadata'][1]"/>
			<xsl:if test="0 &lt; count($local_metadata/element)">
				<xsl:if test="1 &lt; count($local_metadata/element)">
					<error type="exercise_alternative_WOMI_duplicate"/>
				</xsl:if>
				<xsl:if test="$local_metadata/attribute[@key='ep:interactivity']!='static'">
					<error type="exercise_with_alternative_WOMI_but_type_is_not_static"/>
				</xsl:if>
				<xsl:if test="0 &lt; $local_metadata/element/attribute[@name='WOMI_REFERENCE' and @group_2!='OINT']">
					<error type="exercise_with_alternative_WOMI_but_not_OINT"/>
				</xsl:if>
			</xsl:if>
			<xsl:copy-of select="$local_metadata/error"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="exercise_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPwiczenie-problem'])">
			<error type="exercise_problem_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPwiczenie-problem' and following-sibling::separator[following-sibling::element()[@style='EPwiczenie-problem']]]">
			<error type="exercise_problem_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNotka-wskazwka' and following-sibling::separator[following-sibling::element()[@style='EPNotka-wskazwka']]]">
			<error type="exercise_tip_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPwiczenie-wyjanienie' and following-sibling::separator[following-sibling::element()[@style='EPwiczenie-wyjanienie']]]">
			<error type="exercise_commentary_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='exercise_metadata') and not(some $x in ('EPNazwa','EPwiczenie-problem','EPNotka-wskazwka','EPwiczenie-rozwizanie','EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x)]">
			<error type="exercise_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='exercise_metadata') and not(some $x in ('EPNazwa','EPwiczenie-problem','EPNotka-wskazwka','EPwiczenie-rozwizanie','EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPwiczenie-problem','EPNotka-wskazwka','EPwiczenie-rozwizanie','EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPwiczenie-problem'][preceding-sibling::element()[some $x in ('EPNotka-wskazwka','EPwiczenie-rozwizanie','EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPNotka-wskazwka'][preceding-sibling::element()[some $x in ('EPwiczenie-rozwizanie','EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPwiczenie-rozwizanie'][preceding-sibling::element()[some $x in ('EPwiczenie-wyjanienie','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPwiczenie-wyjanienie'][preceding-sibling::element()[@style='EPPrzykad']]">
			<warn type="exercise_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_command_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@style='EPPolecenie'])">
			<error type="command_problem_missing"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(some $x in ('EPPolecenie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]">
			<error type="command_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(some $x in ('EPPolecenie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_definition_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="1 &lt; count($elements[@type='definition_metadata'])">
			<error type="definition_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='definition_metadata']/error"/>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="definition_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="definition_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDefinicja-znaczenie'])">
			<error type="definition_meaning_missing"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='definition_metadata') and not(some $x in ('EPNazwa','EPDefinicja-znaczenie','EPPrzykad') satisfies @style=$x)]">
			<error type="definition_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='definition_metadata') and not(some $x in ('EPNazwa','EPDefinicja-znaczenie','EPPrzykad') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPDefinicja-znaczenie','EPPrzykad') satisfies @style=$x]] or $teb/TEB/element()[@style='EPPrzykad'][not(preceding-sibling::element()[@style='EPDefinicja-znaczenie'])]">
			<warn type="definition_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_quiz_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="$elements[some $x in ('quiz_metadata','quiz_metadata_random') satisfies @type=$x]">
			<xsl:if test="1 &lt; count($elements[some $x in ('quiz_metadata','quiz_metadata_random') satisfies @type=$x])">
				<error type="quiz_local_metadata_duplicate"/>
			</xsl:if>
			<xsl:variable name="local_metadata" select="$elements[some $x in ('quiz_metadata','quiz_metadata_random') satisfies @type=$x][1]"/>
			<xsl:if test="0 &lt; count($local_metadata/element)">
				<xsl:if test="1 &lt; count($local_metadata/element)">
					<error type="quiz_alternative_WOMI_duplicate"/>
				</xsl:if>
				<xsl:if test="0 &lt; $local_metadata/element/attribute[@name='WOMI_REFERENCE' and @group_2!='OINT']">
					<error type="quiz_with_alternative_WOMI_but_not_OINT"/>
				</xsl:if>
			</xsl:if>
			<xsl:copy-of select="$local_metadata/error"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="quiz_name_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPQPytanie'])">
			<error type="quiz_question_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPQPytanie' and following-sibling::separator[following-sibling::element()[@style='EPQPytanie']]]">
			<error type="quiz_question_duplicate"/>
		</xsl:if>
		<xsl:if test="not($teb/TEB/element()[starts-with(@style,'EPQOdpowied-') and following-sibling::separator[following-sibling::element()[starts-with(@style,'EPQOdpowied-')]]])">
			<error type="quiz_insufficient_answers_count"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPQWyjanienie' and following-sibling::separator[following-sibling::element()[@style='EPQWyjanienie']]]">
			<error type="quiz_feedback_duplicate"/>
		</xsl:if>
		<xsl:variable name="local_metadata" select="$elements[some $x in ('quiz_metadata','quiz_metadata_random') satisfies @type=$x][1]"/>
		<xsl:variable name="local_metadata_type" select="$local_metadata/@type"/>
		<xsl:choose>
			<xsl:when test="$local_metadata_type='quiz_metadata'">
				<xsl:variable name="local_metadata" select="$elements[@type='quiz_metadata'][1]"/>
				<xsl:variable name="quiz_type" select="$local_metadata/attribute[@key='quiz_type']"/>
				<xsl:choose>
					<xsl:when test="$quiz_type='auto'">
						<xsl:if test="not($elements[@style='EPQOdpowied-poprawna'])">
							<error type="quiz_correct_answer_missing"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$quiz_type='single-response'">
						<xsl:if test="not($elements[@style='EPQOdpowied-poprawna'])">
							<error type="quiz_correct_answer_missing"/>
						</xsl:if>
						<xsl:if test="$teb/TEB/element()[@style='EPQOdpowied-poprawna' and following-sibling::separator[following-sibling::element()[@style='EPQOdpowied-poprawna']]]">
							<error type="quiz_single_response_with_more_than_one_answer"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$quiz_type='ordered-response'">
						<xsl:if test="$elements[@style='EPQOdpowied-bdna']">
							<error type="quiz_ordered_response_with_incorrect_answer"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$local_metadata_type='quiz_metadata_random'">
				<xsl:variable name="quiz_variant" select="$local_metadata/attribute[@key='quiz_variant']"/>
				<xsl:variable name="groupped_TEB" as="element()">
					<groupped_TEB>
						<xsl:for-each-group select="$teb/TEB/element()" group-ending-with="separator">
							<xsl:if test="current-group()[1][some $x in ('EPQPodpowiedz','EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies @style=$x]">
								<group style="{current-group()[1]/@style}"/>
							</xsl:if>
						</xsl:for-each-group>
					</groupped_TEB>
				</xsl:variable>
				<xsl:variable name="number_of_answers" select="count($groupped_TEB/element()[some $x in ('EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies $x=@style])"/>
				<xsl:variable name="number_of_correct_answers" select="count($groupped_TEB/element()['EPQOdpowied-poprawna'=@style])"/>
				<xsl:variable name="number_of_presented_answers" select="number($local_metadata/attribute[@key='ep:presented-answers'])"/>
				<xsl:variable name="number_of_correct_min" select="number($local_metadata/attribute[@key='ep:correct-in-set-min'])"/>
				<xsl:variable name="number_of_correct_max" select="number($local_metadata/attribute[@key='ep:correct-in-set-max'])"/>
				<xsl:variable name="behaviour" select="$local_metadata/attribute[@key='ep:behaviour']"/>
				<xsl:if test="$number_of_answers &lt; $number_of_presented_answers">
					<error type="quiz_number_answers_less_than_number_of_presented_answers" presented_answers="{$number_of_presented_answers}" answers="{$number_of_answers}"/>
				</xsl:if>
				<xsl:if test="'ZJ-1'!=$quiz_variant">
					<xsl:if test="$elements[@style='EPQPodpowiedz']">
						<error type="quiz_answer_hint_allowed_only_for_single_response"/>
					</xsl:if>
					<xsl:if test="'randomize'=$behaviour">
						<xsl:if test="$number_of_correct_max &lt; $number_of_correct_min">
							<error type="quiz_number_of_correct_answers_min_greater_than_max" correct_answers_max="{$number_of_correct_max}" correct_answers_min="{$number_of_correct_min}"/>
						</xsl:if>
						<xsl:if test="$number_of_presented_answers &lt; $number_of_correct_max">
							<error type="quiz_number_of_correct_answers_max_greater_than_presented_answers" correct_answers_max="{$number_of_correct_max}" presented_answers="{$number_of_presented_answers}"/>
						</xsl:if>
						<xsl:if test="$number_of_correct_answers &lt; $number_of_correct_max">
							<error type="quiz_number_of_correct_answers_max_less_than_number_of_all_correct_answers" correct_answers_max="{$number_of_correct_max}" correct_answers="{$number_of_correct_answers}"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test="'ZJ-1'=$quiz_variant">
					<xsl:for-each select="$groupped_TEB/element()">
						<xsl:if test="@style='EPQPodpowiedz' and preceding-sibling::element()[1]/@style!='EPQOdpowied-bdna'">
							<xsl:choose>
								<xsl:when test="preceding-sibling::element()[1]/@style='EPQPodpowiedz'">
									<error type="quiz_wrong_order_hint_after_hint" answer="{count(preceding-sibling::element()[some $x in ('EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies @style=$x])}"/>
								</xsl:when>
								<xsl:otherwise>
									<error type="quiz_wrong_order_hint_not_after_wrong_answer" answer="{count(preceding-sibling::element()[some $x in ('EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies @style=$x])}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="ends-with($behaviour,'-sets')">
						<xsl:if test="$number_of_answers mod $number_of_presented_answers">
							<error type="quiz_non_zero_number_of_answers_mod_number_of_presented_answers_while_sets" answers="{$number_of_answers}" presented_answers="{$number_of_presented_answers}"/>
						</xsl:if>
						<xsl:if test="'ZJ-1'=$quiz_variant">
							<xsl:for-each select="1 to xs:integer(floor($number_of_answers div $number_of_presented_answers))">
								<xsl:variable name="set" select="."/>
								<xsl:variable name="start" select="xs:integer(($set - 1) * $number_of_presented_answers + 1)"/>
								<xsl:variable name="stop" select="xs:integer($start + $number_of_presented_answers - 1)"/>
								<xsl:variable name="number_of_correct_in_set" select="count($groupped_TEB/element()[some $x in ('EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies $x=@style][some $x in ($start to $stop) satisfies $x=position()][@style='EPQOdpowied-poprawna'])"/>
								<xsl:if test="1!=$number_of_correct_in_set">
									<error type="quiz_number_of_correct_answers_in_single_response_not_1_while_sets" set="{$set}" start="{$start}" stop="{$stop}" count="{$number_of_correct_in_set}"/>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="'ZJ-1'=$quiz_variant">
							<xsl:variable name="number_of_correct_in_set" select="count($groupped_TEB/element()[some $x in ('EPQOdpowied-bdna','EPQOdpowied-poprawna') satisfies $x=@style][position() &lt;= $number_of_presented_answers][@style='EPQOdpowied-poprawna'])"/>
							<xsl:if test="1!=$number_of_correct_in_set">
								<error type="quiz_number_of_correct_answers_in_single_response_set_1_not_1_while_randomize" presented_answers="{$number_of_presented_answers}" count="{$number_of_correct_in_set}"/>
							</xsl:if>
						</xsl:if>
						<xsl:variable name="number_of_incorrect_answers" select="$number_of_answers - $number_of_correct_answers"/>
						<xsl:variable name="number_of_needed_incorrect_answers" select="if('ZJ-1'=$quiz_variant) then $number_of_presented_answers - 1 else $number_of_presented_answers - $number_of_correct_min"/>
						<xsl:if test=" $number_of_incorrect_answers &lt; $number_of_needed_incorrect_answers">
							<error type="quiz_number_of_incorrect_answers_is_to_low" needed_incorrect_answers="{$number_of_needed_incorrect_answers}" incorrect_answers="{$number_of_incorrect_answers}"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not($elements[@style='EPQOdpowied-poprawna'])">
					<error type="quiz_correct_answer_missing"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$local_metadata_type='quiz_metadata_random'">
				<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_metadata_random') and not(some $x in ('EPNazwa','EPQOdpowied-bdna','EPQOdpowied-poprawna','EPQPytanie','EPQWskazwka','EPQWyjanienie','EPQPodpowiedz','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x)]">
					<error type="quiz_disallowed_elements">
						<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_metadata_random') and not(some $x in ('EPNazwa','EPQOdpowied-bdna','EPQOdpowied-poprawna','EPQPytanie','EPQWskazwka','EPQWyjanienie','EPQPodpowiedz','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x)]"/>
					</error>
				</xsl:if>
				<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPQPytanie','EPQOdpowied-poprawna','EPQOdpowied-bdna','EPQPodpowiedz','EPQWskazwka','EPQWyjanienie','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x]] or $teb/TEB/element()[@style='EPQPodpowiedz'][not(preceding-sibling::element()[some $x in ('EPQOdpowied-poprawna','EPQOdpowied-bdna') satisfies @style=$x])] or  $teb/TEB/element()[@style='EPQPytanie'][preceding-sibling::element()[some $x in ('EPQOdpowied-poprawna','EPQOdpowied-bdna','EPQPodpowiedz','EPQWskazwka','EPQWyjanienie','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x]] or 
		$teb/TEB/element()[starts-with(@style,'EPQOdpowied-')][preceding-sibling::element()[some $x in ('EPQWskazwka','EPQWyjanienie','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x]] or $teb/TEB/element()[@style='EPQWskazwka'][preceding-sibling::element()[some $x in ('EPQWyjanienie','EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x]] or $teb/TEB/element()[@style='EPQWyjanienie'][preceding-sibling::element()[some $x in ('EPQKomunikat-odpowiedbdna','EPQKomunkat-odpowiedpoprawna') satisfies @style=$x]]">
					<warn type="quiz_wrong_order_random"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_metadata') and not(some $x in ('EPNazwa','EPQOdpowied-bdna','EPQOdpowied-poprawna','EPQPytanie','EPQWskazwka','EPQWyjanienie') satisfies @style=$x)]">
					<error type="quiz_disallowed_elements">
						<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_metadata') and not(some $x in ('EPNazwa','EPQOdpowied-bdna','EPQOdpowied-poprawna','EPQPytanie','EPQWskazwka','EPQWyjanienie') satisfies @style=$x)]"/>
					</error>
				</xsl:if>
				<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPQPytanie','EPQOdpowied-poprawna','EPQOdpowied-bdna','EPQWskazwka','EPQWyjanienie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPQPytanie'][preceding-sibling::element()[some $x in ('EPQOdpowied-poprawna','EPQOdpowied-bdna','EPQWskazwka','EPQWyjanienie') satisfies @style=$x]] or 
		$teb/TEB/element()[starts-with(@style,'EPQOdpowied-')][preceding-sibling::element()[some $x in ('EPQWskazwka','EPQWyjanienie') satisfies @style=$x]] or 
		$teb/TEB/element()[@style='EPQWskazwka'][preceding-sibling::element()[@style='EPQWyjanienie']]">
					<warn type="quiz_wrong_order"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_exercise_WOMI_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:choose>
			<xsl:when test="not($elements['quiz_WOMI_with_alternative_metadata'=@type])">
				<error type="exercise_WOMI_local_metadata_missing"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="local_metadata" select="$elements['quiz_WOMI_with_alternative_metadata'=@type][1]"/>
				<xsl:if test="1 &lt; count($elements['quiz_WOMI_with_alternative_metadata'=@type])">
					<error type="exercise_WOMI_local_metadata_duplicate"/>
				</xsl:if>
				<xsl:if test="not($local_metadata/element)">
					<error type="exercise_WOMI_WOMI_missing"/>
				</xsl:if>
				<xsl:if test="1 &lt; count($local_metadata/element)">
					<error type="exercise_WOMI_WOMI_duplicate"/>
				</xsl:if>
				<xsl:if test="0 &lt; $local_metadata/element/attribute[@name='WOMI_REFERENCE' and @group_2!='OINT']">
					<error type="exercise_WOMI_WOMI_not_OINT" WOMI_id="{$local_metadata/element/attribute[@name='WOMI_REFERENCE' and @group_2!='OINT'][1]/@id}"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='quiz_WOMI_with_alternative_metadata')]">
			<error type="exercise_WOMI_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='special_table' and @type='quiz_WOMI_with_alternative_metadata')]"/>
			</error>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_exercise_set_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@style='EPPolecenie'])">
			<error type="exercise_WOMI_set_command_missing"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not($elements[@type='quiz_WOMI_set_metadata'])">
				<error type="exercise_WOMI_set_metadata_missing"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="local_metadata" select="$elements['quiz_WOMI_set_metadata'=@type][1]"/>
				<xsl:if test="1 &lt; count($elements['quiz_WOMI_set_metadata'=@type])">
					<error type="exercise_WOMI_set_metadata_duplicate"/>
				</xsl:if>
				<xsl:if test="not($local_metadata/element)">
					<error type="exercise_WOMI_set_WOMI_missing"/>
				</xsl:if>
				<xsl:for-each select="$local_metadata/element">
					<xsl:if test="attribute[@name='WOMI_REFERENCE' and @group_2!='OINT']">
						<error type="exercise_WOMI_set_WOMI_not_OINT" WOMI_id="{@id}"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:copy-of select="$elements[@type='quiz_WOMI_set_metadata']/error"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_WOMI_set_metadata') and not(@style='EPPolecenie')]">
			<error type="exercise_WOMI_set_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='quiz_WOMI_set_metadata') and not(@style='EPPolecenie')]"/>
			</error>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_experiment_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@type='experiment_metadata'])">
			<error type="experiment_local_metadata_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@type='experiment_metadata'])">
			<error type="experiment_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='experiment_metadata']/error"/>
		<xsl:if test="($elements[@style='EPDowiadczenie-hipoteza'] or $elements[@style='EPDowiadczenie-problembadawczy']) and $elements[@style='EPDowiadczenie-cel']">
			<error type="experiment_objective_and_problem_hypotesis_exclusion"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDowiadczenie-hipoteza'] and $elements[@style='EPDowiadczenie-problembadawczy']) and not($elements[@style='EPDowiadczenie-cel'])">
			<error type="experiment_objective_or_problem_and_hypotesis_missing"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDowiadczenie-hipoteza']) and $elements[@style='EPDowiadczenie-problembadawczy']">
			<error type="experiment_hypotesis_without_problem"/>
		</xsl:if>
		<xsl:if test="$elements[@style='EPDowiadczenie-hipoteza'] and not($elements[@style='EPDowiadczenie-problembadawczy'])">
			<error type="experiment_hypotesis_without_problem"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="experiment_name_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-problembadawczy'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-problembadawczy']]]">
			<error type="experiment_problem_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-hipoteza'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-hipoteza']]]">
			<error type="experiment_hypotesis_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-cel'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-cel']]]">
			<error type="experiment_objective_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-materiayiprzyrzdy'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-materiayiprzyrzdy']]]">
			<error type="experiment_instruments_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-instrukcja'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-instrukcja']]]">
			<error type="experiment_instructions_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDowiadczenie-instrukcja'])">
			<error type="experiment_instructions_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-podsumowanie'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-podsumowanie']]]">
			<error type="experiment_conclusions_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='experiment_metadata') and not(some $x in ('EPNazwa','EPDowiadczenie-problembadawczy','EPDowiadczenie-hipoteza','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]">
			<error type="experiment_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='experiment_metadata') and not(some $x in ('EPNazwa','EPDowiadczenie-problembadawczy','EPDowiadczenie-hipoteza','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPDowiadczenie-problembadawczy','EPDowiadczenie-hipoteza','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-problembadawczy'][preceding-sibling::element()[some $x in ('EPDowiadczenie-hipoteza','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-hipoteza'][preceding-sibling::element()[some $x in ('EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-cel'][preceding-sibling::element()[some $x in ('EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-materiayiprzyrzdy'][preceding-sibling::element()[some $x in ('EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-instrukcja'][preceding-sibling::element()[@style='EPDowiadczenie-podsumowanie']]">
			<warn type="experiment_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_observation_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:if test="not($elements[@type='observation_metadata'])">
			<error type="observation_local_metadata_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@type='observation_metadata'])">
			<error type="observation_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='observation_metadata']/error"/>
		<xsl:if test="not($elements[@style='EPDowiadczenie-cel'])">
			<error type="observation_objective_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="observation_name_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-cel'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-cel']]]">
			<error type="observation_objective_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-materiayiprzyrzdy'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-materiayiprzyrzdy']]]">
			<error type="observation_instruments_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-instrukcja'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-instrukcja']]]">
			<error type="observation_instructions_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPDowiadczenie-instrukcja'])">
			<error type="observation_instructions_missing"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPDowiadczenie-podsumowanie'][following-sibling::separator[following-sibling::element()[@style='EPDowiadczenie-podsumowanie']]]">
			<error type="observation_conclusions_duplicate"/>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='observation_metadata') and not(some $x in ('EPNazwa','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]">
			<error type="observation_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='observation_metadata') and not(some $x in ('EPNazwa','EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie','EPNotka-wskazwka','EPNotatka-wskazwka','EPNotka-ostrzeenie','EPNotatka-ostrzeenie','EPNotka-wane','EPNotatka-wane') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPDowiadczenie-cel','EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-cel'][preceding-sibling::element()[some $x in ('EPDowiadczenie-materiayiprzyrzdy','EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-materiayiprzyrzdy'][preceding-sibling::element()[some $x in ('EPDowiadczenie-instrukcja','EPDowiadczenie-podsumowanie') satisfies @style=$x]] or $teb/TEB/element()[@style='EPDowiadczenie-instrukcja'][preceding-sibling::element()[@style='EPDowiadczenie-podsumowanie']]">
			<warn type="observation_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_biography_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:variable name="local_metadata" select="$elements[@type='biography_metadata'][1]"/>
		<xsl:if test="not($elements[@type='biography_metadata'])">
			<error type="biography_local_metadata_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@type='biography_metadata'])">
			<error type="biography_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='biography_metadata']//error"/>
		<xsl:copy-of select="$elements[@type='biography_metadata']//warn"/>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="biography_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="biography_name_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPOpis'][following-sibling::separator[following-sibling::element()[@style='EPOpis']]]">
			<error type="biography_content_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPOpis'])">
			<error type="biography_content_missing"/>
		</xsl:if>
		<xsl:if test="$local_metadata">
			<xsl:variable name="birth_date_type" select="$local_metadata/attribute[@key='ep:birth_date_type']/text()"/>
			<xsl:variable name="birth_date_value" select="$local_metadata/attribute[@key='ep:birth_date_value']/text()"/>
			<xsl:choose>
				<xsl:when test="$birth_date_type='exact'">
					<xsl:if test="not(matches($birth_date_value,'^[0-3]?\d/[01]?\d/\d+$'))">
						<error type="biography_birth_date_exact_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('year','around-year') satisfies $x=$birth_date_type">
					<xsl:if test="not(matches($birth_date_value,'^\d+$'))">
						<error type="biography_birth_date_year_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$birth_date_type">
					<xsl:if test="not(epconvert:is_correct_roman_number($birth_date_value))">
						<error type="biography_birth_date_century_invalid_value"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="''!=$birth_date_value">
						<error type="biography_birth_date_lack_with_value"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="death_date_type" select="$local_metadata/attribute[@key='ep:death_date_type']/text()"/>
			<xsl:variable name="death_date_value" select="$local_metadata/attribute[@key='ep:death_date_value']/text()"/>
			<xsl:choose>
				<xsl:when test="$death_date_type='exact'">
					<xsl:if test="not(matches($death_date_value,'^[0-3]?\d/[01]?\d/\d+$'))">
						<error type="biography_death_date_exact_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('year','around-year') satisfies $x=$death_date_type">
					<xsl:if test="not(matches($death_date_value,'^\d+$'))">
						<error type="biography_death_date_year_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$death_date_type">
					<xsl:if test="not(epconvert:is_correct_roman_number($death_date_value))">
						<error type="biography_death_date_century_invalid_value"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="''!=$death_date_value">
						<error type="biography_death_date_lack_with_value"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="sorting-key" select="$local_metadata/attribute[@key='ep:sorting-key']/text()"/>
			<xsl:variable name="glossary" select="$local_metadata/attribute[@key='ep:glossary']/text()"/>
			<xsl:if test="not('true'=$glossary) and ''!=$sorting-key">
				<warn type="biography_sorted_but_doesnt_go_to_glossary"/>
			</xsl:if>
			<xsl:for-each select="$local_metadata/element">
				<xsl:variable name="womi_type" select="attribute[@name='WOMI_REFERENCE']/@group_2"/>
				<xsl:variable name="womi_zoomable" select="attribute[@name='WOMI_ZOOMABLE']/text()"/>
				<xsl:variable name="womi_text_copy" select="attribute[@name='WOMI_TEXT_COPY']/text()"/>
				<xsl:variable name="womi_text_classic" select="attribute[@name='WOMI_TEXT_CLASSIC']/text()"/>
				<xsl:if test="not(some $x in ('IMAGE','ICON') satisfies $x=$womi_type)">
					<xsl:if test="'zoom'=$womi_zoomable or 'magnifier'=$womi_zoomable">
						<xsl:element name="error">
							<xsl:attribute name="type" select="'WOMI_zoomable_while_not_image'"/>
							<xsl:attribute name="id" select="@id"/>
							<xsl:element name="field_name">
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:zoomable']/name"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="'true'=$womi_text_copy and not(''!=$womi_text_classic)">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_text_copy_but_no_classic_text'"/>
						<xsl:attribute name="id" select="@id"/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='biography_metadata') and not(some $x in ('EPNazwa','EPOpis') satisfies @style=$x)]">
			<error type="biography_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='biography_metadata') and not(some $x in ('EPNazwa','EPOpis') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPOpis') satisfies @style=$x]]">
			<warn type="biography_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:check_event_block">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="teb">
			<TEB>
				<xsl:copy-of select="$elements"/>
			</TEB>
		</xsl:variable>
		<xsl:variable name="local_metadata" select="$elements[@type='event_metadata'][1]"/>
		<xsl:if test="not($elements[@type='event_metadata'])">
			<error type="event_local_metadata_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@type='event_metadata'])">
			<error type="event_local_metadata_duplicate"/>
		</xsl:if>
		<xsl:copy-of select="$elements[@type='event_metadata']//error"/>
		<xsl:copy-of select="$elements[@type='event_metadata']//warn"/>
		<xsl:if test="not($elements[@style='EPNazwa'])">
			<error type="event_name_missing"/>
		</xsl:if>
		<xsl:if test="1 &lt; count($elements[@style='EPNazwa'])">
			<error type="event_name_duplicate"/>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPOpis'][following-sibling::separator[following-sibling::element()[@style='EPOpis']]]">
			<error type="event_content_duplicate"/>
		</xsl:if>
		<xsl:if test="not($elements[@style='EPOpis'])">
			<error type="event_content_missing"/>
		</xsl:if>
		<xsl:if test="$local_metadata">
			<xsl:variable name="start_date_type" select="$local_metadata/attribute[@key='ep:start_date_type']/text()"/>
			<xsl:variable name="start_date_value" select="$local_metadata/attribute[@key='ep:start_date_value']/text()"/>
			<xsl:choose>
				<xsl:when test="$start_date_type='exact'">
					<xsl:if test="not(matches($start_date_value,'^[0-3]?\d/[01]?\d/\d+$'))">
						<error type="event_start_date_exact_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('year','around-year') satisfies $x=$start_date_type">
					<xsl:if test="not(matches($start_date_value,'^\d+$'))">
						<error type="event_start_date_year_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$start_date_type">
					<xsl:if test="not(epconvert:is_correct_roman_number($start_date_value))">
						<error type="event_start_date_century_invalid_value"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="''!=$start_date_value">
						<error type="event_start_date_lack_with_value"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="end_date_type" select="$local_metadata/attribute[@key='ep:end_date_type']/text()"/>
			<xsl:variable name="end_date_value" select="$local_metadata/attribute[@key='ep:end_date_value']/text()"/>
			<xsl:choose>
				<xsl:when test="$end_date_type='exact'">
					<xsl:if test="not(matches($end_date_value,'^[0-3]?\d/[01]?\d/\d+$'))">
						<error type="event_end_date_exact_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('year','around-year') satisfies $x=$end_date_type">
					<xsl:if test="not(matches($end_date_value,'^\d+$'))">
						<error type="event_end_date_year_pattern_mismatch"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="some $x in ('century','beginning-of-century','end-of-century','middle-of-century','turn-of-century') satisfies $x=$end_date_type">
					<xsl:if test="not(epconvert:is_correct_roman_number($end_date_value))">
						<error type="event_end_date_century_invalid_value"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="''!=$end_date_value">
						<error type="event_end_date_lack_with_value"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="$local_metadata/element">
				<xsl:variable name="womi_type" select="attribute[@name='WOMI_REFERENCE']/@group_2"/>
				<xsl:variable name="womi_zoomable" select="attribute[@name='WOMI_ZOOMABLE']/text()"/>
				<xsl:variable name="womi_text_copy" select="attribute[@name='WOMI_TEXT_COPY']/text()"/>
				<xsl:variable name="womi_text_classic" select="attribute[@name='WOMI_TEXT_CLASSIC']/text()"/>
				<xsl:if test="not(some $x in ('IMAGE','ICON') satisfies $x=$womi_type)">
					<xsl:if test="'zoom'=$womi_zoomable or 'magnifier'=$womi_zoomable">
						<xsl:element name="error">
							<xsl:attribute name="type" select="'WOMI_zoomable_while_not_image'"/>
							<xsl:attribute name="id" select="@id"/>
							<xsl:element name="field_name">
								<xsl:value-of select="$SPECIAL_TABLES_DESCRIPTORS/special_table_descriptor[@type='womi_metadata']/field[@key='ep:zoomable']/name"/>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:if>
				<xsl:if test="'true'=$womi_text_copy and not(''!=$womi_text_classic)">
					<xsl:element name="warn">
						<xsl:attribute name="type" select="'WOMI_text_copy_but_no_classic_text'"/>
						<xsl:attribute name="id" select="@id"/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='event_metadata') and not(some $x in ('EPNazwa','EPOpis') satisfies @style=$x)]">
			<error type="event_disallowed_elements">
				<xsl:copy-of select="$elements[not(local-name()='separator') and not(local-name()='table') and not(local-name()='special_table' and @type='event_metadata') and not(some $x in ('EPNazwa','EPOpis') satisfies @style=$x)]"/>
			</error>
		</xsl:if>
		<xsl:if test="$teb/TEB/element()[@style='EPNazwa'][preceding-sibling::element()[some $x in ('EPOpis') satisfies @style=$x]]">
			<warn type="event_wrong_order"/>
		</xsl:if>
	</xsl:function>
	<xsl:function name="epconvert:determine_quiz_type">
		<xsl:param name="elements" as="node()*"/>
		<xsl:variable name="answer_types">
			<xsl:for-each-group select="$elements" group-adjacent="string(@style)">
				<xsl:choose>
					<xsl:when test="current-grouping-key()='EPQOdpowied-poprawna'">
						<correct/>
					</xsl:when>
					<xsl:when test="current-grouping-key()='EPQOdpowied-bdna'">
						<incorrect/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:element name="output">
			<xsl:attribute name="quiz_type"><xsl:choose><xsl:when test="not($answer_types/incorrect)">ordered-response</xsl:when><xsl:when test="1 = count($answer_types/correct)">single-response</xsl:when><xsl:otherwise>multiple-response</xsl:otherwise></xsl:choose></xsl:attribute>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:remove_orphan_comment_ends">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="'special_table'=local-name($element)">
				<xsl:copy-of select="$element"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name($element)}">
					<xsl:copy-of select="$element/attribute()"/>
					<xsl:for-each select="$element/element()">
						<xsl:choose>
							<xsl:when test="./element()">
								<xsl:copy-of select="epconvert:remove_orphan_comment_ends(.)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="local-name()='commentEnd'">
										<xsl:variable name="id" select="@id"/>
										<xsl:choose>
											<xsl:when test="preceding-sibling::commentStart[@id=$id]">
												<xsl:copy-of select="."/>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:copy-of select="."/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_nesting_top">
		<xsl:param name="element" as="element()"/>
		<xsl:element name="{local-name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:copy-of select="epconvert:check_meanings_nesting($element)"/>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:check_meanings_nesting">
		<xsl:param name="element" as="element()"/>
		<xsl:for-each-group select="$element/*" group-starting-with="module|header1|header2|header3">
			<xsl:choose>
				<xsl:when test="some $x in ('module','header1','header2','header3') satisfies local-name(current-group()[1])=$x">
					<xsl:element name="{local-name(current-group()[1])}">
						<xsl:for-each select="current-group()[1]/attribute()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
						<xsl:copy-of select="epconvert:check_meanings_nesting(current-group()[1])"/>
					</xsl:element>
					<xsl:for-each select="current-group()[position()&gt;1]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="current-group()[local-name()='commentStart']">
							<xsl:for-each select="current-group()">
								<xsl:choose>
									<xsl:when test="local-name()='commentStart'">
										<xsl:variable name="errors" select="epconvert:check_comment_nesting(@id, current-group())"/>
										<xsl:choose>
											<xsl:when test="$errors/error">
												<xsl:for-each select="$errors/error">
													<xsl:copy-of select="."/>
												</xsl:for-each>
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
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="current-group()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:function>
	<xsl:function name="epconvert:check_comment_nesting">
		<xsl:param name="id"/>
		<xsl:param name="group" as="node()*"/>
		<xsl:variable name="extracted_group" select="epconvert:extract_elements_in_comment($id, $group)"/>
		<output>
			<xsl:for-each select="$extracted_group/commentStart">
				<xsl:variable name="local_id" select="@id"/>
				<xsl:if test="not($extracted_group/commentEnd[@id=$local_id])">
					<error type="incorrect_comment_nesting" id="{$id}" with-id="{$local_id}"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="$extracted_group/commentEnd">
				<xsl:variable name="local_id" select="@id"/>
				<xsl:if test="not($extracted_group/commentStart[@id=$local_id])">
					<error type="incorrect_comment_nesting" id="{$id}" with-id="{$local_id}"/>
				</xsl:if>
			</xsl:for-each>
		</output>
	</xsl:function>
	<xsl:function name="epconvert:extract_elements_in_comment">
		<xsl:param name="id"/>
		<xsl:param name="group" as="node()*"/>
		<xsl:for-each select="$group">
			<xsl:if test="local-name()='commentStart' and @id=$id">
				<xsl:variable name="all_elements" select="following-sibling::element()[not(local-name()='commentEnd' and @id=$id)]"/>
				<output>
					<xsl:for-each select="following-sibling::element()">
						<xsl:variable name="position" select="position()"/>
						<xsl:if test="generate-id($all_elements[$position])=generate-id(.)">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</output>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	<xsl:function name="epconvert:apply_meanings_top">
		<xsl:param name="element" as="element()"/>
		<xsl:element name="{local-name($element)}">
			<xsl:copy-of select="$element/attribute()"/>
			<xsl:copy-of select="epconvert:apply_meanings($element)"/>
		</xsl:element>
	</xsl:function>
	<xsl:function name="epconvert:apply_meanings">
		<xsl:param name="element" as="element()"/>
		<xsl:for-each-group select="$element/element()" group-starting-with="map|module|header1|header2|header3">
			<xsl:choose>
				<xsl:when test="some $x in ('module','header1','header2','header3') satisfies local-name(current-group()[1])=$x">
					<xsl:element name="{local-name(current-group()[1])}">
						<xsl:for-each select="current-group()[1]/attribute()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
						<xsl:copy-of select="epconvert:apply_meanings(current-group()[1])"/>
					</xsl:element>
					<xsl:for-each select="current-group()[position()&gt;1]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="position_start" select="min(current-group()/@position)"/>
					<xsl:variable name="position_end" select="max(current-group()/@position)"/>
					<xsl:variable name="comments" select="epconvert:comment_properties($position_start,$position_end)"/>
					<xsl:variable name="filtered_comments" select="$comments/comment[some $x in ('definition','concept','exercise','command','homework','glossary-declaration','list','cite','quiz','exercise_WOMI','exercise_set','experiment','observation','biography','event','tooltip','procedure-instructions','code','rule') satisfies @*[local-name()=$x]='true']"/>
					<xsl:variable name="reindexed_comments" select="epconvert:reindex_comments($filtered_comments,current-group())"/>
					<xsl:choose>
						<xsl:when test="$reindexed_comments/comment">
							<xsl:for-each select="current-group()">
								<xsl:variable name="position" select="@position"/>
								<xsl:if test="$position">
									<xsl:if test="$reindexed_comments/comment[@global_start=$position]">
										<xsl:for-each select="$reindexed_comments/comment[@global_start=$position and @*[starts-with(local-name(),'error_')]]">
											<xsl:for-each select="@*[starts-with(local-name(),'error_')]">
												<xsl:analyze-string select="local-name()" regex="^error_(.*)$">
													<xsl:matching-substring>
														<error type="{regex-group(1)}" position="{$position}"/>
													</xsl:matching-substring>
												</xsl:analyze-string>
											</xsl:for-each>
										</xsl:for-each>
										<xsl:for-each select="$reindexed_comments/comment[@global_start=$position and not(@*[starts-with(local-name(),'error_')])]">
											<xsl:sort select="number(@global_end)" order="descending"/>
											<xsl:sort select="number(@id)" order="ascending"/>
											<xsl:variable name="comment" select="."/>
											<xsl:element name="commentStart">
												<xsl:for-each select="('id','global_start','global_end')">
													<xsl:variable name="name" select="."/>
													<xsl:copy-of select="$comment/attribute()[local-name()=$name]"/>
												</xsl:for-each>
												<xsl:for-each select="attribute()[some $x in ('definition','concept','exercise','command','homework','glossary-declaration','list','cite','quiz','exercise_WOMI','exercise_set','experiment','observation','biography','event','tooltip','procedure-instructions','code','rule','glossary-reference','concept-reference','tooltip-reference','event-reference','biography-reference','bibliography-reference') satisfies local-name()=$x]">
													<xsl:if test=".='true'">
														<xsl:copy-of select="."/>
													</xsl:if>
												</xsl:for-each>
												<xsl:copy-of select="element()"/>
											</xsl:element>
										</xsl:for-each>
									</xsl:if>
								</xsl:if>
								<xsl:copy-of select="."/>
								<xsl:if test="$position">
									<xsl:if test="$reindexed_comments/comment[@global_end=$position]">
										<xsl:for-each select="$reindexed_comments/comment[@global_end=$position and not(@*[starts-with(local-name(),'error_')])]">
											<xsl:sort select="number(@global_start)" order="descending"/>
											<xsl:sort select="number(@id)" order="descending"/>
											<xsl:element name="commentEnd">
												<xsl:attribute name="id" select="@id"/>
											</xsl:element>
										</xsl:for-each>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="current-group()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:function>
	<xsl:function name="epconvert:reindex_comments">
		<xsl:param name="comments" as="node()*"/>
		<xsl:param name="current-group" as="node()*"/>
		<xsl:variable name="position_start" select="min($current-group/@position)"/>
		<xsl:variable name="position_end" select="max($current-group/@position)"/>
		<output>
			<xsl:for-each select="$comments">
				<xsl:element name="{local-name()}">
					<xsl:for-each select="attribute()">
						<xsl:choose>
							<xsl:when test="local-name()='global_start'">
								<xsl:variable name="value" select="."/>
								<xsl:choose>
									<xsl:when test="$current-group[@position=$value]">
										<xsl:copy-of select="."/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="number($value) &lt; number($position_start)">
												<xsl:choose>
													<xsl:when test="number($value) &lt;= number($current-group[1]/preceding::*[@position][1]/@position)">
														<xsl:attribute name="error_comment_starts_in_section_before_for_position" select="$position_start"/>
														<xsl:attribute name="{local-name()}" select="$value"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="{local-name()}" select="$position_start"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="{local-name()}" select="min($current-group[number($value) &lt; number(@position)]/@position)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="local-name()='global_end'">
								<xsl:variable name="value" select="."/>
								<xsl:choose>
									<xsl:when test="$current-group[@position=$value]">
										<xsl:copy-of select="."/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="number($position_end) &lt; number($value)">
												<xsl:choose>
													<xsl:when test="number($current-group[last()]/following::*[@position][1]/@position) &lt; number($value)">
														<xsl:attribute name="error_comment_ends_in_section_after_for_position" select="$position_end"/>
														<xsl:attribute name="{local-name()}" select="$value"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="{local-name()}" select="$position_end"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="{local-name()}" select="max($current-group[number(@position) &lt; number($value)]/@position)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="element()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</output>
	</xsl:function>
	<xsl:function name="epconvert:apply_scopes">
		<xsl:param name="element" as="element()"/>
		<xsl:choose>
			<xsl:when test="$element/@position or $element/@position_start">
				<xsl:variable name="comments" select="if($element/@position) then epconvert:comment_properties($element/@position) else epconvert:comment_properties($element/@position_start,$element/@position_end)"/>
				<xsl:variable name="filtered_comments" select="$comments/comment[some $x in ('teacher','expanding','supplemental') satisfies @*[local-name()=$x]='true']"/>
				<xsl:if test="$filtered_comments">
					<xsl:if test="$filtered_comments[@teacher='true'] and $GLOBAL_METADATA/ep:recipient='teacher'">
						<warn type="teacher_recipient_in_teacher_module">
							<xsl:for-each select="$element/@*[starts-with(local-name(),'position')]">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</warn>
					</xsl:if>
					<xsl:if test="$filtered_comments[some $x in ('expanding','supplemental') satisfies @*[local-name()=$x]='true']">
						<xsl:if test="not($GLOBAL_METADATA/ep:status='canon') and $filtered_comments[some $x in ('expanding','supplemental') satisfies @*[local-name()=$x and not($x=$GLOBAL_METADATA/ep:status)]='true']">
							<error type="expanding_or_supplemental_status_not_in_canon_module">
								<xsl:for-each select="$element/@*[starts-with(local-name(),'position')]">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</error>
						</xsl:if>
						<xsl:if test="$filtered_comments[@expanding='true'] and $filtered_comments[@supplemental='true']">
							<error type="expanding_and_supplemental_status">
								<xsl:for-each select="$element/@*[starts-with(local-name(),'position')]">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</error>
						</xsl:if>
						<xsl:if test="$filtered_comments[@*[local-name()=$GLOBAL_METADATA/ep:status]='true']">
							<warn type="local_status_matching_global_status">
								<xsl:for-each select="$element/@*[starts-with(local-name(),'position')]">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</warn>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:element name="{name($element)}">
					<xsl:for-each select="$element/@*">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<xsl:if test="$filtered_comments">
						<xsl:if test="$filtered_comments[@teacher='true']">
							<xsl:attribute name="recipient" select="'teacher'"/>
						</xsl:if>
						<xsl:if test="$filtered_comments[some $x in ('expanding','supplemental') satisfies @*[local-name()=$x]='true']">
							<xsl:attribute name="status"><xsl:choose><xsl:when test="$filtered_comments[@expanding='true']">expanding</xsl:when><xsl:otherwise>supplemental</xsl:otherwise></xsl:choose></xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:for-each select="$element/node()">
						<xsl:choose>
							<xsl:when test="self::element()">
								<xsl:copy-of select="epconvert:apply_scopes(.)"/>
							</xsl:when>
							<xsl:when test="self::text()">
								<xsl:value-of select="."/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name($element)}">
					<xsl:for-each select="$element/@*">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<xsl:for-each select="$element/node()">
						<xsl:choose>
							<xsl:when test="self::element()">
								<xsl:copy-of select="epconvert:apply_scopes(.)"/>
							</xsl:when>
							<xsl:when test="self::text()">
								<xsl:value-of select="."/>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<xsl:function name="epconvert:comment_properties" as="element()">
		<xsl:param name="position_start"/>
		<xsl:copy-of select="epconvert:comment_properties($position_start,0)"/>
	</xsl:function>
	<xsl:function name="epconvert:comment_properties" as="element()">
		<xsl:param name="position_start"/>
		<xsl:param name="position_end"/>
		<output>
			<xsl:choose>
				<xsl:when test="not($position_end)">
					<xsl:copy-of select="$COMMENTS_MAP/comment[number(@global_start)&lt;=number($position_start) and number($position_start)&lt;=number(@global_end)]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$COMMENTS_MAP/comment[(some $x in ($position_start,$position_end) satisfies (number(@global_start)&lt;=number($x) and number($x)&lt;=number(@global_end))) or (number($position_start)&lt;number(@global_start) and number(@global_end)&lt;number($position_end))]"/>
				</xsl:otherwise>
			</xsl:choose>
		</output>
	</xsl:function>
	<xsl:template match="/" mode="LISTS_MAP">
		<xsl:element name="lists-map">
			<xsl:apply-templates select="//w:num" mode="LISTS_MAP"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="w:num" mode="LISTS_MAP">
		<xsl:variable name="numId" select="@w:numId"/>
		<xsl:if test="$PARAGRAPHS_MAP//list_item[@numId=$numId]">
			<xsl:variable name="abstractNumId" select="w:abstractNumId/@w:val"/>
			<xsl:variable name="tmpl" select="//w:abstractNum[@w:abstractNumId=$abstractNumId]/w:tmpl/@w:val"/>
			<xsl:element name="list">
				<xsl:attribute name="numId" select="$numId"/>
				<xsl:choose>
					<xsl:when test="//w:abstractNum[@w:abstractNumId=$abstractNumId]/w:lvl">
						<xsl:apply-templates select="//w:abstractNum[@w:abstractNumId=$abstractNumId]" mode="LISTS_MAP"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="//w:abstractNum[w:tmpl/@w:val=$tmpl and w:lvl][1]" mode="LISTS_MAP"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="w:abstractNum" mode="LISTS_MAP">
		<xsl:for-each select="w:lvl">
			<xsl:element name="lvl">
				<xsl:attribute name="ilvl" select="@w:ilvl"/>
				<xsl:choose>
					<xsl:when test="w:numFmt/@w:val='bullet' or w:numFmt/@w:val='none'">
						<xsl:element name="type">itemizedlist</xsl:element>
						<xsl:if test="w:numFmt/@w:val='none'">
							<xsl:element name="mark">
								<xsl:value-of select="w:lvlText/@w:val"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="type">orderedlist</xsl:element>
						<xsl:element name="numeration">
							<xsl:choose>
								<xsl:when test="w:numFmt/@w:val='lowerRoman'">lowerroman</xsl:when>
								<xsl:when test="w:numFmt/@w:val='upperRoman'">upperroman</xsl:when>
								<xsl:when test="w:numFmt/@w:val='lowerLetter'">loweralpha</xsl:when>
								<xsl:when test="w:numFmt/@w:val='upperLetter'">upperalpha</xsl:when>
								<xsl:when test="w:numFmt/@w:val='decimal'">arabic</xsl:when>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="start">
							<xsl:value-of select="w:start/@w:val"/>
						</xsl:element>
						<xsl:variable name="pattern" select="concat('^([^%]*)%', @w:ilvl+1,'([^%]*)$')"/>
						<xsl:analyze-string select="w:lvlText/@w:val" regex="{$pattern}">
							<xsl:matching-substring>
								<xsl:if test="regex-group(1)!=''">
									<xsl:element name="prefix">
										<xsl:value-of select="regex-group(1)"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="regex-group(2)!=''">
									<xsl:element name="postfix">
										<xsl:value-of select="regex-group(2)"/>
									</xsl:element>
								</xsl:if>
							</xsl:matching-substring>
							<xsl:non-matching-substring>
								<error type="list_cannot_parse_pattern"/>
							</xsl:non-matching-substring>
						</xsl:analyze-string>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
