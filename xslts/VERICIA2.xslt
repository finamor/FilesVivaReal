<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:template name="strSplit">
    <xsl:param name="string"/>
    <xsl:param name="pattern"/>
    <xsl:choose>
      <xsl:when test="contains($string, $pattern)">
        <xsl:call-template name="strSplit">
          <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($string, '?')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="dotSplit">
    <xsl:param name="string"/>
    <xsl:param name="pattern"/>
    <xsl:choose>
      <xsl:when test="contains($string, $pattern)">
        <xsl:call-template name="strSplit">
          <xsl:with-param name="string" select="substring-after($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="comaSplit">
    <xsl:param name="string"/>
    <xsl:param name="pattern"/>
    <xsl:choose>
      <xsl:when test="contains($string, $pattern)">
        <xsl:call-template name="dotSplit">
          <xsl:with-param name="string" select="substring-before($string, $pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="imoveis" match="imoveis">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <PublishDate/>
        <Provider>Vericia</Provider>
        <Email>vericia@vericia.com.br</Email>
      </Header>
      <Listings>
        <xsl:for-each select="imovel">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="detalhes/referenciadaimobiliaria"/>
      </ListingID>
      <TransactionType>For Sale</TransactionType>
      <Title>
        <xsl:value-of select="detalhes/tipodoimovel/tipo"/>
        <xsl:value-of select="detalhes/referenciadaimobiliaria"/>
      </Title>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>-</State>
        <City>
          <xsl:value-of select="localizacao/cidade"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="localizacao/bairro"/>
        </Neighborhood>
        <Address publiclyVisible="false">
          <xsl:value-of select="localizacao/cep"/>
          <xsl:value-of select="localizacao/endereco"/>
        </Address>
        <Latitude>
          <xsl:value-of select="localizacao/latitude"/>
        </Latitude>
        <Longitude>
          <xsl:value-of select="localizacao/longitude"/>
        </Longitude>
        <PostalCode>
          <xsl:value-of select="cep"/>
        </PostalCode>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="detalhes/descricao"/>
        </Description>
        <ListPrice currency="BRL">
          <xsl:call-template name="comaSplit">
            <xsl:with-param name="string" select="translate(detalhes/valordoimovel, '.', '')"/>
            <xsl:with-param name="pattern" select="','"/>
          </xsl:call-template>
        </ListPrice>
        <RentalPrice currency="BRL" period="Monthly"/>
        <PropertyType>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Apartamento'">Residential / Apartment</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Comercial'">Commercial / Building</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Casa de Condomínio'">Residential / Condo</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Terreno'">Residential / Land/Lot</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Casa Padrão'">Residential / Home</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo = 'Propriedade Rural'">Residential / Farm/Ranch</xsl:if>
          <xsl:if test="detalhes/tipodoimovel/subtipo != 'Apartamento' and detalhes/tipodoimovel/subtipo != 'Comercial' and detalhes/tipodoimovel/subtipo != 'Casa de Condomínio' and detalhes/tipodoimovel/subtipo != 'Terreno' and detalhes/tipodoimovel/subtipo != 'Casa Padrão' and detalhes/tipodoimovel/subtipo != 'Propriedade Rural'">
            <xsl:value-of select="detalhes/tipodoimovel/subtipo"/>
          </xsl:if>
        </PropertyType>
        <LotArea unit="square metres"/>
        <ConstructedArea unit="square metres">
          <xsl:call-template name="comaSplit">
            <xsl:with-param name="string" select="detalhes/areaprivada"/>
            <xsl:with-param name="pattern" select="','"/>
          </xsl:call-template>
        </ConstructedArea>
        <DevelopmentLevel>
          <xsl:if test="detalhes/situacaodoimovel = 'LANÇAMENTO'">Under Construction</xsl:if>
        </DevelopmentLevel>
        <Bedrooms>
          <xsl:value-of select="detalhes/numerodequartos"/>
        </Bedrooms>
        <Bathrooms>
          <xsl:value-of select="detalhes/numerodevagas"/>
        </Bathrooms>
        <Features>
          <!--NO HAY INFORMACION AL RESPECTO-->
        </Features>
      </Details>
      <Media>
        <xsl:for-each select="media/fotos/urlfoto">
          <Item medium="image">
            <xsl:value-of select="."/>
          </Item>
        </xsl:for-each>
      </Media>
      <ContactInfo>
        <Email>
          <xsl:value-of select="imobiliaria/nomedaimobiliaria"/>
        </Email>
        <Name>
          <xsl:value-of select="imobiliaria/nomedaimobiliaria"/>
        </Name>
        <Website>
          <xsl:value-of select="imobiliaria/urldaimobiliaria"/>
        </Website>
        <Telephone>
          <xsl:value-of select="imobiliaria/telefonedaimobiliaria"/>
        </Telephone>
        <Logo>
          <xsl:value-of select="imobiliaria/urllogodaimobiliaria"/>
        </Logo>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
