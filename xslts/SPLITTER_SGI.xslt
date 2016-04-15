<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:template name="imoveis" match="Imoveis">
<Imoveis>
		<xsl:for-each select="Imoveis/Imovel">
			<xsl:call-template name="minhaLista" />
		</xsl:for-each>
</Imoveis>
	</xsl:template>
	<xsl:template name="minhaLista" match="Imoveis/Imovel">
		<xsl:if test="Imoveis/Imovel/EmailCliente = 'imoveis@tuliobrilhante.com.br'">
			<xsl:copy-of select="."></xsl:copy-of>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
