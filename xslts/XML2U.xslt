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
  <xsl:template name="DetallesArchivo" match="FileDetails"/>
  <xsl:template name="DetallesCliente" match="ClientDetails"/>
  <xsl:template name="imoveis" match="properties">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <PublishDate/>
        <Provider>XML4U</Provider>
        <Email>XML4U</Email>
      </Header>
      <Listings>
        <xsl:for-each select="Property">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="Property">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="Price/reference"/>
      </ListingID>
      <TransactionType>
        <xsl:if test="category = 'Residential For Sale'">For Sale</xsl:if>
        <xsl:if test="category = 'Commercial For Sale'">For Sale</xsl:if>
        <xsl:if test="category = 'Residential For Rent'">For Rent</xsl:if>
        <xsl:if test="category = 'Commercial For Rent'">For Rent</xsl:if>
      </TransactionType>
      <Title>
        <xsl:value-of select="Description/propertyType"/>
      </Title>
      <DetailViewUrl/>
      <Location>
        <Country abbreviation="CO">Colombia</Country>
        <State>
          <xsl:value-of select="Address/region"/>
        </State>
        <City>
          <xsl:value-of select="Address/subRegion"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="Address/location"/>
        </Neighborhood>
        <Address publiclyVisible="false">
          <xsl:value-of select="Address/street"/>
        </Address>
        <Latitude/>
        <Longitude/>
        <PostalCode/>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="Description/description"/>
        </Description>
        <ListPrice currency="COP">
          <xsl:if test="category = 'Residential For Sale'">
            <xsl:value-of select="Price/price"/>
          </xsl:if>
          <xsl:if test="category = 'Commercial For Sale'">
            <xsl:value-of select="Price/price"/>
          </xsl:if>
        </ListPrice>
        <RentalPrice currency="COP" period="Monthly">
          <xsl:if test="category = 'Residential For Rent'">
            <xsl:value-of select="Price/price"/>
          </xsl:if>
          <xsl:if test="category = 'Commercial For Rent'">
            <xsl:value-of select="Price/price"/>
          </xsl:if>
        </RentalPrice>
        <PropertyAdministrationFee currency="COP">
          <xsl:value-of select="translate(translate(spareFields/spareField8, 'Valor Admon: $ ', ''), ',', '')"/>
        </PropertyAdministrationFee>
        <PropertyType>
          <xsl:value-of select="Description/propertyType"/>
        </PropertyType>
        <LotArea unit="square metres"/>
        <ConstructedArea unit="square metres">
          <xsl:call-template name="comaSplit">
            <xsl:with-param name="string" select="FloorSize/floorSize"/>
            <xsl:with-param name="pattern" select="'.'"/>
          </xsl:call-template>
        </ConstructedArea>
        <Bedrooms>
          <xsl:value-of select="Description/bedrooms"/>
        </Bedrooms>
        <Bathrooms>
          <xsl:value-of select="Description/fullBathrooms"/>
        </Bathrooms>
        <Estrato>
          <xsl:value-of select="translate(spareFields/spareField7, 'Estrato: ', '')"/>
        </Estrato>
        <Features>
          <!-- NO DISPONIBLE-->
        </Features>
      </Details>
      <Media>
        <xsl:for-each select="images/image">
          <Item medium="image">
            <xsl:value-of select="image"/>
          </Item>
        </xsl:for-each>
      </Media>
      <ContactInfo>
        <xsl:choose>
          <xsl:when test="spareFields/spareField3 and spareFields/spareField3 != ''">
            <Email>
              <xsl:value-of select="spareFields/spareField3"/>
            </Email>
            <Name>
              <xsl:value-of select="spareFields/spareField3"/>
            </Name>
          </xsl:when>
          <xsl:otherwise>
            <Email>XML2U</Email>
            <Name>XML2U</Name>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="spareFields/spareField4">
          <Telephone>
            <xsl:value-of select="spareFields/spareField4"/>
          </Telephone>
        </xsl:if>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
