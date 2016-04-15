<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="imoveis" match="ADS">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync">
      <Header>
        <Provider>OLX</Provider>
        <Email>olx@olx.com</Email>
      </Header>
      <Listings>
        <xsl:for-each select="AD">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="AD">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="ID"/>
      </ListingID>
      <Title>
        <xsl:value-of select="TITLE"/>
      </Title>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="contains(CATEGORY, '367')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '567')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '415')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '410')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '302')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '368')">For Sale</xsl:when>
          <xsl:when test="contains(CATEGORY, '363')">For Rent</xsl:when>
          <xsl:when test="contains(CATEGORY, '301')">For Rent</xsl:when>
          <xsl:when test="contains(CATEGORY, '388')">Vacation Rentals</xsl:when>
          <xsl:when test="starts-with(ID, 'V')">For Sale</xsl:when>
          <xsl:when test="starts-with(ID, 'L')">For Rent</xsl:when>
          <xsl:otherwise>For Rent</xsl:otherwise>
        </xsl:choose>
      </TransactionType>
      <Status>
        <PropertyStatus>Available</PropertyStatus>
      </Status>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="LOCATION_STATE"/>
        </State>
        <City>
          <xsl:value-of select="LOCATION_CITY"/>
        </City>
        <xsl:if test="NEIGHBORHOOD != '' ">
          <Neighborhood>
            <xsl:value-of select="NEIGHBORHOOD"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="LOCATION_NEIGHBORHOOD != '' ">
          <Neighborhood>
            <xsl:value-of select="LOCATION_NEIGHBORHOOD"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="Address != ''">
          <Address>
            <xsl:value-of select="ADDRESS"/>
          </Address>
        </xsl:if>
        <xsl:if test="ZIP_CODE != '00000000' and ZIP_CODE != ''">
          <PostalCode>
            <xsl:value-of select="ZIP_CODE"/>
          </PostalCode>
        </xsl:if>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="DESCRIPTION"/>
          <xsl:if test="PETS = 'Sim'"> - Mascote(s)</xsl:if>
        </Description>
        <xsl:if test="contains(CATEGORY, '367') or contains(CATEGORY, '567') or contains(CATEGORY, '415') or contains(CATEGORY, '410') or contains(CATEGORY, '302') or contains(CATEGORY, '368')">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(CATEGORY, '367')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '567')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '415')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '410') and starts-with(ID, 'V') != 'V'">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '302')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, ',00')">
                    <xsl:value-of select="translate(substring-before(PRICE, ',00'), '.', '')"/>
                  </xsl:when>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '368')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="starts-with(ID, 'V')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="contains(CATEGORY, '363') or contains(CATEGORY, '301') or contains(CATEGORY, '388')">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(CATEGORY, '363')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '301')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="contains(CATEGORY, '388')">
                <xsl:choose>
                  <xsl:when test="contains((PRICE), '.00')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="starts-with(ID, 'L')">
                <xsl:choose>
                  <xsl:when test="contains(PRICE, '.')">
                    <xsl:value-of select="normalize-space(substring-before(PRICE, '.'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(PRICE)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <PropertyType>
          <xsl:choose>
            <xsl:when test="contains(CATEGORY, '367')">
              <xsl:if test="starts-with(TITLE, 'Casa')">Casa</xsl:if>
              <xsl:if test="starts-with(TITLE, 'Apartamento')">Apartamento</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '410')">
              <xsl:if test="starts-with(TITLE, 'Terreno')">Terreno</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '363')">
              <xsl:if test="starts-with(TITLE, 'Casa')">Casa</xsl:if>
              <xsl:if test="starts-with(TITLE, 'Apartamento')">Apartamento</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '301')">
              <xsl:if test="starts-with(TITLE, 'Quarto')">Quarto</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '388')">Aluguel por temporada</xsl:when>
            <xsl:when test="contains(CATEGORY, '415')">
              <xsl:if test="starts-with(TITLE, 'Ponto Comercial')">Ponto Comercial</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '302')">Vagas de estacionamento</xsl:when>
            <xsl:when test="contains(CATEGORY, '368')">
              <xsl:if test="starts-with(TITLE, 'Escritório')">Imóvel Comercial</xsl:if>
            </xsl:when>
            <xsl:when test="contains(CATEGORY, '567')">Casas para trocar</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="CATEGORY"/>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyType>
        <xsl:if test="SURFACE != ''">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(SURFACE, ',00')">
                <xsl:value-of select="translate(substring-before(SURFACE, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(SURFACE, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="BEDROOMS != ''">
          <Bedrooms>
            <xsl:value-of select="BEDROOMS"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="BATHROOMS != ''">
          <Bathrooms>
            <xsl:value-of select="BATHROOMS"/>
          </Bathrooms>
        </xsl:if>
      </Details>
      <ContactInfo>
        <Email>
          <xsl:value-of select="EMAIL"/>
        </Email>
        <Name>
          <xsl:value-of select="EMAIL"/>
        </Name>
        <Telephone>
          <xsl:value-of select="PHONE"/>
        </Telephone>
      </ContactInfo>
      <Media>
        <xsl:for-each select="IMAGE_URL">
          <Item medium="image">
            <xsl:choose>
              <xsl:when test="principal != 'Não'">
                <xsl:attribute name="primary">true</xsl:attribute>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </Item>
        </xsl:for-each>
      </Media>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
