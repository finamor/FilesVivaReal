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
        <Provider>Lopes</Provider>
        <Email>integracoes@vivareal.com</Email>
      </Header>
      <Listings>
        <xsl:for-each select="imovel">
          <xsl:if test="detalhes/situacaodoimovel != 'LANÇAMENTO'">
            <xsl:call-template name="Listing"/>
          </xsl:if>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
    <ListingID>
      <xsl:value-of select="id"/>
    </ListingID>
    <TransactionType>
      <xsl:choose>
        <xsl:when test="detalhes/valordoimovel != '0' and detalhes/valordoaluguel = '0'">
          <xsl:text>For Sale</xsl:text>
        </xsl:when>
        <xsl:when test="detalhes/valordoimovel = '0' and detalhes/valordoaluguel != '0'">
          <xsl:text>For Rent</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Sale/Rent</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </TransactionType>
    <Title>
      <xsl:value-of select="detalhes/tipodoimovel/tipo"/> (Ref. Lopes/Pronto: <xsl:value-of select="id"/>)
    </Title>
    <DetailViewUrl>
      <xsl:value-of select="linkdoimovel/urldoimovel"/>
    </DetailViewUrl>
    <Location>
      <xsl:choose>
        <xsl:when test="localizacao/exibirenderecocompleto != 'Sim'">
          <xsl:attribute name="displayAddress">Neighborhood</xsl:attribute>
        </xsl:when>
        <xsl:when test="localizacao/numero != ''">
          <xsl:attribute name="displayAddress">All</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="displayAddress">Street</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <Country abbreviation="BR">BR</Country>
      <State>
        <xsl:value-of select="localizacao/uf"/>
      </State>
      <City>
        <xsl:value-of select="localizacao/cidade"/>
      </City>
      <Neighborhood>
        <xsl:value-of select="localizacao/bairro"/>
      </Neighborhood>
      <Address>
        <xsl:value-of select="localizacao/endereco"/>
      </Address>
      <xsl:if test="localizacao/numero != ''">
        <StreetNumber>
          <xsl:value-of select="localizacao/numero"/>
        </StreetNumber>
      </xsl:if>
      <Latitude>
        <xsl:choose>
          <xsl:when test="contains(localizacao/latitude, ',')">
            <xsl:value-of select="translate(localizacao/latitude, ',','.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="localizacao/latitude"/>
          </xsl:otherwise>
        </xsl:choose>
      </Latitude>
      <Longitude>
        <xsl:choose>
          <xsl:when test="contains(localizacao/longitude, ',')">
            <xsl:value-of select="translate(localizacao/longitude, ',','.')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="localizacao/longitude"/>
          </xsl:otherwise>
          </xsl:choose>
      </Longitude>
      <PostalCode>
        <xsl:value-of select="localizacao/cep"/>
      </PostalCode>
    </Location>
    <Details>
      <xsl:if test="detalhes/numerodevagas != '0'">
        <Garage type="Parking Space">
          <xsl:value-of select="detalhes/numerodevagas"/>
        </Garage>
      </xsl:if>
      <Description>
        <xsl:choose>
          <xsl:when test="detalhes/descricao != ''">
            <xsl:value-of select="detalhes/descricao"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="detalhes/tipodoimovel/tipo"/>
          </xsl:otherwise>
        </xsl:choose>
      </Description>
      <xsl:choose>
        <xsl:when test="detalhes/valordoimovel != '0' and detalhes/valordoaluguel = '0'">
          <ListPrice currency="BRL">
            <xsl:call-template name="comaSplit">
              <xsl:with-param name="string" select="translate(detalhes/valordoimovel, '.', '')"/>
              <xsl:with-param name="pattern" select="','"/>
            </xsl:call-template>
          </ListPrice>
        </xsl:when>
        <xsl:when test="detalhes/valordoimovel = '0' and detalhes/valordoaluguel != '0'">
          <RentalPrice currency="BRL">
            <xsl:call-template name="comaSplit">
              <xsl:with-param name="string" select="translate(detalhes/valordoaluguel, '.', '')"/>
              <xsl:with-param name="pattern" select="','"/>
            </xsl:call-template>
          </RentalPrice>
        </xsl:when>
        <xsl:otherwise>
          <ListPrice currency="BRL">
            <xsl:call-template name="comaSplit">
              <xsl:with-param name="string" select="translate(detalhes/valordoimovel, '.', '')"/>
              <xsl:with-param name="pattern" select="','"/>
            </xsl:call-template>
          </ListPrice>
          <RentalPrice currency="BRL">
            <xsl:call-template name="comaSplit">
              <xsl:with-param name="string" select="translate(detalhes/valordoaluguel, '.', '')"/>
              <xsl:with-param name="pattern" select="','"/>
            </xsl:call-template>
          </RentalPrice>
        </xsl:otherwise>
      </xsl:choose>
      <PropertyType>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Apartamento'">Residential / Apartment</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Comercial'">Commercial / Building</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Casa de Condomínio'">Residential / Condo</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Terreno'">Residential / Land/Lot</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Casa Padrão'">Residential / Home</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo = 'Propriedade Rural'">Residential / Farm/Ranch</xsl:if>
        <xsl:if test="detalhes/tipodoimovel/tipo != 'Apartamento' and detalhes/tipodoimovel/tipo != 'Comercial' and detalhes/tipodoimovel/tipo != 'Casa de Condomínio' and detalhes/tipodoimovel/tipo != 'Terreno' and detalhes/tipodoimovel/tipo != 'Casa Padrão' and detalhes/tipodoimovel/tipo != 'Propriedade Rural'">
          <xsl:value-of select="detalhes/tipodoimovel/tipo"/>
        </xsl:if>
      </PropertyType>
      <LotArea unit="square metres">
        <xsl:call-template name="comaSplit">
          <xsl:with-param name="string" select="detalhes/areatotal"/>
          <xsl:with-param name="pattern" select="','"/>
        </xsl:call-template>
      </LotArea>
      <LivingArea unit="square metres">
        <xsl:call-template name="comaSplit">
          <xsl:with-param name="string" select="detalhes/areaprivada"/>
          <xsl:with-param name="pattern" select="','"/>
        </xsl:call-template>
      </LivingArea>
      <xsl:if test="detalhes/areaconstruida != ''">
        <ConstructedArea unit="square metres">
          <xsl:call-template name="comaSplit">
            <xsl:with-param name="string" select="detalhes/areaconstruida"/>
            <xsl:with-param name="pattern" select="','"/>
          </xsl:call-template>
        </ConstructedArea>
      </xsl:if>
      <xsl:if test="detalhes/situacaodoimovel = 'LANÇAMENTO'">
        <DevelopmentLevel>
          <xsl:text>Under Construction</xsl:text>
        </DevelopmentLevel>
      </xsl:if>
      <xsl:if test="detalhes/numerodequartos != '0'">
        <Bedrooms>
          <xsl:value-of select="detalhes/numerodequartos"/>
        </Bedrooms>
      </xsl:if>
      <xsl:if test="detalhes/numerodebanheiros != '0'">
        <Bathrooms>
          <xsl:value-of select="detalhes/numerodebanheiros"/>
        </Bathrooms>
      </xsl:if>
      <xsl:if test="detalhes/valordocondominio != ''">
        <PropertyAdministrationFee currency="BRL">
        <xsl:call-template name="comaSplit">
          <xsl:with-param name="string" select="translate(detalhes/valordocondominio, '.', '')"/>
          <xsl:with-param name="pattern" select="','"/>
        </xsl:call-template>
        </PropertyAdministrationFee>
      </xsl:if>
      <xsl:if test="detalhes/valordoiptu != ''">
        <YearlyTax currency="BRL">
        <xsl:call-template name="comaSplit">
          <xsl:with-param name="string" select="translate(detalhes/valordoiptu, '.', '')"/>
          <xsl:with-param name="pattern" select="','"/>
        </xsl:call-template>
        </YearlyTax>
      </xsl:if>
      <Features>
        <!--NO HAY INFORMACION AL RESPECTO-->
      </Features>
    </Details>
    <xsl:if test="media/fotos/urlfoto != ''">
      <Media>
        <xsl:for-each select="media/fotos/urlfoto">
          <Item medium="image">
            <xsl:value-of select="."/>
          </Item>
        </xsl:for-each>
      </Media>
    </xsl:if>
    <ContactInfo>
      <Email>
        <xsl:call-template name="comaSplit">
          <xsl:with-param name="string" select="imobiliaria/email"/>
          <xsl:with-param name="pattern" select="';'"/>
        </xsl:call-template>
      </Email>
      <Name>
        <xsl:value-of select="imobiliaria/nome"/>
      </Name>
      <Website>
        <xsl:value-of select="imobiliaria/url"/>
      </Website>
      <Telephone>
        <xsl:value-of select="imobiliaria/telefone"/>
      </Telephone>
    </ContactInfo>
    <xsl:if test="EmDestaque = '1'">
      <Featured>true</Featured>
    </xsl:if>
    </Listing>
  </xsl:template>
</xsl:stylesheet>