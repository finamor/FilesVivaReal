<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="fileName" select="''"/>
  <xsl:template name="round">
    <xsl:param name="value"/>
    <xsl:value-of select="substring-before($value, ',')"/>
  </xsl:template>
  <xsl:template name="imoveis" match="Imoveis">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>ZAP</Provider>
        <Email>zap@zap.com.br</Email>
      </Header>
      <Listings>
        <xsl:for-each select="Imovel">
          <xsl:call-template name="Listing"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template match="TotalImoveis"/>
  <xsl:template name="Listing" match="Imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
        <xsl:value-of select="CodigoImovel"/>
      </ListingID>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="PrecoVenda != '0,00' and PrecoVenda != '0.00' and PrecoVenda != '0' and PrecoVenda != ''">
            <xsl:choose>
              <xsl:when test="PrecoLocacaoTemporada != '0,00' and PrecoLocacaoTemporada != '0.00' and PrecoLocacaoTemporada != '0' and PrecoLocacaoTemporada != ''">Sale/Rent</xsl:when>
              <xsl:when test="PrecoTemporada != '0,00' and PrecoTemporada != '0.00' and PrecoTemporada != '0' and PrecoTemporada != ''">Sale/Rent</xsl:when>
              <xsl:when test="PrecoLocacao != '0,00' and PrecoLocacao != '0.00' and PrecoLocacao != '0' and PrecoLocacao != ''">Sale/Rent</xsl:when>
              <xsl:when test="PrecoAluguel != '0,00' and PrecoAluguel != '0.00' and PrecoAluguel != '0' and PrecoAluguel != ''">Sale/Rent</xsl:when>
              <xsl:otherwise>For Sale</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="PrecoLocacaoTemporada != '0,00' and PrecoLocacaoTemporada != '0.00' and PrecoLocacaoTemporada != '0' and PrecoLocacaoTemporada != ''">For Rent</xsl:when>
          <xsl:when test="PrecoTemporada != '0,00' and PrecoTemporada != '0.00' and PrecoTemporada != '0' and PrecoTemporada != ''">For Rent</xsl:when>
          <xsl:when test="PrecoLocacao != '0,00' and PrecoLocacao != '0.00' and PrecoLocacao != '0' and PrecoLocacao != ''">For Rent</xsl:when>
          <xsl:when test="PrecoAluguel != '0,00' and PrecoAluguel != '0.00' and PrecoAluguel != '0' and PrecoAluguel != ''">For Rent</xsl:when>
        </xsl:choose>
      </TransactionType>
      <Title>
        <!--       TituloImovel -->
        <xsl:choose>
          <xsl:when test="TituloImovel != ''">
            <xsl:value-of select="TituloImovel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(Cidade, ' - ', SubTipoImovel, ' - ', Bairro)"/>
          </xsl:otherwise>
        </xsl:choose>
      </Title>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>-</State>
        <City>
          <xsl:value-of select="Cidade"/>
        </City>
        <xsl:if test="Zona != '' ">
          <Zone>
            <xsl:value-of select="Zona"/>
          </Zone>
        </xsl:if>
        <Neighborhood>
          <xsl:value-of select="Bairro"/>
        </Neighborhood>
        <Address publiclyVisible="false">
          <xsl:value-of select="concat(Endereco, ' ')"/>
        </Address>
        <xsl:if test="Cep != '' ">
          <PostalCode>
            <xsl:value-of select="Cep"/>
          </PostalCode>
        </xsl:if>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="Observacao"/>
        </Description>
        <xsl:if test="PrecoVenda != '0,00' and PrecoVenda != '0.00' and PrecoVenda != '0' and PrecoVenda != ''">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(PrecoVenda, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoVenda, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="contains(PrecoVenda, '.')">
                <xsl:value-of select="translate(PrecoVenda, '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="PrecoVenda"/>
              </xsl:otherwise>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="PrecoLocacao != '0,00' and PrecoLocacao != '0.00' and PrecoLocacao != '0' and PrecoLocacao != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(PrecoLocacao, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoLocacao, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(PrecoLocacao, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="PrecoLocacaoTemporada != '0,00' and PrecoLocacaoTemporada != '0.00' and PrecoLocacaoTemporada != '0' and PrecoLocacaoTemporada != ''">
          <RentalPrice currency="BRL" period="Daily">
            <xsl:choose>
              <xsl:when test="contains(PrecoLocacaoTemporada, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoLocacaoTemporada, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(PrecoLocacaoTemporada, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="PrecoTemporada != '0,00' and PrecoTemporada != '0.00' and PrecoTemporada != '0' and PrecoTemporada != ''">
          <RentalPrice currency="BRL" period="Daily">
            <xsl:choose>
              <xsl:when test="contains(PrecoTemporada, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoTemporada, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(PrecoTemporada, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="PrecoAluguel != '0,00' and PrecoAluguel != '0.00' and PrecoAluguel != '0' and PrecoAluguel != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:choose>
              <xsl:when test="contains(PrecoAluguel, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoAluguel, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(PrecoAluguel, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="PrecoCondominio != '0,00' and PrecoCondominio != '0.00' and PrecoCondominio != '0' and PrecoCondominio != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(PrecoCondominio, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(PrecoCondominio, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(PrecoCondominio, '.','')"/>
              </xsl:otherwise>
            </xsl:choose>
          </PropertyAdministrationFee>
        </xsl:if>
        <PropertyType>
          <xsl:variable name="usoComercial" select="'Comercial / '"/>
          <xsl:variable name="usoResidencial" select="'Residencial / '"/>
          <xsl:choose>
            <xsl:when test="CategoriaImovel = 'Cobertura'">
              <xsl:value-of select="'Residential / Penthouse'"/>
            </xsl:when>
            <xsl:when test="contains(CategoriaImovel, 'Sobrado')">
              <xsl:value-of select="'Residencial / Sobrado'"/>
            </xsl:when>
            <xsl:when test="Finalidade = 'C'">
              <xsl:value-of select="concat(usoComercial, TipoImovel)"/>
            </xsl:when>
            <xsl:when test="Finalidade = 'R'">
              <xsl:value-of select="concat(usoResidencia, TipoImovel)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="SubTipoImovel != ''">
                  <xsl:value-of select="concat(TipoImovel, ' / ', SubTipoImovel)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="TipoImovel"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyType>
        <LotArea unit="square metres">
          <xsl:choose>
            <xsl:when test="contains(AreaTotal, ',')">
              <xsl:call-template name="round">
                <xsl:with-param name="value" select="translate(AreaTotal, '.', '')"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="translate(AreaTotal, '.', '')"/>
            </xsl:otherwise>
          </xsl:choose>
        </LotArea>
        <xsl:if test="AreaUtil != '0,00' and AreaUtil != '0' and AreaUtil != ''">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(AreaUtil, ',')">
                <xsl:call-template name="round">
                  <xsl:with-param name="value" select="translate(AreaUtil, '.', '')"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="AreaUtil"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="QtdDormitorios != '0' and QtdDormitorios != ''">
          <Bedrooms>
            <xsl:value-of select="QtdDormitorios"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="QtdBanheiros != '0' and QtdBanheiros != ''">
          <Bathrooms>
            <xsl:value-of select="QtdBanheiros"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="QtdSuites != '0' and QtdSuites != ''">
          <Suites>
            <xsl:value-of select="QtdSuites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="QtdVagas != '0' and QtdVagas != ''">
          <Garage type="Parking Space">
            <xsl:value-of select="QtdVagas"/>
          </Garage>
        </xsl:if>
        <Features>
          <xsl:if test="Escritorio &gt; 0">
            <Feature>Study</Feature>
          </xsl:if>
          <xsl:if test="Esquina &gt; 0">
            <Feature>Corner Lot</Feature>
          </xsl:if>
          <xsl:if test="ArCondicionado &gt; 0">
            <Feature>Air Conditioning</Feature>
          </xsl:if>
          <xsl:if test="EstacionamentoVisitantes &gt; 0">
            <Feature>RV Parking</Feature>
          </xsl:if>
          <xsl:if test="Hidromassagem &gt; 0">
            <Feature>Jacuzzi/Hot Tub</Feature>
          </xsl:if>
          <xsl:if test="Jardim &gt; 0">
            <Feature>Garden</Feature>
          </xsl:if>
          <xsl:if test="Churrasqueira &gt; 0">
            <Feature>BBQ</Feature>
          </xsl:if>
          <xsl:if test="Lareira &gt; 0">
            <Feature>Fireplace</Feature>
          </xsl:if>
          <xsl:if test="Piscina &gt; 0">
            <Feature>Pool</Feature>
          </xsl:if>
          <xsl:if test="Quintal &gt; 0">
            <Feature>Backyard</Feature>
          </xsl:if>
          <xsl:if test="QtdElevador &gt; 0">
            <Feature>Elevator</Feature>
          </xsl:if>
          <xsl:if test="RedeTelefone &gt; 0">
            <Feature>Fully Wired</Feature>
          </xsl:if>
          <xsl:if test="SalaJantar &gt; 0">
            <Feature>Dining Room</Feature>
          </xsl:if>
          <xsl:if test="Sauna &gt; 0">
            <Feature>Sauna</Feature>
          </xsl:if>
          <xsl:if test="Terraco &gt; 0 or Varanda &gt; 0">
            <Feature>Balcony/Terrace</Feature>
          </xsl:if>
          <xsl:if test="TVCabo &gt; 0">
            <Feature>Cable Television</Feature>
          </xsl:if>
          <xsl:if test="AreaServico &gt; 0 or WCEmpregada &gt; 0">
            <Feature>Maid's Quarters</Feature>
          </xsl:if>
          <xsl:if test="SegurancaInterna &gt; 0">
            <Feature>TV Security</Feature>
          </xsl:if>
          <xsl:if test="Playground &gt; 0">
            <Feature>Playground</Feature>
          </xsl:if>
          <xsl:if test="QuadraPoliEsportiva &gt; 0">
            <Feature>Sports Court</Feature>
          </xsl:if>
          <xsl:if test="SalaGinastica &gt; 0">
            <Feature>Gym</Feature>
          </xsl:if>
          <xsl:if test="SalaoJogos &gt; 0">
            <Feature>Game room</Feature>
          </xsl:if>
          <xsl:if test="Despensa &gt; 0">
            <Feature>Number of stories</Feature>
          </xsl:if>
          <xsl:if test="Interfone &gt; 0">
            <Feature>Intercom</Feature>
          </xsl:if>
          <xsl:if test="Mobiliado &gt; 0">
            <Feature>Furnished</Feature>
          </xsl:if>
          <xsl:if test="Lareira &gt; 0">
            <Feature>Fireplace</Feature>
          </xsl:if>
          <xsl:if test="LavanderiaColetiva &gt; 0">
            <Feature>Laundry</Feature>
          </xsl:if>
          <xsl:if test="Piscina &gt; 0">
            <Feature>Pool</Feature>
          </xsl:if>
          <xsl:if test="QuadraTenis &gt; 0">
            <Feature>Tennis court</Feature>
          </xsl:if>
          <xsl:if test="Acesso24Horas &gt; 0">
            <Feature>Controlled Access</Feature>
          </xsl:if>
        </Features>
      </Details>
      <Media>
        <xsl:if test="video != ''">
          <Item medium="video">
            <xsl:value-of select="video"/>
          </Item>
        </xsl:if>
        <xsl:for-each select="Videos/Video">
          <Item medium="video">
            <xsl:value-of select="normalize-space(URLArquivo)"/>
          </Item>
        </xsl:for-each>
        <xsl:for-each select="Fotos/Foto">
          <xsl:sort select="Principal" order="descending"/>
          <Item medium="image">
            <xsl:if test="Principal &gt; 0">
              <xsl:attribute name="primary">true</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="contains(URLArquivo, '/')">
                <xsl:value-of select="URLArquivo"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat($emailFileName, URLArquivo)"/>
              </xsl:otherwise>
            </xsl:choose>
          </Item>
        </xsl:for-each>
      </Media>
      <ContactInfo>
        <Email>
          <xsl:choose>
            <xsl:when test="CodigoCliente != ''">
              <xsl:value-of select="CodigoCliente"/>
            </xsl:when>
            <xsl:when test="Codigocliente != ''">
              <xsl:value-of select="Codigocliente"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="EmailCliente"/>
            </xsl:otherwise>
          </xsl:choose>
        </Email>
        <Name>
          <xsl:choose>
            <xsl:when test="CodigoCliente != ''">
              <xsl:value-of select="CodigoCliente"/>
            </xsl:when>
            <xsl:when test="Codigocliente != ''">
              <xsl:value-of select="Codigocliente"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="EmailCliente"/>
            </xsl:otherwise>
          </xsl:choose>
        </Name>
      </ContactInfo>
      <xsl:choose>
        <xsl:when test="EmDestaque = '1'">
          <Featured>true</Featured>
        </xsl:when>
        <xsl:when test="destaque = '1'">
          <Featured>true</Featured>
        </xsl:when>
      </xsl:choose>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
