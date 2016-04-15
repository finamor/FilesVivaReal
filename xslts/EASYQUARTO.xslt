<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="listings" match="feed">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>EASYQUARTO</Provider>
        <Email>dennis.volkmann@dm-companies.com</Email>
      </Header>
      <Listings>
        <xsl:for-each select="ad">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="ad">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="havecode"/>
        <!-- OBRIGATÓRIO VRsync -->
      </ListingID>
      <Title>
        <xsl:value-of select="title"/>
        <!-- OBRIGATÓRIO VRsync -->
      </Title>
      <TransactionType>
        <!-- OBRIGATÓRIO VRsync -->
        For Rent
      </TransactionType>
      <DetailViewUrl>
        <!-- NÃO OBRIGATÓRIO VRsync -->
        <xsl:value-of select="URL1"/>
      </DetailViewUrl>
      <Status>
        <!-- NÃO OBRIGATÓRIO VRsync -->
        <xsl:for-each select="availablefrom">
          <PropertyStatus>
                  Available
                </PropertyStatus>
          <StatusDate>
            <xsl:value-of select="availablefrom"/>
          </StatusDate>
        </xsl:for-each>
      </Status>
      <Location>
        <!-- OBRIGATÓRIO VRsync: tag "Location" com os Campos: "Country" "State" "City" -->
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="metrocode"/>
        </State>
        <City>
          <xsl:value-of select="city"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="neighborhood"/>
        </Neighborhood>
        <xsl:if test="streetname != '' and streetname != ' ' ">
          <Address>
            <xsl:value-of select="streetname"/>
          </Address>
        </xsl:if>
        <xsl:if test="postcode != '' ">
          <PostalCode>
            <xsl:value-of select="postcode"/>
          </PostalCode>
        </xsl:if>
        <Latitude>
          <xsl:value-of select="mapy"/>
        </Latitude>
        <Longitude>
          <xsl:value-of select="mapx"/>
        </Longitude>
      </Location>
      <Details>
        <!-- OBRIGATÓRIO VRsync-->
        <Description>
          <!-- OBRIGATÓRIO VRsync-->
          <xsl:value-of select="adtext"/>
          <xsl:if test="minimumstay != ''">
                   - Mínimo de Permanência: <xsl:value-of select="minimumstay"/> mes(es)
                </xsl:if>
          <xsl:if test="roomtype = '1'">
                   - Quarto individual
                </xsl:if>
          <xsl:if test="roomtype = '2'">
                   - Quarto com Duas Camas
                </xsl:if>
          <xsl:if test="roomtype = '3'">
                   - Quarto com Três Camas
                </xsl:if>
          <xsl:if test="roomtype = '4'">
                   - Quarto com Quatro Camas ou Mais
                </xsl:if>
          <xsl:if test="prefsmoker = '1' or prefsmoker = 'Yes'">
                   - Preferível Fumante
                </xsl:if>
          <xsl:if test="prefsmoker = '2' or prefsmoker = 'No'">
                   - Preferível Não Fumante
                </xsl:if>
          <xsl:if test="prefgender = '1' or prefgender = 'Male'">
                   - Preferível Sexo Masculino
                </xsl:if>
          <xsl:if test="prefgender = '2' or prefgender = 'Female'">
                   - Preferível Sexo Feminino
                </xsl:if>
          <xsl:if test="prefgender = '3' or prefgender = 'Couple'">
                   - Preferível Casal
                </xsl:if>
          <xsl:if test="totalbr != ' ' and totalbr = ''">
                   - Total de Quartos no Imóvel: <xsl:value-of select="totalbr"/>
</xsl:if>
          <xsl:if test="availablebr = ' ' and availablebr = ''">
                   - Quantidade de Quartos Disponíveis para Alugar: <xsl:value-of select="availablebr"/>
