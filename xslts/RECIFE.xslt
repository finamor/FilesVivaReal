<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="price">
    <xsl:param name="preco"/>
    <xsl:value-of select="substring-before($preco, '.')"/>
  </xsl:template>
  <xsl:template name="listings" match="Imoveis">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync">
      <Header>
        <Provider>Site Secia</Provider>
        <Email>contato@sitesecia.com.br</Email>
      </Header>
      <Listings>
        <xsl:for-each select="Imovel">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="Imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="referencia"/>
      </ListingID>
      <Title>
        <xsl:value-of select="concat(estado, ' - ', cidade)"/>
      </Title>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="finalidade = '1'">For Sale</xsl:when>
          <xsl:when test="finalidade = '4'">For Sale</xsl:when>
          <xsl:when test="finalidade = '0'">For Rent</xsl:when>
          <xsl:when test="finalidade = '1, 2'">Sale/Rent</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="finalidade"/>
          </xsl:otherwise>
        </xsl:choose>
      </TransactionType>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="estado"/>
        </State>
        <City>
          <xsl:value-of select="cidade"/>
        </City>
        <xsl:if test="bairro != '' ">
          <Neighborhood>
            <xsl:value-of select="bairro"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="endereco != '' ">
          <Address publiclyVisible="false">
            <xsl:value-of select="endereco"/>
            <xsl:choose>
              <xsl:when test="numero != '' ">
                <xsl:value-of select="numero"/>
              </xsl:when>
              <xsl:when test="complemento != '' ">
                <xsl:value-of select="complemento"/>
              </xsl:when>
            </xsl:choose>
          </Address>
        </xsl:if>
        <xsl:if test="cep != '' ">
          <PostalCode>
            <xsl:value-of select="cep"/>
          </PostalCode>
        </xsl:if>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="descricao"/>
        </Description>
        <PropertyType>
          <xsl:choose>
            <xsl:when test="tipo_imoveis = '1'">APARTAMENTO</xsl:when>
            <xsl:when test="tipo_imoveis = '2'">AREA</xsl:when>
            <xsl:when test="tipo_imoveis = '3'">CASA</xsl:when>
            <xsl:when test="tipo_imoveis = '4'">CASA COMERCIAL</xsl:when>
            <xsl:when test="tipo_imoveis = '5'">CASA GEMINADA</xsl:when>
            <xsl:when test="tipo_imoveis = '6'">CASA DE PRAIA</xsl:when>
            <xsl:when test="tipo_imoveis = '7'">CHACARA</xsl:when>
            <xsl:when test="tipo_imoveis = '8'">COBERTURA</xsl:when>
            <xsl:when test="tipo_imoveis = '9'">EDICULA</xsl:when>
            <xsl:when test="tipo_imoveis = '10'">FLAT/LOFT</xsl:when>
            <xsl:when test="tipo_imoveis = '11'">FUNDO DE COMERCIO</xsl:when>
            <xsl:when test="tipo_imoveis = '12'">GALPAO/DEPOSITO</xsl:when>
            <xsl:when test="tipo_imoveis = '13'">KITCHENETTE</xsl:when>
            <xsl:when test="tipo_imoveis = '14'">PAVIMENTO TERREO</xsl:when>
            <xsl:when test="tipo_imoveis = '15'">PREDIO INTEIRO</xsl:when>
            <xsl:when test="tipo_imoveis = '16'">SALA COMERCIAL</xsl:when>
            <xsl:when test="tipo_imoveis = '17'">SITIO</xsl:when>
            <xsl:when test="tipo_imoveis = '18'">SOBRADO</xsl:when>
            <xsl:when test="tipo_imoveis = '19'">TERRENO</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="tipo_imoveis"/>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyType>
        <xsl:if test="area_terreno != '0,00' and area_terreno != ''">
          <LotArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_terreno, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(area_terreno, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(area_terreno, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LotArea>
        </xsl:if>
        <xsl:if test="area_construida != '0,00' and area_construida != ''">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_construida, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(area_construida, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(area_construida, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="area_util != '0,00' and area_util != ''">
          <LivingArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(area_util, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(area_util, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(area_util, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </LivingArea>
        </xsl:if>
        <xsl:if test="preco_venda != '0,00' and preco_venda != ''">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(preco_venda, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(preco_venda, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(preco_venda, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="valor_aluguel != '0,00' and valor_aluguel != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(valor_aluguel, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(valor_aluguel, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(valor_aluguel, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="valor_condominio != '0,00' and valor_condominio != '0.00' and valor_condominio != '0' and valor_condominio != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(valor_condominio, '.')">
                <xsl:call-template name="price">
                  <!-- with-param passa o parametro para o template chamado - translate deleta os pontos -->
                  <xsl:with-param name="preco" select="translate(valor_condominio, ',', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(valor_condominio, ',', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </PropertyAdministrationFee>
        </xsl:if>
        <xsl:if test="dormitorios &gt; '0' and dormitorios &lt; '30'">
          <Bedrooms>
            <xsl:value-of select="dormitorios"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="banheiros &gt; '0' and banheiros &lt; '30'">
          <Bathrooms>
            <xsl:value-of select="banheiros"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="suites &gt; '0' and suites &lt; '30'">
          <Suites>
            <xsl:value-of select="suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="vagas_garagem &gt; '0' and vagas_garagem &lt; '30'">
          <Garage type="Parking Space">
            <xsl:value-of select="vagas_garagem"/>
          </Garage>
        </xsl:if>
      </Details>
      <xsl:if test="Fotos/foto_gde != ''">
      <Media>
        <xsl:for-each select="Fotos/foto_gde">
          <Item medium="image">
            <xsl:choose>
              <xsl:when test="@principal != 'não'">
                <xsl:attribute name="primary">true</xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </Item>
        </xsl:for-each>
      </Media>
      </xsl:if>
      <ContactInfo>
        <Name>
          <xsl:value-of select="EmailCliente"/>
        </Name>
        <Email>
          <xsl:value-of select="EmailCliente"/>
        </Email>
      </ContactInfo>
      <xsl:if test="EmDestaque = '1'">
        <Featured>true</Featured>
      </xsl:if>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
