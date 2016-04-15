<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="listings" match="properties">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>NewHome Source</Provider>
      </Header>
      <Listings>
        <xsl:for-each select="property">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="property">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="details/provider-listingid"/>
      </ListingID>
      <ListDate>
        <xsl:value-of select="details/date-listed"/>
      </ListDate>
      <LastUpdateDate>
        <xsl:value-of select="details/date-listed"/>
      </LastUpdateDate>
      <TransactionType>
        <xsl:value-of select="landing-page/status"/>
      </TransactionType>
      <Title>
        <xsl:value-of select="details/listing-title"/>
      </Title>
      <DetailViewUrl>
        <xsl:value-of select="landing-page/lp-url"/>
      </DetailViewUrl>
      <Location>
        <Country>
          <xsl:value-of select="location/country"/>
        </Country>
        <State>
          <xsl:value-of select="location/state-code"/>
        </State>
        <City>
          <xsl:value-of select="location/city-name"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="location/neighborhood-name"/>
        </Neighborhood>
        <Address>
          <xsl:value-of select="location/street-address"/>
        </Address>
        <PostalCode>
          <xsl:value-of select="location/zipcode"/>
        </PostalCode>
      </Location>
      <Details>
        <Description>
          <xsl:choose>
            <xsl:when test="details/description">
              <xsl:value-of select="details/description"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="community-building/community-description"/>
            </xsl:otherwise>
          </xsl:choose>
        </Description>
        <AvailableDate>
          <xsl:value-of select="details/SpecMoveInDate"/>
        </AvailableDate>
        <xsl:if test="landing-page/status = 'For Sale'">
          <ListPrice>
            <xsl:attribute name="currency">
              <xsl:if test="location/country = 'USA'">
                USD
              </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="translate(translate(details/price, '$', ''), ',' , '')"/>
          </ListPrice>
        </xsl:if>
        <xsl:if test="landing-page/status = 'For Rent'">
          <RentalPrice>
            <xsl:attribute name="currency">
              <xsl:if test="location/country = 'USA'">
                USD
              </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="translate(translate(details/price, '$', ''), ',' , '')"/>
          </RentalPrice>
        </xsl:if>
        <PropertyType>
          <xsl:value-of select="details/property-type"/>
        </PropertyType>
        <ConstructedArea unit="square feet">
          <xsl:value-of select="translate(details/square-feet, ',', '')"/>
        </ConstructedArea>
        <Bedrooms>
          <xsl:value-of select="details/num-bedrooms"/>
        </Bedrooms>
        <Bathrooms>
          <xsl:value-of select="details/num-full-bathrooms"/>
        </Bathrooms>
        <Garage type="Parking Space">
          <xsl:value-of select="detailed-characteristics/parking-types/num-parking-spaces"/>
        </Garage>
      </Details>
      <Media>
        <Item medium="video">
          <xsl:value-of select="virtual-tours/virtual-tour-url"/>
        </Item>
        <xsl:for-each select="pictures/picture">
          <Item medium="image">
            <xsl:if test="picture-seq-number = 1">
              <xsl:attribute name="primary">true</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="picture-url"/>
          </Item>
        </xsl:for-each>
      </Media>
      <ContactInfo>
        <!-- Se decide quemar los valores porque no viene información en el feed de contacto y
             porque en el futuro se van a contactar por WebService -->
        <Email>jwest@builderhomesite.com</Email>
        <Name>Casas Nuevas Aquí</Name>
        <Logo>http://archivos.vivareal.com.s3.amazonaws.com/cna_logo_1.jpg</Logo>
        <Photo>http://archivos.vivareal.com.s3.amazonaws.com/cna_logo_1.jpg</Photo>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
