<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xls="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="fileName" select="''"/>
  <xsl:template name="round">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, '.')"/>
  </xsl:template>
  <xsl:template name="imoveis" match="indicadordeimoveis">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>CASASOFT</Provider>
        <Email>casasoft@casasoft.net.br</Email>
      </Header>
      <Listings>
        <xsl:for-each select="fichaimoveis/imovel">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Listing" match="fichaimoveis/imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <xsl:if test="referencia != 0 and referencia != ''">
        <ListingID>
          <xsl:value-of select="referencia"/>
        </ListingID>
      </xsl:if>
      <xsl:if test="referencia != 0 and referencia != ''">
        <Title>
          <xsl:value-of select="concat(tipoimovel, ' ', bairro)"/>
        </Title>
      </xsl:if>
      <TransactionType>
        <xsl:if test="contains(imovelpara, 'L')">For Rent</xsl:if>
        <xsl:if test="contains(imovelpara, 'V')">For Sale</xsl:if>
      </TransactionType>
      <!--Nova validação Location -->
      <Location>
        <xsl:choose>
          <xsl:when test="endereco/logradouro!='' and endereco/numero != '' and endereco/visivel = 'S'">
            <xsl:attribute name="displayAddress">All</xsl:attribute>
          </xsl:when>
          <xsl:when test="endereco/logradouro!='' and endereco/numero = '' and endereco/visivel = 'S'">
            <xsl:attribute name="displayAddress">Street</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="displayAddress">Neighborhood</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:attribute name="abbreviation">
            <xsl:value-of select="uf"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="uf = 'PR'">
              <xsl:text>Parana</xsl:text>
            </xsl:when>
            <xsl:when test="uf = 'PE'">
              <xsl:text>Pernambuco</xsl:text>
            </xsl:when>
            <xsl:when test="uf = 'SC'">
              <xsl:text>Santa Catarina</xsl:text>
            </xsl:when>
            <xsl:when test="uf = 'SP'">
              <xsl:text>Sao Paulo</xsl:text>
            </xsl:when>
          </xsl:choose>
        </State>
        <City>
          <xsl:value-of select="cidade"/>
        </City>
        <Neighborhood>
          <xsl:value-of select="bairro"/>
        </Neighborhood>
        <Address>
          <xls:value-of select="endereco/logradouro"/>
        </Address>
        <StreetNumber>
          <xsl:value-of select="endereco/numero"/>
        </StreetNumber>
        <PostalCode>
          <xsl:value-of select="cep"/>
        </PostalCode>
        <Latitude>
          <xsl:value-of select="endereco/latitude"/>
        </Latitude>
        <Longitude>
          <xsl:value-of select="endereco/longitude"/>
        </Longitude>
      </Location>
      <Details>
        <Description>
          <xsl:if test="observacao != ''">
            <xsl:value-of select="observacao"/>
          </xsl:if>
          <xsl:if test="observacao = ''">
            <xsl:value-of select="concat(tipoimovel, ' ', bairro)"/>
          </xsl:if>
        </Description>
        <xsl:choose>
          <xsl:when test="imovelpara = 'V'">
            <xsl:if test="valortotal != '0.00' and valortotal != '0' and valortotal != ''">
              <ListPrice currency="BRL">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="valortotal"/>
                </xsl:call-template>
              </ListPrice>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="valorlocacao != '0.00' and valorlocacao != '0' and valorlocacao != ''">
              <RentalPrice currency="BRL">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="valorlocacao"/>
                </xsl:call-template>
              </RentalPrice>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="valorcondominio != '0.00' and valorcondominio != '0' and valorcondominio != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:call-template name="round">
              <xsl:with-param name="value" select="valorcondominio"/>
            </xsl:call-template>
          </PropertyAdministrationFee>
        </xsl:if>
        <xsl:if test="valoriptuimovel != '0.00' and valoriptuimovel != '0' and valoriptuimovel != ''">
          <YearlyTax currency="BRL">
            <xsl:call-template name="round">
              <xsl:with-param name="value" select="valoriptuimovel"/>
            </xsl:call-template>
          </YearlyTax>
        </xsl:if>
        <PropertyType>
          <xsl:choose>
            <xsl:when test="tipoimovel/@tipopadrao = '1'">
              <xsl:text>Residential / Apartment</xsl:text>
            </xsl:when>
            <!-- Apartamento -->
            <xsl:when test="tipoimovel/@tipopadrao = '2'">
              <xsl:text>Commercial / Industrial</xsl:text>
            </xsl:when>
            <!-- Barracao/Galpao -->
            <xsl:when test="tipoimovel/@tipopadrao = '3'">
              <xsl:text>Commercial / Office</xsl:text>
            </xsl:when>
            <!-- Cjto Comercial/Sala -->
            <xsl:when test="tipoimovel/@tipopadrao = '4'">
              <xsl:text>Commercial / Loja</xsl:text>
            </xsl:when>
            <!-- Loja -->
            <xsl:when test="tipoimovel/@tipopadrao = '5'">
              <xsl:text>Residential / Home</xsl:text>
            </xsl:when>
            <!-- Casa Residencial -->
            <xsl:when test="tipoimovel/@tipopadrao = '6'">
              <xsl:text>Commercial / Building</xsl:text>
            </xsl:when>
            <!-- Casa Comercial -->
            <xsl:when test="tipoimovel/@tipopadrao = '7'">
              <xsl:text>Residential / Sobrado</xsl:text>
            </xsl:when>
            <!-- Sobrado -->
            <xsl:when test="tipoimovel/@tipopadrao = '8'">
              <xsl:text>Residential / Land Lot</xsl:text>
            </xsl:when>
            <!-- Terreno -->
            <xsl:when test="tipoimovel/@tipopadrao = '9'">
              <xsl:text>Residential / Kitnet</xsl:text>
            </xsl:when>
            <!-- Kitinet -->
            <xsl:when test="tipoimovel/@tipopadrao = '10'">
              <xsl:text>Commercial / Industrial</xsl:text>
            </xsl:when>
            <!-- Garagem -->
            <xsl:when test="tipoimovel/@tipopadrao = '11'">
              <xsl:text>Residential / Farm Ranch</xsl:text>
            </xsl:when>
            <!-- Chacara -->
            <xsl:when test="tipoimovel/@tipopadrao = '12'">
              <xsl:text>Residential / Land Lot</xsl:text>
            </xsl:when>
            <!-- Area -->
            <xsl:when test="tipoimovel/@tipopadrao = '13'">
              <xsl:text>Commercial / Land Lot</xsl:text>
            </xsl:when>
            <!-- Area Industrial -->
            <xsl:when test="tipoimovel/@tipopadrao = '14'">
              <xsl:text>Commercial / Building</xsl:text>
            </xsl:when>
            <!-- Predio Comercial -->
            <xsl:when test="tipoimovel/@tipopadrao = '15'">
              <xsl:text>Commercial / Land Lot</xsl:text>
            </xsl:when>
            <!-- Estacionamento -->
            <xsl:when test="tipoimovel/@tipopadrao = '16'">
              <xsl:text>Residential / Flat</xsl:text>
            </xsl:when>
            <!-- Loft -->
            <xsl:when test="tipoimovel/@tipopadrao = '17'">
              <xsl:text>Commercial / Business</xsl:text>
            </xsl:when>
            <!-- Ponto de Comercio -->
            <xsl:when test="tipoimovel/@tipopadrao = '18'">
              <xsl:text>Commercial / Agricultural</xsl:text>
            </xsl:when>
            <!-- Fazenda -->
            <xsl:when test="tipoimovel/@tipopadrao = '250'">
              <xsl:text>Residential / Penthouse</xsl:text>
            </xsl:when>
            <!-- Cobertura -->
          </xsl:choose>
        </PropertyType>
        <xsl:if test="areatotal != '0.00' and areatotal != '0' and areatotal != ''">
          <LotArea unit="square metres">
            <xsl:call-template name="round">
              <xsl:with-param name="value" select="areatotal"/>
            </xsl:call-template>
          </LotArea>
        </xsl:if>
        <xsl:if test="areautil != '0.00' and areautil != '0' and areautil != ''">
          <ConstructedArea unit="square metres">
            <xsl:call-template name="round">
              <xsl:with-param name="value" select="areautil"/>
            </xsl:call-template>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="caracteristicaspadrao/quarto != '0' and caracteristicaspadrao/quarto != ''">
          <Bedrooms>
            <xsl:value-of select="caracteristicaspadrao/quarto"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')]">
          <Bathrooms>
            <xsl:choose>
              <xsl:when test="caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')] = 'Sim' or      caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')] = 'sim' or     caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')] = 'C/ BWC'">
                <xsl:text>1</xsl:text>
              </xsl:when>
              <xsl:when test="caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')] = 'Nao'">
                <xsl:text>0</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="caracteristicasadicionais/caracteristica[contains(@nome, 'BWC')]"/>
              </xsl:otherwise>
            </xsl:choose>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Su')] != ''">
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Su')] != 'Sim'">
            <Suites>
              <xsl:value-of select="caracteristicasadicionais/caracteristica[contains(@nome, 'Su')]"/>
            </Suites>
          </xsl:if>
        </xsl:if>
        <xsl:if test="caracteristicaspadrao/suite != '0' and caracteristicaspadrao/suite != ''">
          <Suites>
            <xsl:value-of select="caracteristicaspadrao/suite"/>
          </Suites>
        </xsl:if>
        <xsl:if test="caracteristicaspadrao/garagem != 'Sim' and caracteristicaspadrao/garagem != 'Não'">
          <Garage type="Parking Space">
            <xsl:value-of select="substring-before(caracteristicaspadrao/garagem, ' vaga')"/>
          </Garage>
        </xsl:if>
        <Features>
          <!-- Sistema de alarme                Alarm System -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Alarm')]">
            <Feature>Alarm System</Feature>
          </xsl:if>
          <!-- Aquecimento - Heating -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Aquecimento')]">
            <Feature>Heating</Feature>
          </xsl:if>
          <!-- Ar condicionado - Air Conditioning -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Ar Cond')]">
            <Feature>Air Conditioning</Feature>
          </xsl:if>
          <!-- Area Jardim                  Garden  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'jardim')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Jardim')] or caracteristicasadicionais/caracteristica[contains(@nome, 'JARDIM')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Jardins')]">
            <Feature>Garden</Feature>
          </xsl:if>
          <!-- Churrasqueira                  BBQ   -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Churr')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Churasq')]">
            <Feature>BBQ</Feature>
          </xsl:if>
          <!-- Circuito de segurança              TV Security  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Interno TV')]">
            <Feature>TV Security</Feature>
          </xsl:if>
          <!-- Conjunto cerrado               Gated Community  - Condomínio fechado  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Cond. fechado')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Cond. Fechado')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Condominio')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Condomínio')]">
            <Feature>Gated Community</Feature>
          </xsl:if>
          <!-- Cozinha                      Kitchen  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Cozinha')]">
            <Feature>Kitchen</Feature>
          </xsl:if>
          <!-- Elevador                   Elevator  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'levador')]">
            <Feature>Elevator</Feature>
          </xsl:if>
          <!-- Garagem                      RV Parking  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Garagem')] or caracteristicasadicionais/caracteristica[contains(@nome, 'garage')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Garagens')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Gar.Automática')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Gar. Automatica')]">
            <Feature>RV Parking</Feature>
          </xsl:if>
          <!-- Lareira                      Fireplace  -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Lareira')]">
            <Feature>Fireplace</Feature>
          </xsl:if>
          <!-- Interfone                    Intercom    -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Lareira')]">
            <Feature>Intercom</Feature>
          </xsl:if>
          <!-- Piscina                      Pool    -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Piscina')]">
            <Feature>Pool</Feature>
          </xsl:if>
          <!-- Playground                   Playground    -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Play Gorund')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Playgrond')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Playground')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Play ground')] or caracteristicasadicionais/caracteristica[contains(@nome, 'PlayGround')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Play Ground')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Play-Ground')]">
            <Feature>Playground</Feature>
          </xsl:if>
          <!-- Quadra de tênis                 Tennis court -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Quadra de Tênis')] or caracteristicasadicionais/caracteristica[contains(@nome, 'Quadra de Tenis')]">
            <Feature>Tennis court</Feature>
          </xsl:if>
          <!-- Quintal                     Backyard -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'uintal')]">
            <Feature>Backyard</Feature>
          </xsl:if>
          <!-- Sacada                      Balcony/Terrace -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Sacada')]">
            <Feature>Balcony/Terrace</Feature>
          </xsl:if>
          <!-- Segurança 24 horas                24 Hour Security -->
          <xsl:if test="caracteristicasadicionais/caracteristica[contains(@nome, 'Seg. 24 hs')]">
            <Feature>24 Hour Security</Feature>
          </xsl:if>
        </Features>
      </Details>
      <xsl:if test="galeriaimagens/fotos/foto != ''">
        <Media>
          <xsl:for-each select="galeriaimagens/videos/video">
            <Item medium="video">
              <xsl:value-of select="normalize-space(urlarquivo)"/>
            </Item>
          </xsl:for-each>
          <xsl:for-each select="galeriaimagens/fotos/foto">
            <xsl:sort select="principal" order="descending"/>
            <Item medium="image">
              <xsl:if test="principal = 'S'">
                <xsl:attribute name="primary">true</xsl:attribute>
              </xsl:if>
              <xsl:if test="contains(urlarquivo, '/')">
                <xsl:value-of select="urlarquivo"/>
              </xsl:if>
            </Item>
          </xsl:for-each>
        </Media>
      </xsl:if>
      <ContactInfo>
        <Email>
          <xsl:if test="/indicadordeimoveis/dadosimobiliaria/email != '0' and /indicadordeimoveis/dadosimobiliaria/email != ''">
            <xsl:value-of select="/indicadordeimoveis/dadosimobiliaria/email"/>
          </xsl:if>
        </Email>
        <Name>
          <xsl:if test="/indicadordeimoveis/dadosimobiliaria/nome != '0' and /indicadordeimoveis/dadosimobiliaria/nome != ''">
            <xsl:value-of select="/indicadordeimoveis/dadosimobiliaria/nome"/>
          </xsl:if>
        </Name>
      </ContactInfo>
      <xsl:if test="destaque = 'S'">
        <Featured>true</Featured>
      </xsl:if>
    </Listing>
  </xsl:template>
</xsl:stylesheet>