<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:template name="imoveis" match="ListingDataFeed">
<ListingDataFeed>
  <Header>
    <Provider>Fornecedor do Feed Brasil</Provider>
    <Email>contacto@fornecedor.com</Email>
    <ContactName>Nome para Contato</ContactName>
    <Telephone>(41)3216-2795 (11)9669-2395</Telephone>
    <PublishDate>2009-08-10T11:17:14</PublishDate>
    <Logo>www.fornecedor.com.br/Logo.jpg</Logo>
  </Header>
  <Listings>
		<xsl:for-each select="Listings/Listing">
			<xsl:if test="ContactInfo/Email = 'manuel.vergara@coldwellbanker.com.co'">
				<xsl:call-template name="minhaLista" />
			</xsl:if>
		</xsl:for-each>
  </Listings>
</ListingDataFeed>
	</xsl:template>
	<xsl:template name="minhaLista" match="ListingDataFeed/Listings/Listing">
<xsl:copy-of select="."></xsl:copy-of>
	</xsl:template>
</xsl:stylesheet>
