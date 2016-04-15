<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xmlns:gz="http://www.gz.imb.br/schemas/1.0/VRSync">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
<xsl:template name="round">
  <xsl:param name="value"/>
  <xsl:value-of select="substring-before($value, ',')"/>
</xsl:template>

<xsl:template name="nome">
	<xsl:value-of select="/gz:ListageDeDados/gz:Imobiliaria/gz:Responsavel"/>
</xsl:template>

<xsl:template name="email">
	<xsl:value-of select="/gz:ListageDeDados/gz:Imobiliaria/gz:Email"/>
</xsl:template>

<xsl:template name="root" match="gz:ListageDeDados">
<ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" 
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                 xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync  http://xml.vivareal.com/vrsync.xsd">
    <Header>
      <Provider><xsl:text>GOYAZ Sistemas</xsl:text></Provider>
      <Email><xsl:text>suporte2@goyazsistemas.com.br</xsl:text></Email>
    </Header>
    <Listings>
	<xsl:for-each select="gz:Imoveis/gz:Imovel">
	  <xsl:call-template name="Listing"/>
	</xsl:for-each>
    </Listings>
 </ListingDataFeed>
</xsl:template>

<xsl:template name="Listing" match="gz:Imoveis/gz:Imovel">
	<Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">  
    <ListingID>
      <xsl:value-of select="gz:id"/>
    </ListingID>
          <LastUpdateDate><xsl:value-of select="/gz:ListageDeDados/gz:Imobiliaria/gz:DataDoXML"></xsl:value-of></LastUpdateDate>
      <TransactionType>
      <xsl:choose>
      	<xsl:when test="gz:operacao = 'ALUGUEL'">For Rent</xsl:when>
      	<xsl:when test="gz:operacao = 'VENDA'">For Sale</xsl:when>
      	<xsl:otherwise>Sale/Rent</xsl:otherwise>
      </xsl:choose>
      </TransactionType>
      <Title>
        <xsl:value-of select="concat(gz:tipo, ' - ', gz:cidade, ' - ', gz:bairro)"/>
      </Title>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="gz:uf"/>
        </State>
        <City>
           <xsl:value-of select="gz:cidade"/>
        </City>
        <Neighborhood>
           <xsl:value-of select="gz:bairro"/>
        </Neighborhood>
        <Address>
          <xsl:choose>
            <xsl:when test="gz:internet_envia_endereco = 1">
              <xsl:attribute name="publiclyVisible">true</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="publiclyVisible">false</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
           <xsl:value-of select="gz:endereco"/>
        </Address>
        <xsl:if test="gz:cep != ''">
          <PostalCode>
            <xsl:value-of select="gz:cep"/>
          </PostalCode>
        </xsl:if>
      </Location>
      <Details>
	      <xsl:if test="gz:numero != ''">
	        <UnitNumber>
	          <xsl:value-of select="gz:numero"/>
	        </UnitNumber>
	      </xsl:if>
        <Description>
          <xsl:value-of select="concat(gz:internet_descricao, ' ', gz:jornal_anuncio_texto)"/> 
        </Description>
        <xsl:if test="gz:operacao = 'VENDA'">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(gz:valor_venda, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(gz:valor_venda, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(gz:valor_venda, '.')">
                <xsl:value-of select="translate(gz:valor_venda, '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="gz:valor_venda"/>
              </xsl:otherwise>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="gz:operacao = 'ALUGUEL'">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(gz:valor_aluguel, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(gz:valor_aluguel, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(gz:valor_aluguel, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="gz:valor_condominio != '0,00' and gz:valor_condominio != '0.00' and gz:valor_condominio != '0' and gz:valor_condominio != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(gz:valor_condominio, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(gz:valor_condominio, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(gz:valor_condominio, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </PropertyAdministrationFee>
        </xsl:if>
        <PropertyType>
          <xsl:value-of select="concat(gz:finalidade, ' / ', gz:tipo)"/>
        </PropertyType>
        <xsl:if test="gz:area_terreno != '' and gz:area_terreno != '0.00'">
          <LotArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(gz:area_terreno, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(area_terreno, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(area_terreno, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LotArea>
        </xsl:if>
        <xsl:if test="gz:area_privativa != '' and gz:area_privativa != '0.00'">
          <LivingArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(gz:area_privativa, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(gz:area_privativa, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(gz:area_privativa, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LivingArea>
        </xsl:if>
        <xsl:if test="gz:area_construida != '' and gz:area_construida != '0.00'">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(gz:area_construida, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(gz:area_construida, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(gz:area_construida, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="gz:quartos != '0' and gz:quartos != ''">
          <Bedrooms>
            <xsl:value-of select="gz:quartos"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="gz:banheiros != '0' and gz:banheiros != ''">
          <Bathrooms>
            <xsl:value-of select="gz:banheiros"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="gz:suites != '0' and gz:suites != ''">
          <Suites>
            <xsl:value-of select="gz:suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="gz:garagens != '0' and gz:garagens != ''">
          <Garage type="Parking Space">
            <xsl:value-of select="gz:garagens"/>
          </Garage>
        </xsl:if>
      </Details>
      <ContactInfo>
        <Name>
			<xsl:call-template name="nome"/>
        </Name>
        <Email>
			<xsl:call-template name="email"/>
        </Email>
      </ContactInfo>
	</Listing>
</xsl:template>

</xsl:stylesheet>