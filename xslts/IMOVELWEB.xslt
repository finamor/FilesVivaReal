<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="fileName" select="''"/>
  <xsl:template name="imoveis" match="OfertasImoveis">
    <ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>ImovelWeb</Provider>
        <Email>
          <xsl:choose>
            <xsl:when test="Anunciante/Email != ''">
              <xsl:value-of select="Anunciante/Email"/>
            </xsl:when>
            <xsl:otherwise>
              falecom@locattoimoveis.com.br
            </xsl:otherwise>
          </xsl:choose>
        </Email>
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
        <xsl:value-of select="@Referencia"/>
      </ListingID>
      <Title>
        <xsl:value-of select="concat(Endereco/UF, ' - ', Endereco/Cidade)"/>
        <xsl:if test="Bairro != ''">
                 - <xsl:value-of select="Bairro"/>
</xsl:if>
        <xsl:if test="SubTipo != 'N.I.' and SubTipo != ''">
                 - <xsl:value-of select="SubTipo"/>
</xsl:if>
      </Title>
      <TransactionType>
        <xsl:value-of select="Operacao"/>
      </TransactionType>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="Endereco/UF"/>
        </State>
        <City>
          <xsl:value-of select="Endereco/Cidade"/>
        </City>
        <xsl:if test="Endereco/Bairro != '' ">
          <Neighborhood>
            <xsl:value-of select="Endereco/Bairro"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="Endereco/Logradouro != '' ">
          <Address publiclyVisible="false">
            <xsl:value-of select="Endereco/Logradouro"/>
            <xsl:if test="Numero != '' ">
                    , <xsl:value-of select="Numero"/>
</xsl:if>
          </Address>
        </xsl:if>
        <xsl:if test="Endereco/CEP != '' ">
          <PostalCode>
            <xsl:value-of select="Endereco/CEP"/>
          </PostalCode>
        </xsl:if>
      </Location>
      <Details>
        <Description>
          <xsl:value-of select="TextoComplementar"/>
          <xsl:if test="IPTU != '0,00' and IPTU != '0.00' and IPTU != '0' and IPTU != ''">
                   - IPTU: <xsl:value-of select="IPTU"/>
</xsl:if>
          <xsl:if test="AndaresPredio != '' and AndaresPredio != '0'">
                   - <xsl:value-of select="AndaresPredio"/>º Andar
                </xsl:if>
          <xsl:if test="AndaresPredio = '0'">
                   - Térreo
                </xsl:if>
          <xsl:if test="Lavabo != '' and Lavabo != '0'">
                   - Lavabo: <xsl:value-of select="Lavabo"/>
</xsl:if>
          <xsl:if test="Playground != '' and Playground != '0'">
                   - Playground: <xsl:value-of select="Playground"/>
</xsl:if>
          <xsl:if test="Sauna != '' and Sauna != '0'">
                   - Sauna: <xsl:value-of select="Sauna"/>
</xsl:if>
          <xsl:if test="Portaria24h != '' and Portaria24h != '0'">
                   - Portaria 24h: <xsl:value-of select="Portaria24h"/>
</xsl:if>
          <xsl:if test="SalaoJogos != '' and SalaoJogos != '0'">
                   - Salao de Jogos: <xsl:value-of select="SalaoJogos"/>
</xsl:if>
          <xsl:if test="SalaoFestas != '' and SalaoFestas != '0'">
                   - Salao de Festas: <xsl:value-of select="SalaoFestas"/>
</xsl:if>
          <xsl:if test="QuadraEsporte != '' and QuadraEsporte != '0'">
                   - Quadra de Esporte: <xsl:value-of select="QuadraEsporte"/>
</xsl:if>
          <xsl:if test="ArmarioCozinha != '' and ArmarioCozinha != '0'">
                   - Armario para Cozinha: <xsl:value-of select="ArmarioCozinha"/>
</xsl:if>
        </Description>
        <PropertyType>
          <xsl:value-of select="Tipo"/>
        </PropertyType>
        <xsl:if test="Operacao = 'Venda'">
          <ListPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(Preco, ',00')">
                <xsl:value-of select="translate(substring-before(Preco, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(Preco, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ListPrice>
        </xsl:if>
        <xsl:if test="Operacao != 'Venda'">
          <RentalPrice currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(Preco, ',00')">
                <xsl:value-of select="translate(substring-before(Preco, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(Preco, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="ValorCondominio != '0,00' and ValorCondominio != '0.00' and ValorCondominio != '0' and ValorCondominio != ''">
          <PropertyAdministrationFee currency="BRL">
            <xsl:choose>
              <xsl:when test="contains(ValorCondominio, ',00')">
                <xsl:value-of select="translate(substring-before(ValorCondominio, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:when test="contains(ValorCondominio, '.00')">
                <xsl:value-of select="translate(substring-before(ValorCondominio, '.00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(ValorCondominio, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </PropertyAdministrationFee>
        </xsl:if>
        <xsl:if test="YearBuilt != 0 and YearBuilt != ''">
          <YearBuilt>
            <xsl:value-of select="YearBuilt"/>
          </YearBuilt>
        </xsl:if>
        <xsl:if test="AreaUtil != '0,00' and AreaUtil != ''">
          <ConstructedArea unit="square metres">
            <xsl:choose>
              <xsl:when test="contains(AreaUtil, ',00')">
                <xsl:value-of select="translate(substring-before(AreaUtil, ',00'), '.', '')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="translate(AreaUtil, '.', '')"/>
              </xsl:otherwise>
            </xsl:choose>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="Dormitorios != '0' and Dormitorios != ''">
          <Bedrooms>
            <xsl:value-of select="Dormitorios"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="Suites != '0' and Suites != ''">
          <Suites>
            <xsl:value-of select="Suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="Vagas != '0' and Vagas != ''">
          <Garage type="Parking Space">
            <xsl:value-of select="Vagas"/>
          </Garage>
        </xsl:if>
        <xsl:if test="VarandaTerraco != '0' and VarandaTerraco != '' and DependenciaEmpregados != '0' and DependenciaEmpregados != '' and Elevador != '0' and Elevador != '' and Churrasqueira != '0' and Churrasqueira != '' and Piscina != '0' and Piscina != ''">
          <Features>
            <xsl:if test="VarandaTerraco &gt; 0 and VarandaTerraco != ''">
              <Feature>Balcony/Terrace</Feature>
            </xsl:if>
            <xsl:if test="DependenciaEmpregados &gt; 0 and DependenciaEmpregados != ''">
              <Feature>Maid's Quarters</Feature>
            </xsl:if>
            <xsl:if test="Elevador &gt; 0 and Elevador != ''">
              <Feature>Elevator</Feature>
            </xsl:if>
            <xsl:if test="Churrasqueira &gt; 0 and Churrasqueira != ''">
              <Feature>BBQ</Feature>
            </xsl:if>
            <xsl:if test="Piscina &gt; 0 and Piscina != ''">
              <Feature>Pool</Feature>
            </xsl:if>
          </Features>
        </xsl:if>
      </Details>
      <ContactInfo>
        <Email>
          <xsl:value-of select="$fileName"/>
        </Email>
        <Name>
          <xsl:value-of select="$fileName"/>
        </Name>
      </ContactInfo>
    </Listing>
  </xsl:template>
</xsl:stylesheet>
