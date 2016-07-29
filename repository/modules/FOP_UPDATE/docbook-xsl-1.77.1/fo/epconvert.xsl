<?xml version="1.0" encoding="UTF-8"?>
<!-- autor: Tomasz Kuczyński tomasz.kuczynski@man.poznan.pl -->
<!-- wersja: 0.3 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:import href="docbook.xsl"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="processing-instruction('br')">
		<fo:block/>
	</xsl:template>
</xsl:stylesheet>
