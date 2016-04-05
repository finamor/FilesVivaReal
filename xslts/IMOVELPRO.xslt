<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="fileName" select="''"/>
  <xsl:template name="listings" match="exportacao">
    <ListingDataFeed>
      <Header>
        <Provider>ImovelPro</Provider>
        <Email>ronanlucio@gmail.com</Email>
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
      <Title>
      	<xsl:choose>
			<xsl:when test="descricao/super_comentario != ''">
	        	<xsl:value-of select="descricao/super_comentario"/>
	        </xsl:when>
	        <xsl:otherwise>
	        	<xsl:value-of select="concat(caracteristicas/tipo_imovel, ' - ', caracteristicas/localizacao_especial)"/>
			</xsl:otherwise>
        </xsl:choose>
      </Title>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="negociacao/venda/preco != '0,00' and negociacao/venda/preco != '0.00'and negociacao/venda/preco != ''">
            <xsl:choose>
              <xsl:when test="negociacao/locacao/preco != '0,00' and negociacao/locacao/preco != '0.00' and negociacao/locacao/preco != ''">Sale/Rent</xsl:when>
              <xsl:when test="negociacao/locacao_estudante/preco != '0,00' and negociacao/locacao_estudante/preco != '0.00' and negociacao/locacao_estudante/preco != ''">Sale/Rent</xsl:when>
              <xsl:when test="negociacao/locacao_temporada/preco != '0,00' and negociacao/locacao_temporada/preco != '0.00' and negociacao/locacao_temporada/preco != ''">Sale/Rent</xsl:when>
              <xsl:otherwise>For Sale</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="negociacao/locacao_temporada/preco != '0,00' and negociacao/locacao_temporada/preco != '0.00' and negociacao/locacao_temporada/preco != ''">Vacation Rentals</xsl:when>
          <xsl:otherwise>For Rent</xsl:otherwise>
        </xsl:choose>
      </TransactionType>
      <Details>
        <Description><xsl:value-of select="descricao/mini_descricao"/> - <xsl:value-of select="descricao/descricao_externa"/><xsl:if test="caracteristicas/proximidade_do_mar != ''">
             -  Proximidade do Mar: <xsl:value-of select="caracteristicas/proximidade_do_mar"/></xsl:if><xsl:if test="caracteristicas/mobiliado = 'Sim'">
             - Mobiliado
          </xsl:if><xsl:if test="caracteristicas/mobiliado = 'Não'">
             - Não Mobiliado
          </xsl:if><xsl:if test="caracteristicas/mobiliado = 'Semi-mobiliado'">
             - Semi-mobiliado
          </xsl:if><xsl:if test="caracteristicas/tipo_casa = 'Mista'">
             - Tipo de Material Utilizado: Alvenaria e Madeira
          </xsl:if><xsl:if test="caracteristicas/tipo_casa = 'Madeira'">
             - Tipo de Material Utilizado: Madeira
          </xsl:if><xsl:if test="caracteristicas/tipo_casa = 'Alvenaria'">
             - Tipo de Material Utilizado: Alvenaria
          </xsl:if><xsl:if test="caracteristicas/andares != ''">
             - <xsl:value-of select="caracteristicas/andares"/></xsl:if><xsl:if test="caracteristicas/tipo_condominio != ''">
             - <xsl:value-of select="caracteristicas/tipo_condominio"/></xsl:if><xsl:if test="caracteristicas/sala_terrea = 'Sim'">
             - Andar: Térreo
          </xsl:if><xsl:if test="caracteristicas/localizacao_especial != ''">
             - <xsl:value-of select="caracteristicas/localizacao_especial"/></xsl:if><xsl:if test="caracteristicas/caracteristica_especial != ''">
             - <xsl:value-of select="caracteristicas/caracteristica_especial"/></xsl:if><xsl:if test="caracteristicas/categoria_capa != ''">
             - <xsl:value-of select="caracteristicas/categoria_capa"/></xsl:if><xsl:if test="endereco/numero_apto_ou_sala != ''">
             - Número de Apto ou Sala: <xsl:value-of select="endereco/numero_apto_ou_sala"/></xsl:if><xsl:if test="endereco/bloco != ''">
             - Número do Bloco: <xsl:value-of select="endereco/bloco"/></xsl:if><xsl:if test="endereco/andar != ''">
             - <xsl:value-of select="endereco/andar"/>º Andar
          </xsl:if><xsl:if test="endereco/quadra != ''">
             - Número da Quadra: <xsl:value-of select="endereco/quadra"/></xsl:if><xsl:if test="endereco/lote != ''">
             - Número do Lote: <xsl:value-of select="endereco/lote"/></xsl:if><xsl:if test="endereco/unidade != ''">
             - Número de Unidade: <xsl:value-of select="endereco/unidade"/></xsl:if><xsl:if test="endereco/incra != ''">
             - Número do Incra: <xsl:value-of select="endereco/incra"/></xsl:if><xsl:if test="endereco/acomodacoes != ''">
             - Número de Acomodações: <xsl:value-of select="endereco/acomodacoes"/></xsl:if><xsl:if test="caracteristicas/em_condominio = 'Sim'">
             - Condomínio Fechado
          </xsl:if><xsl:if test="caracteristicas/alto_padrao = 'Sim'">
             - Alto Padrão
          </xsl:if></Description>
        <xsl:if test="negociacao/venda/preco != '0,00' and negociacao/venda/preco != ''">
          <ListPrice currency="BRL">
            <xsl:value-of select="translate(substring-before(negociacao/venda/preco, ','), '.', '')"/>
          </ListPrice>
        </xsl:if>
        <xsl:if test="negociacao/locacao/preco != '0,00' and negociacao/locacao/preco != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:value-of select="translate(substring-before(negociacao/locacao/preco, ','), '.', '')"/>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="negociacao/locacao_temporada/preco != '0,00' and negociacao/locacao_temporada/preco != ''">
          <RentalPrice currency="BRL" period="Daily">
            <xsl:value-of select="translate(substring-before(negociacao/locacao_temporada/preco, ','), '.', '')"/>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="negociacao/locacao_estudante/preco != '0,00' and negociacao/locacao_estudante/preco != '0.00' and negociacao/locacao_estudante/preco != ''">
          <RentalPrice currency="BRL" period="Monthly">
            <xsl:value-of select="translate(substring-before(negociacao/locacao_estudante/preco, ','), '.', '')"/>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="medidas/area_total != '0,00' and medidas/area_total != ''">
          <LotArea unit="square metres">
            <xsl:value-of select="translate(translate(medidas/area_total,'.',''), ',', '.')"/>
          </LotArea>
        </xsl:if>
        <xsl:if test="taxas/valor_iptu != '00,00'">
          <YearlyTax currency="BRL">
            <xsl:value-of select="translate(substring-before(taxas/valor_iptu,','), '.', '')"/>
          </YearlyTax>
        </xsl:if>
        <xsl:if test="taxas/valor_condominio != '00,00'">
          <PropertyAdministrationFee currency="BRL">
            <xsl:value-of select="translate(substring-before(taxas/valor_condominio,','), '.', '')"/>
          </PropertyAdministrationFee>
        </xsl:if>
        <xsl:if test="medidas/area_construida != '0,00' and medidas/area_construida != ''">
          <ConstructedArea unit="square metres">
            <xsl:value-of select="translate(translate(medidas/area_construida,'.',''), ',', '.')"/>
          </ConstructedArea>
        </xsl:if>
        <xsl:if test="medidas/area_util != '0,00' and medidas/area_util != ''">
          <LivingArea unit="square metres">
            <xsl:value-of select="translate(translate(medidas/area_util,'.',''), ',', '.')"/>
          </LivingArea>
        </xsl:if>
        <PropertyType>
          <xsl:value-of select="caracteristicas/tipo_imovel"/>
        </PropertyType>
        <xsl:if test="ambientes/dormitorios != '0' and ambientes/dormitorios != ''">
          <Bedrooms>
            <xsl:value-of select="ambientes/dormitorios"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="ambientes/banheiros != '0' and ambientes/banheiros != ''">
          <Bathrooms>
            <xsl:value-of select="ambientes/banheiros"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="ambientes/sendo_suites != '0' and ambientes/sendo_suites != ''">
          <Suites>
            <xsl:value-of select="ambientes/sendo_suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="ambientes/garagens != '0' and ambientes/garagens != ''">
          <Garage>
            <xsl:value-of select="ambientes/garagens"/>
          </Garage>
        </xsl:if>
        <xsl:if test="SURFACE != ''">
          <Features>
            <xsl:if test="ambientes/churrasqueiras &gt; 0">
              <Feature>BBQ</Feature>
            </xsl:if>
            <xsl:if test="ambientes/piscinas &gt; 0">
              <Feature>Pool</Feature>
            </xsl:if>
            <xsl:if test="ambientes/sacadas &gt; 0">
              <Feature>Balcony/Terrace</Feature>
            </xsl:if>
            <xsl:if test="caracteristicas/frente_ao_mar = 'Sim'">
              <Feature>Ocean View</Feature>
            </xsl:if>
          </Features>
        </xsl:if>
      </Details>
      <Location>
        <xsl:choose>
          <xsl:when test="endereco/logradouro != '' and endereco/numero != ''">
            <xsl:attribute name="displayAddress">All</xsl:attribute>
          </xsl:when>
          <xsl:when test="endereco/logradouro != '' and endereco/numero = ''">
            <xsl:attribute name="displayAddress">Street</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="displayAddress">Neighborhood</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <Country abbreviation="BR">BR</Country>
        <State>
          <xsl:value-of select="endereco/estado"/>
        </State>
        <City>
          <xsl:value-of select="endereco/cidade"/>
        </City>
        <xsl:if test="endereco/bairro != ''">
          <Neighborhood>
            <xsl:value-of select="endereco/bairro"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="endereco/logradouro != ''">
          <Address>
            <xsl:value-of select="endereco/logradouro"/>
          </Address>
        </xsl:if>
        <xsl:if test="endereco/numero != ''">
          <StreetNumber>
            <xsl:value-of select="endereco/numero"/>
          </StreetNumber>
        </xsl:if>
        <xsl:if test="endereco/cep != ''">
          <PostalCode>
            <xsl:value-of select="endereco/cep"/>
          </PostalCode>
        </xsl:if>
        <xsl:if test="google_maps/latitude != ''">
          <Latitude>
            <xsl:value-of select="google_maps/latitude"/>
          </Latitude>
        </xsl:if>
        <xsl:if test="google_maps/longitude != ''">
          <Longitude>
            <xsl:value-of select="google_maps/longitude"/>
          </Longitude>
        </xsl:if>
      </Location>
      <xsl:if test="fotos/foto != ''">
      <Media>
        <xsl:if test="video/url != ''">
          <xsl:for-each select="video">
            <Item medium="video">
              <xsl:choose>
                <xsl:when test="starts-with(url, 'http:')">
                  <xsl:value-of select="url"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat('http:',url)"/>
                </xsl:otherwise>
              </xsl:choose>
            </Item>
          </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="fotos/foto">
          <Item medium="image">
            <xsl:choose>
              <xsl:when test="principal != 'Não'">
                <xsl:attribute name="primary">true</xsl:attribute>
                <xsl:if test="etiqueta != ''">
                  <xsl:attribute name="caption">
                    <xsl:value-of select="etiqueta"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="starts-with(url, 'http:')">
                    <xsl:value-of select="url"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat('http:',url)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="etiqueta != ''">
                  <xsl:attribute name="caption">
                    <xsl:value-of select="etiqueta"/>
                  </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="starts-with(url, 'http:')">
                    <xsl:value-of select="url"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat('http:',url)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </Item>
        </xsl:for-each>
      </Media>
      </xsl:if>
      <ContactInfo>
        <Email>
          suporte@vivareal.com
        </Email>
        <Name>
          suporte@vivareal.com
        </Name>
      </ContactInfo>
      <xsl:choose>
      	<xsl:when test="caracteristicas/categoria_capa = 'Destaques'">
      		<Featured>true</Featured>
      	</xsl:when>
      	<xsl:when test="tipo_anuncio = 'true'">
      		<Featured>true</Featured>
      	</xsl:when>
      </xsl:choose>     
    </Listing>
  </xsl:template>
</xsl:stylesheet>
