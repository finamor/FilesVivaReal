<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:template name="imoveis" match="Document">
<Document>
		<xsl:for-each select="imoveis/imovel">
			<xsl:if test="nomeloja = 'Batel'"> <!-- email = 'adolfo.siqueira@apolaraguaverde.com.br'"> -->
				<xsl:call-template name="minhaLista" />
			</xsl:if>
		</xsl:for-each>
</Document>
	</xsl:template>
	<xsl:template name="minhaLista" match="Document/imoveis/imovel">
  <imoveis>
<xsl:copy-of select="."></xsl:copy-of>
  </imoveis>
	</xsl:template>
</xsl:stylesheet>
