<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 0.2 -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="referencable"/>
	</xsl:template>
	<xsl:template match="referencable">
		<xsl:variable name="errors" as="element()">
			<xsl:element name="errors">
				<xsl:apply-templates select="module" mode="DETECT_LOCAL_ERRORS"/>
				<xsl:apply-templates select="." mode="DETECT_GLOBAL_ERRORS"/>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="referencable">
			<xsl:apply-templates select="module">
				<xsl:with-param name="errors" select="$errors" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template match="module">
		<xsl:element name="module">
			<xsl:apply-templates select="*"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="id|working_path">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="tooltips">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="tooltips">
			<xsl:for-each select="tooltip">
				<xsl:variable name="id" select="@local-id"/>
				<xsl:element name="tooltip">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[@for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="rules">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="rules">
			<xsl:for-each select="rule">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="rule">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="definitions">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="definitions">
			<xsl:for-each select="definition">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="definition">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="concepts">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="concepts">
			<xsl:for-each select="concept">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="concept">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="biographies">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="biographies">
			<xsl:for-each select="biography">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="biography">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="events">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="events">
			<xsl:for-each select="event">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="event">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="bibliographies">
		<xsl:param name="errors" tunnel="yes"/>
		<xsl:element name="bibliographies">
			<xsl:for-each select="bibliography">
				<xsl:variable name="ids" select="(@local-id,@global-id)"/>
				<xsl:element name="bibliography">
					<xsl:copy-of select="attribute()"/>
					<xsl:copy-of select="$errors/message[some $id in $ids satisfies @for=$id]/error"/>
					<xsl:copy-of select="text()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="module" mode="DETECT_LOCAL_ERRORS">
		<xsl:for-each-group select="tooltips/tooltip" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@local-id"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'tooltip_under_that_name_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@local-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:attribute name="local-id" select="@local-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="rules/rule|definitions/definition" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@local-id"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'glossary_under_that_name_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@local-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:attribute name="local-id" select="@local-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="concepts/concept" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@local-id"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'concept_under_that_name_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@local-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:attribute name="local-id" select="@local-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="biographies/biography" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@local-id"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'biography_under_that_name_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@local-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:attribute name="local-id" select="@local-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="events/event" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@local-id"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'event_under_that_name_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@local-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:attribute name="local-id" select="@local-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template match="referencable" mode="DETECT_GLOBAL_ERRORS">
		<xsl:for-each-group select="//rule[@global-id]|//definition[@global-id]" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@global-id"/>
					<xsl:variable name="module_id" select="ancestor::module/id/text()"/>
					<xsl:if test="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
						<xsl:element name="message">
							<xsl:attribute name="for" select="$id"/>
							<xsl:element name="error">
								<xsl:attribute name="type" select="'glossary_under_that_name_already_exists_global'"/>
								<xsl:element name="name">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:element>
								<xsl:for-each select="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
									<xsl:element name="duplicate">
										<xsl:attribute name="module" select="ancestor::module/id/text()"/>
										<xsl:attribute name="local-id" select="@local-id"/>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="//concept[@global-id]" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@global-id"/>
					<xsl:variable name="module_id" select="ancestor::module/id/text()"/>
					<xsl:if test="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
						<xsl:element name="message">
							<xsl:attribute name="for" select="$id"/>
							<xsl:element name="error">
								<xsl:attribute name="type" select="'concept_under_that_name_already_exists_global'"/>
								<xsl:element name="name">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:element>
								<xsl:for-each select="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
									<xsl:element name="duplicate">
										<xsl:attribute name="module" select="ancestor::module/id/text()"/>
										<xsl:attribute name="local-id" select="@local-id"/>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="//biography[@global-id]" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@global-id"/>
					<xsl:variable name="module_id" select="ancestor::module/id/text()"/>
					<xsl:if test="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
						<xsl:element name="message">
							<xsl:attribute name="for" select="$id"/>
							<xsl:element name="error">
								<xsl:attribute name="type" select="'biography_under_that_name_already_exists_global'"/>
								<xsl:element name="name">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:element>
								<xsl:for-each select="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
									<xsl:element name="duplicate">
										<xsl:attribute name="module" select="ancestor::module/id/text()"/>
										<xsl:attribute name="local-id" select="@local-id"/>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="//event[@global-id]" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@global-id"/>
					<xsl:variable name="module_id" select="ancestor::module/id/text()"/>
					<xsl:if test="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
						<xsl:element name="message">
							<xsl:attribute name="for" select="$id"/>
							<xsl:element name="error">
								<xsl:attribute name="type" select="'event_under_that_name_already_exists_global'"/>
								<xsl:element name="name">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:element>
								<xsl:for-each select="current-group()[@global-id!=$id and $module_id!=ancestor::module/id/text()]">
									<xsl:element name="duplicate">
										<xsl:attribute name="module" select="ancestor::module/id/text()"/>
										<xsl:attribute name="local-id" select="@local-id"/>
									</xsl:element>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group select="//bibliography" group-by="text()">
			<xsl:if test="1 &lt; count(current-group())">
				<xsl:for-each select="current-group()">
					<xsl:variable name="id" select="@global-id"/>
					<xsl:variable name="module_id" select="ancestor::module/id/text()"/>
					<xsl:element name="message">
						<xsl:attribute name="for" select="$id"/>
						<xsl:element name="error">
							<xsl:attribute name="type" select="'bibliography_under_that_id_already_exists'"/>
							<xsl:element name="name">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each select="current-group()[@global-id!=$id]">
								<xsl:element name="duplicate">
									<xsl:if test="ancestor::module/id/text()!=$module_id">
										<xsl:attribute name="module" select="ancestor::module/id/text()"/>
									</xsl:if>
									<xsl:attribute name="local-id" select="@local-id"/>
									<xsl:attribute name="global-id" select="@global-id"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>
