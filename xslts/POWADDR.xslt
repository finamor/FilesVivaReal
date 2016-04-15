<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="fileName" select="''"/>
  <xsl:template name="round">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, ',')"/>
  </xsl:template>
  <xsl:template name="propertyTYpe">
    <xsl:param name="property"/>
    <xsl:choose>
      <xsl:when test="$property = 'Apartamento'">
        <xsl:value-of select="concat('Residencial / ', $property)"/>
      </xsl:when>
      <xsl:when test="$property = 'Área'">
        <xsl:value-of select="concat('Comercial / ', $property)"/>
      </xsl:when>
      <xsl:when test="$property = 'Barracão / Galpão'">
        <xsl:value-of select="concat('Comercial / ', translate($property, ' / ', ' '))"/>
      </xsl:when>
      <xsl:when test="$property = 'Casa'">
        <xsl:value-of select="concat('Residencial / ', $property)"/>
      </xsl:when>
      <xsl:when test="$property = 'Lote / Terreno'">
        <xsl:value-of select="concat('Residencial / ', translate($property, ' / ', ' '))"/>
      </xsl:when>
      <xsl:when test="$property = 'Sítio e Chácara'">
        <xsl:value-of select="concat('Residencial / ', $property)"/>
      </xsl:when>
      <xsl:when test="$property = 'Sobrado'">
        <xsl:value-of select="concat('Residencial / ', $property)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$property" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="imoveis" match="pow">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
    <Header>
      <Provider>POW Internet</Provider>
      <Email>comercial@pow.com.br</Email>
      <ContactName>Piazzetta</ContactName>
      <Telephone>(41) 3382-1581</Telephone>
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
        <xsl:value-of select="id"/>
      </ListingID>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="venda = '1' and locacao = '0' and temporada = '0'">For Sale</xsl:when>
          <xsl:when test="venda = '1' and locacao = '1' and temporada = '0'">Sale/Rent</xsl:when>
          <xsl:when test="venda = '1' and locacao = '0' and teporada = '1'">Sale/Rent</xsl:when>
          <xsl:when test="venda = '1' and locacao = '1' and temporada = '1'">Sale/Rent</xsl:when>
          <xsl:when test="venda = '0' and locacao = '1' and temporada = '0'">For Rent</xsl:when>
        </xsl:choose>
      </TransactionType>
      <xsl:if test="destaque_tipo = '1'">
        <Featured>true</Featured>
      </xsl:if>
      <xsl:if test="cadastro != ''">
        <ListDate><xsl:value-of select="concat(substring(cadastro, 7, 4 ),'-',substring(cadastro, 4,2), '-',substring(cadastro,1,2),'T00:00:00')"/></ListDate>
      </xsl:if>
      <xsl:if test="atualizacao != ''">
        <LastUpdateDate><xsl:value-of select="concat(substring(atualizacao , 7, 4 ),'-',substring(atualizacao , 4,2), '-',substring(atualizacao ,1,2),'T00:00:00')"/></LastUpdateDate>
      </xsl:if>
      <Title>
        <xsl:choose>
          <xsl:when test="nome_imovel != ''">
            <xsl:value-of select="nome_imovel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(cidade, ' - ', tipoimovel, ' - ', bairro)"/>
          </xsl:otherwise>
        </xsl:choose>
      </Title>
      <xsl:if test="fotos/foto != ''">
        <Media>
          <xsl:if test="video != ''">
            <Item medium="video">
              <xsl:value-of select="video"/>
            </Item>
          </xsl:if>
          <xsl:for-each select="fotos/foto">
            <Item medium="image">
              <xsl:if test="foto_principal &gt; 0">
                <xsl:attribute name="primary">true</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="caption"><xsl:value-of select="foto_legenda"/></xsl:attribute>
              <xsl:choose>
                <xsl:when test="contains(foto_url, '/')">
                  <xsl:value-of select="foto_url"/>
                </xsl:when>
              </xsl:choose>
            </Item>
          </xsl:for-each>
        </Media>
      </xsl:if>
      <Details>
        <Description>
          <xsl:value-of select="descricao"/>
        </Description>
        <xsl:if test="preco_venda != '0,00' and preco_venda != '0.00' and preco_venda != '0' and preco_venda != ''">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(preco_venda, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(substring-before(preco_venda, '.'), '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(preco_venda, '.'), '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="preco_locacao != '0,00' and preco_locacao != '0.00' and preco_locacao != '0' and preco_locacao != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(preco_locacao, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(substring-before(preco_locacao, '.'), '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(preco_locacao, '.'), '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="preco_temporada != '0,00' and preco_temporada != '0.00' and preco_temporada != '0' and preco_temporada != ''">
          <RentalPrice currency="BRL" period="Daily">
            <xsl:choose>
              <xsl:when test="contains(preco_temporada, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(substring-before(preco_temporada, '.'), '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(preco_temporada, '.'), '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="veicular != ''">
          <AvailableDate><xsl:value-of select="concat(substring(veicular, 7, 4 ),'-',substring(veicular, 4, 2), '-',substring(veicular, 1, 2),'T00:00:00')"/></AvailableDate>
        </xsl:if>
        <xsl:if test="condominio_valor != '0,00' and condominio_valor != '0.00' and condominio_valor != '0' and condominio_valor != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(condominio_valor, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(substring-before(condominio_valor, '.'), '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(condominio_valor, '.'), '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </PropertyAdministrationFee>
        </xsl:if>
        <xsl:if test="iptu != '0,00' and iptu != '0.00' and iptu != '0' and iptu != ''">
          <YearlyTax currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(iptu, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(iptu, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(iptu, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </YearlyTax>
        </xsl:if>
        <PropertyType>
          <xsl:choose>
            <xsl:when test="tipoimovel != ''">
              <xsl:call-template name="propertyTYpe">
                <xsl:with-param name="property" select="tipoimovel"/>
              </xsl:call-template>
            </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="tipo"/>
          </xsl:otherwise>
          </xsl:choose>
        </PropertyType>
        <xsl:if test="area_terreno != '0,00' and area_terreno != '0' and area_terreno != ''">
          <LotArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_terreno, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="substring-before(area_terreno, '.')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-before(area_terreno,'.')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LotArea>
        </xsl:if>
        <xsl:if test="area != '0,00' and area != '0' and area != ''">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="substring-before(area, '.')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-before(area, '.')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="area_util != '0,00' and area_util != '0' and area_util != ''">
          <LivingArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_util, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="substring-before(area_util, '.')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="substring-before(area_util, '.')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LivingArea>
        </xsl:if>
        <xsl:if test="quartos != '0' and quartos != ''">
          <Bedrooms>
           <xsl:value-of select="quartos"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="banheiro != '0' and banheiro != ''">
          <Bathrooms>
            <xsl:value-of select="banheiro"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="suites != '0' and suites != ''">
          <Suites>
            <xsl:value-of select="suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="vagas != '0' and vagas != ''">
          <Garage type="Parking Space">
            <xsl:value-of select="vagas"/>
          </Garage>
        </xsl:if>
        <Features>
          <xsl:if test="vagas &gt; 0">
            <Feature>RV Parking</Feature>
          </xsl:if>
        </Features>
      </Details>
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
        <xsl:if test="endereco != ''">
          <Address publiclyVisible="true">
            <xsl:choose>
              <xsl:when test="endereco != '' and numero !=''">
                <xsl:value-of select="concat(endereco,', ', numero)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="endereco"/>
              </xsl:otherwise>
            </xsl:choose>
          </Address>
        </xsl:if>
        <xsl:if test="cep != '' ">
          <PostalCode>
            <xsl:value-of select="cep"/>
          </PostalCode>
        </xsl:if>
        <xsl:if test="latitude != ''">
          <Latitude>
            <xsl:value-of select="latitude"/>
          </Latitude>
        </xsl:if>
        <xsl:if test="longitude != ''">
          <Longitude>
            <xsl:value-of select="longitude"/>
          </Longitude>
        </xsl:if>
      </Location>
      <ContactInfo>
        <Name><xsl:value-of select="empresa_nome_fantasia"/></Name>
        <Email><xsl:value-of select="empresa_contato_email"/></Email>
        <Telephone><xsl:value-of select="empresa_contato_telefone"/></Telephone>
        <Website>
          <xsl:value-of select="empresa_dominio"></xsl:value-of>
        </Website>
        <Location>
          <Country abbreviation="BR">Brasil</Country>
          <State>
            <xsl:value-of select="empresa_uf"/>
          </State>
          <City>
            <xsl:value-of select="empresa_cidade"/>
          </City>
          <Neighborhood>
            <xsl:value-of select="empresa_bairro"/>
          </Neighborhood>
          <Address publiclyVisible="false">
            <xsl:value-of select="empresa_endereco"/>
          </Address>
          <PostalCode>
            <xsl:value-of select="empresa_cep"/>
          </PostalCode>
          <Latitude>
            <xsl:value-of select="empresa_latitude"/>
          </Latitude>
          <Longitude>
            <xsl:value-of select="empresa_longitude"/>
          </Longitude>
        </Location>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>