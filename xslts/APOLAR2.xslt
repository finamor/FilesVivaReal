<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
<!-- Este xslt é para processar os imóveis da Franquia Apolar - proveedor_feed = 'APOLAR' e tipo = 'APOLAR2' -->
<!-- Associação de conta é feita utilizando o nomeloja por conta de o cliente trocar muito os emails de contato -->
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="round_comma">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, ',')"/>
  </xsl:template>
  <xsl:template name="round_dot">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, '.')"/>
  </xsl:template>
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
        <Provider>Apolar</Provider>
        <Email>apolar</Email>
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
        <xsl:value-of select="referencia"/>
      </ListingID>
      <TransactionType>
        <xsl:if test="transacao = 'V'">For Sale</xsl:if>
        <xsl:if test="transacao = 'A'">For Rent</xsl:if>
        <xsl:if test="transacao = 'L'">For Rent</xsl:if>
      </TransactionType>
      <!-- <EmDestaque>1</EmDestaque> -->
      <Featured>
		  <xsl:choose>
		  	<xsl:when test="EmDestaque = 'S'">true</xsl:when>
		  	<xsl:when test="destaque = 'S'">true</xsl:when>
		  	<xsl:otherwise>false</xsl:otherwise>
		  </xsl:choose>
	  </Featured>
      <Title><xsl:value-of select="concat(cidade, ' - ', bairro, ' (Ref. ', referencia, ')')"/></Title>
      <xsl:if test="popup_fotos != ''">
      <DetailViewUrl>
        <xsl:value-of select="popup_fotos"/>
      </DetailViewUrl>
      </xsl:if>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="estado"/>
        </State>
        <City>
          <xsl:value-of select="cidade"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="bairro"/>
        </Neighborhood>
        <Address publiclyVisible="false">
          <xsl:value-of select="endereco"/>
        </Address>