</xsl:if>
        </Description>
        <!-- NÃO INFORMA O TIPO DE IMÓVEL, APENAS O TIPO DE QUARTO -->
        <PropertyType>
          <!-- OBRIGATÓRIO VRsync-->
          <xsl:choose>
            <xsl:when test="roomtype = '1'">Single Room</xsl:when>
            <xsl:when test="roomtype = '2'">Double Room</xsl:when>
            <xsl:when test="roomtype = '3'">Triple Room</xsl:when>
            <xsl:when test="roomtype = '4'">Room Share</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="PropertyType"/>
            </xsl:otherwise>
            <!-- OBRIGATÓRIO VRsync-->
            <!-- Informa valor inválido -->
            <!-- APENAS PARA TAGS OBRIGATÓRIAS -->
            <!-- O valor tem de ser entre 1 a 4; 1= Single Room; 2= Double Room; 3= Triple Room; 4 = Room Share -->
          </xsl:choose>
        </PropertyType>
        <xsl:if test="surfacearea != '0,00' and surfacearea != ''">
          <LotArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(surfacearea, ',00')">
                <xsl:value-of select="translate(substring-before(surfacearea, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(surfacearea, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LotArea>
        </xsl:if>
        <xsl:if test="rent != '0' and rent != ''">
          <!-- OBRIGATÓRIO VRsync-->
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(rent, ',00')">
                <xsl:value-of select="translate(substring-before(rent, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:when test="contains(rent, '.00')">
                <xsl:value-of select="translate(substring-before(rent, '.00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(rent, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="bathrooms &gt; '0' and bathrooms &lt; '30'">
          <Bathrooms>
            <xsl:value-of select="bathrooms"/>
          </Bathrooms>
        </xsl:if>
      </Details>
      <Media>
        <xsl:if test="image1 != ''">
          <Item medium="image">
            <xsl:value-of select="image1"/>
          </Item>
        </xsl:if>
        <xsl:if test="image2 != ''">
          <Item medium="image">
            <xsl:value-of select="image2"/>
          </Item>
        </xsl:if>
        <xsl:if test="image3 != ''">
          <Item medium="image">
            <xsl:value-of select="image3"/>
          </Item>
        </xsl:if>
        <xsl:if test="image4 != ''">
          <Item medium="image">
            <xsl:value-of select="image4"/>
          </Item>
        </xsl:if>
        <xsl:if test="image5 != ''">
          <Item medium="image">
            <xsl:value-of select="image5"/>
          </Item>
        </xsl:if>
        <xsl:if test="image6 != ''">
          <Item medium="image">
            <xsl:value-of select="image6"/>
          </Item>
        </xsl:if>
        <xsl:if test="image7 != ''">
          <Item medium="image">
            <xsl:value-of select="image7"/>
          </Item>
        </xsl:if>
        <xsl:if test="image8 != ''">
          <Item medium="image">
            <xsl:value-of select="image8"/>
          </Item>
        </xsl:if>
        <xsl:if test="image9 != ''">
          <Item medium="image">
            <xsl:value-of select="image9"/>
          </Item>
        </xsl:if>
        <xsl:if test="image10 != ''">
          <Item medium="image">
            <xsl:value-of select="image10"/>
          </Item>
        </xsl:if>
        <xsl:if test="image11 != ''">
          <Item medium="image">
            <xsl:value-of select="image11"/>
          </Item>
        </xsl:if>
        <xsl:if test="image12 != ''">
          <Item medium="image">
            <xsl:value-of select="image12"/>
          </Item>
        </xsl:if>
        <xsl:if test="image13 != ''">
          <Item medium="image">
            <xsl:value-of select="image13"/>
          </Item>
        </xsl:if>
        <xsl:if test="image14 != ''">
          <Item medium="image">
            <xsl:value-of select="image14"/>
          </Item>
        </xsl:if>
        <xsl:if test="image15 != ''">
          <Item medium="image">
            <xsl:value-of select="image15"/>
          </Item>
        </xsl:if>
        <xsl:if test="image16 != ''">
          <Item medium="image">
            <xsl:value-of select="image16"/>
          </Item>
        </xsl:if>
        <xsl:if test="image17 != ''">
          <Item medium="image">
            <xsl:value-of select="image17"/>
          </Item>
        </xsl:if>
        <xsl:if test="image18 != ''">
          <Item medium="image">
            <xsl:value-of select="image18"/>
          </Item>
        </xsl:if>
        <xsl:if test="image19 != ''">
          <Item medium="image">
            <xsl:value-of select="image19"/>
          </Item>
        </xsl:if>
        <xsl:if test="image20 != ''">
          <Item medium="image">
            <xsl:value-of select="image20"/>
          </Item>
        </xsl:if>
        <xsl:if test="image21 != ''">
          <Item medium="image">
            <xsl:value-of select="image21"/>
          </Item>
        </xsl:if>
        <xsl:if test="image22 != ''">
          <Item medium="image">
            <xsl:value-of select="image22"/>
          </Item>
        </xsl:if>
        <xsl:if test="image23 != ''">
          <Item medium="image">
            <xsl:value-of select="image23"/>
          </Item>
        </xsl:if>
        <xsl:if test="image24 != ''">
          <Item medium="image">
            <xsl:value-of select="image24"/>
          </Item>
        </xsl:if>
        <xsl:if test="image25 != ''">
          <Item medium="image">
            <xsl:value-of select="image25"/>
          </Item>
        </xsl:if>
      </Media>
      <ContactInfo>
        <Name>
          <xsl:value-of select="username"/>
        </Name>
        <Email>
          <xsl:value-of select="URL2"/>
        </Email>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
