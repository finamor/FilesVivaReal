<?xml version="1.0" encoding="UTF-8"?>
<!-- Utilizado somente para o cliente jailton@sjconsultoriaimobiliaria.com.br -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="listings" match="imoveis">
  	<ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
      <Header>
        <Provider>ImovelPro</Provider>
        <Email>ronanlucio@gmail.com</Email>
      </Header>
      <Listings>
        <xsl:for-each select="imovel">
          <xsl:call-template name="Lista"/>
        </xsl:for-each>
      </Listings>
    </ListingDataFeed>
  </xsl:template>
  <xsl:template name="Lista" match="imovel">
    <Listing xmlns="http://www.vivareal.com/schemas/1.0/VRSync">
      <ListingID>
	<xsl:choose>
		<xsl:when test="ref != ''">
			<xsl:value-of select="ref"/>
		</xsl:when>
		<xsl:when test="referencia != ''">
			<xsl:value-of select="referencia"/>
		</xsl:when>	
	</xsl:choose>
      </ListingID>
      <Title>
	<xsl:choose>
		<xsl:when test="itens != ''">
			<xsl:value-of select="concat(tipo, ' - ', itens)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="tipo"/>
		</xsl:otherwise>
	</xsl:choose>
      </Title>
      <TransactionType>
        <xsl:choose>
          <xsl:when test="operacao = 'v'">
          	<xsl:text>For Sale</xsl:text>
          </xsl:when>
          <xsl:otherwise>
          	<xsl:text>For Rent</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </TransactionType>
      <Details>
        <Description>
		<xsl:value-of select="concat(descricao, ' ', itens, ' ', condicoes, ' ', Acabamentos_Benfeitorias, ' ', caracteristicas)"/>
        </Description>
        <xsl:if test="operacao = 'v' or transacao='V'">
          <ListPrice currency="BRL">
             <xsl:value-of select="valor"/>
          </ListPrice>
        </xsl:if>
        <xsl:if test="operacao != 'v' or transacao='L'">
          <RentalPrice currency="BRL" period="Monthly">
             <xsl:value-of select="valor"/>
          </RentalPrice>
        </xsl:if>
        <xsl:if test="areaTotal != '' or area_total != ''">
          <LotArea unit="square metres">
		<xsl:choose>
			<xsl:when test="areaTotal != ''">
				<xsl:value-of select="areaTotal"/>
			</xsl:when>
                        <xsl:when test="area_total != ''">
                                <xsl:value-of select="area_total"/>
                        </xsl:when>
		</xsl:choose>
          </LotArea>
        </xsl:if>
        <xsl:if test="areaPrivativa != '' or (area_util != '' and area_util != '0')">
          <LivingArea unit="square metres">
		<xsl:choose>
			<xsl:when test="areaPrivativa != ''">
				<xsl:value-of select="areaPrivativa"/>
			</xsl:when>
			<xsl:when test="area_util != '' and area_util != '0'">
				<xsl:value-of select="area_util"/>
			</xsl:when>
		</xsl:choose>
          </LivingArea>
        </xsl:if>
        <PropertyType>
          <xsl:value-of select="tipo"/>
        </PropertyType>
        <xsl:if test="quartos != '' and quartos != '0'">
          <Bedrooms>
            <xsl:value-of select="quartos"/>
          </Bedrooms>
        </xsl:if>
        <xsl:if test="banheiros != '' and banheiros != '0'">
          <Bathrooms>
            <xsl:value-of select="banheiros"/>
          </Bathrooms>
        </xsl:if>
        <xsl:if test="suites != '' and suites != '0'">
          <Suites>
            <xsl:value-of select="suites"/>
          </Suites>
        </xsl:if>
        <xsl:if test="vagas != '' or (garagem != '' and garagem != '0')">
          <Garage>
		<xsl:choose>
			<xsl:when test="vagas != ''">
				<xsl:value-of select="vagas"/>
			</xsl:when>
			<xsl:when test="garagem != '' and garagem != '0'">
				<xsl:value-of select="garagem"/>
			</xsl:when>
		</xsl:choose>
          </Garage>
        </xsl:if>
	<xsl:if test="numero != ''">
		<UnitNumber>
			<xsl:value-of select="numero"/>
		</UnitNumber>
	</xsl:if>
<!--           <Features> -->
<!--             <xsl:if test="ambientes/churrasqueiras &gt; 0"> -->
<!--               <Feature>BBQ</Feature> -->
<!--             </xsl:if> -->
<!--           </Features> -->
      </Details>
      <Location>
        <Country abbreviation="BR">BR</Country>
        <State>
		<xsl:choose>
			<xsl:when test="uf != ''">
				<xsl:value-of select="uf"/>
			</xsl:when>
			<xsl:when test="estado != ''">
				<xsl:value-of select="estado"/>
			</xsl:when>
		</xsl:choose>
        </State>
        <City>
          <xsl:value-of select="cidade"/>
        </City>
        <xsl:if test="bairro != ''">
          <Neighborhood>
            <xsl:value-of select="bairro"/>
          </Neighborhood>
        </xsl:if>
        <xsl:if test="rua != '' or endereco != ''">
          <Address>
		<xsl:choose>
			<xsl:when test="rua != ''">
            <xsl:value-of select="rua"/>
            <xsl:if test="numero != ''"><xsl:value-of select="concat(', ', numero)"/></xsl:if>
            <xsl:if test="complemento != ''"><xsl:text>Complemento: </xsl:text><xsl:value-of select="complemento"/></xsl:if>
			</xsl:when>
			<xsl:when test="endereco != ''">
				<xsl:value-of select="endereco"/>
			</xsl:when>
		</xsl:choose>
          </Address>
        </xsl:if>
        <xsl:if test="cep != ''">
           <PostalCode>
             <xsl:value-of select="cep"/>
           </PostalCode>
        </xsl:if>
        <xsl:if test="lat != ''">
          <Latitude>
            <xsl:value-of select="lat"/>
          </Latitude>
        </xsl:if>
        <xsl:if test="lon != ''">
          <Longitude>
            <xsl:value-of select="lon"/>
          </Longitude>
        </xsl:if>
      </Location>
      <xsl:if test="fotos/foto != ''">
      <Media>
        <xsl:for-each select="fotos/foto">
          <Item medium="image">
			<xsl:value-of select="."/>
          </Item>
        </xsl:for-each>
      </Media>
      </xsl:if>
      <ContactInfo>
        <Email>
        	<xsl:choose>
        		<xsl:when test="Imob_email != ''">
        			<xsl:value-of select="Imob_email"></xsl:value-of>
        		</xsl:when>
        		<xsl:when test="imobEmail != ''">
          			<xsl:value-of select="imobEmail"/>
        		</xsl:when>
        	</xsl:choose>
        </Email>
        <Name>
        	<xsl:choose>
        		<xsl:when test="Imob_nome != ''">
        			<xsl:value-of select="Imob_nome"></xsl:value-of>
        		</xsl:when>
        		<xsl:when test="imobNome != ''">
          			<xsl:value-of select="imobNome"/>
        		</xsl:when>
        	</xsl:choose>
        </Name>
        <Website>
			<xsl:value-of select="imobUrl"/>
		</Website>
        <Telephone><xsl:value-of select="imobTelefone"/></Telephone>
      </ContactInfo>
<!--       <xsl:if test="caracteristicas/categoria_capa = 'Destaques'"> -->
<!--         <Featured>true</Featured> -->
<!--       </xsl:if> -->
    </Listing>
  </xsl:template>
</xsl:stylesheet>