<!--         <Latitude/> -->
<!--         <Longitude/> -->
        <PostalCode>
          <xsl:value-of select="cep"/>
        </PostalCode>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="descritivo"/>
        </Description>
        <xsl:if test="valor != '0,00' and valor != '' and valor != '0.00' and valor != '.00'">
          <xsl:choose>
            <xsl:when test="transacao = 'V'">
              <ListPrice currency="BRL">
                <xsl:if test="transacao = 'V'">
                  <xsl:value-of select="substring-before(valor, '.')"/>
                </xsl:if>
              </ListPrice>
            </xsl:when>
            <xsl:otherwise>
              <RentalPrice currency="BRL" period="Monthly">
                <xsl:if test="transacao = 'A'">
                  <xsl:value-of select="substring-before(valor, '.')"/>
                </xsl:if>
                <xsl:if test="transacao = 'L'">
                  <xsl:value-of select="substring-before(valor, '.')"/>
                </xsl:if>
              </RentalPrice>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <PropertyType>
          <xsl:if test="tipo = 'COBERTURA 2 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'COBERTURA 3 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'COBERTURA 4 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 1 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 2 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 3 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 4 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 5 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'SOBRADO 6 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.COND. FECHADO'">Residential / Condo</xsl:if>
          <xsl:if test="tipo = 'APTO. 1 DORMT.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'APTO. 2 DORMT.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'APTO. 3 DORMT.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'APTO. 4 DORMT.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'CHACARAS'">Residential / Farm/Ranch</xsl:if>
          <xsl:if test="tipo = 'FLAT'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'TERRENO'">Residential / Land/Lot</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 1 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 2 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 3 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 4 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 5 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 6 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 7 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.ALV. 8 DORM.'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'LANCAMENTO'">LANCAMENTO</xsl:if>
          <xsl:if test="tipo = 'TERR. EM COND. FECHADO'">Residential / Land/Lot</xsl:if>
          <xsl:if test="tipo = 'AREAS'">Residential / Land/Lot</xsl:if>
          <xsl:if test="tipo = 'SOBR.COND. FECHADO'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'RESID.MISTA 1 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MISTA 2 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MISTA 3 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MISTA 4 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MAD. 2 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MAD. 3 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'RESID.MAD. 5 DORM.'">Residential / Home</xsl:if>
          <xsl:if test="tipo = 'PREDIO COMERCIAL'">Commercial / Building</xsl:if>
          <xsl:if test="tipo = 'KITINETE'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo = 'LOJA'">Commercial / Retail</xsl:if>
          <xsl:if test="tipo = 'CONJ.COMERCIAL'">Commercial / Building</xsl:if>
          <xsl:if test="tipo = 'FAZENDAS'">Residential / Farm/Ranch</xsl:if>
          <xsl:if test="tipo = 'BARRACAO'">Commercial / Industrial</xsl:if>
          <xsl:if test="tipo = 'CASA COMERCIAL'">Commercial / Building</xsl:if>
          <xsl:if test="tipo = 'POUSADA'">Commercial / Building</xsl:if>
          <xsl:if test="tipo = 'PREDIO COMERCIAL'">Commercial / Building</xsl:if>
          <xsl:if test="tipo = 'PREDIO RESIDENCIAL'">Residential / Apartment</xsl:if>
          <xsl:if test="tipo != 'COBERTURA 2 DORM.' and tipo != 'COBERTURA 3 DORM.' and tipo != 'COBERTURA 4 DORM.' and tipo != 'SOBRADO 1 DORM.' and tipo != 'SOBRADO 2 DORM.' and tipo != 'SOBRADO 3 DORM.' and tipo != 'SOBRADO 4 DORM.' and tipo != 'SOBRADO 5 DORM.' and tipo != 'SOBRADO 6 DORM.' and tipo != 'RESID.COND. FECHADO' and tipo != 'APTO. 1 DORMT.' and tipo != 'APTO. 2 DORMT.' and tipo != 'APTO. 3 DORMT.' and tipo != 'APTO. 4 DORMT.' and tipo != 'CHACARAS' and tipo != 'FLAT' and tipo != 'TERRENO' and tipo != 'RESID.ALV. 1 DORM.' and tipo != 'RESID.ALV. 2 DORM.' and tipo != 'RESID.ALV. 3 DORM.' and tipo != 'RESID.ALV. 4 DORM.' and tipo != 'RESID.ALV. 5 DORM.' and tipo != 'RESID.ALV. 6 DORM.' and tipo != 'RESID.ALV. 7 DORM.' and tipo != 'RESID.ALV. 8 DORM.' and tipo != 'LANCAMENTO' and tipo != 'TERR. EM COND. FECHADO' and tipo != 'AREAS' and tipo != 'SOBR.COND. FECHADO' and tipo != 'RESID.MISTA 1 DORM.' and tipo != 'RESID.MISTA 2 DORM.' and tipo != 'RESID.MISTA 3 DORM.' and tipo != 'RESID.MISTA 4 DORM.' and tipo != 'RESID.MAD. 2 DORM.' and tipo != 'RESID.MAD. 3 DORM.' and tipo != 'RESID.MAD. 5 DORM.' and tipo != 'PREDIO COMERCIAL' and tipo != 'KITINETE' and tipo != 'LOJA' and tipo != 'CONJ.COMERCIAL' and tipo != 'FAZENDAS' and tipo != 'BARRACAO' and tipo != 'CASA COMERCIAL' and tipo != 'POUSADA' and tipo != 'PREDIO COMERCIAL' and tipo != 'PREDIO RESIDENCIAL'">
            <xsl:value-of select="tipo"/>
          </xsl:if>
        </PropertyType>
        <xsl:if test="area_total != '0,00' and area_total != '' and area_total !='0.00'">
        <LotArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_total, ',')">
                <xsl:call-template name="round_comma">
                  <xsl:with-param name="value" select="translate(area_total, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
				<xsl:call-template name="round_dot">
                  <xsl:with-param name="value" select="area_total"/>
				</xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
        </LotArea>
        </xsl:if>
        <xsl:if test="area_util != '0,00' and area_util != '' and area_util !='0.00'">
          <LivingArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_util, ',')">
                <xsl:call-template name="round_comma">
                  <xsl:with-param name="value" select="translate(area_util, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
		<xsl:call-template name="round_dot">
                  <xsl:with-param name="value" select="area_util"/>
		</xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
	 	  </LivingArea>
        </xsl:if>
        <xsl:if test="quartos != '0'">
	        <Bedrooms>
	          <xsl:value-of select="quartos"/>
	        </Bedrooms>
        </xsl:if>
		<xsl:if test="banheiros != '0'">
	        <Bathrooms>
	          <xsl:value-of select="banheiros"/>
	        </Bathrooms>
        </xsl:if>
        <xsl:if test="suites != '0'">
	        <Suites>
	          <xsl:value-of select="suites"/>
	        </Suites>
        </xsl:if>
        <Features>
          <!--NO HAY INFORMACION AL RESPECTO-->
        </Features>
        <xsl:if test="garagem != '0'">
	        <Garage>
	        	<xsl:value-of select="garagem"/>
	        </Garage>
        </xsl:if>
      </Details>
      <xsl:if test="fotos_imovel/foto != ''">
        <Media>
          <Item medium="image" primary="true">
            <xsl:value-of select="normalize-space(foto_principal)"/>
          </Item>
          <xsl:for-each select="fotos_imovel/foto">
            <Item medium="image">
              <xsl:value-of select="normalize-space(.)"/>
            </Item>
          </xsl:for-each>
        </Media>
      </xsl:if>
      <ContactInfo>
        <xsl:choose>
          <xsl:when test="nomeloja != ''">
            <Name>
              <xsl:value-of select="nomeloja"/>
            </Name>
            <Email>
              <xsl:value-of select="nomeloja"/>
            </Email>
            <AccountID>
              <xsl:value-of select="nomeloja"/>
            </AccountID>
          </xsl:when>
          <xsl:otherwise>
            <Name>
              <xsl:value-of select="email"/>
            </Name>
            <Email>
              <xsl:value-of select="email"/>
            </Email>
            <AccountID>
              <xsl:value-of select="nomeloja"/>
            </AccountID>
          </xsl:otherwise>
        </xsl:choose>
        <Website>Apolar</Website>
        <Telephone>Apolar</Telephone>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
