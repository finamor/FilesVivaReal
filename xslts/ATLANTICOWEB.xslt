<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
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
<xsl:template name="url_link">
<xsl:param name="value"/>
  <xsl:choose>
    <xsl:when test="contains($value, '/')">
      <xsl:value-of select="$value"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('http://vr.images.s3.amazonaws.com/',$fileName, '/',$value)"/>
    </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template name="round">
  <xsl:param name="value"/>
  <xsl:value-of select="substring-before($value, '.')"/>
</xsl:template>
<xsl:variable name="fileName" select="'atlantico'" />
<xsl:template match="/">
<ListingDataFeed xmlns="http://www.vivareal.com/schemas/1.0/VRSync" xsi:schemaLocation="http://www.vivareal.com/schemas/1.0/VRSync http://xml.vivareal.com/vrsync.xsd">
  <Header>
    <Provider>Atlântico Web</Provider>
    <Email>atlanticoweb@atlanticoweb.com.br</Email>
    <ContactName>Atlântico Web</ContactName>
    <Telephone>(47) 3368-5502</Telephone>
    <PublishDate>2014-01-07T11:17:14</PublishDate>
    <Logo>http://www.oatlanticoweb.com.br/arquivos/images/logo.png</Logo>
  </Header>
  <Listings>
    <xsl:for-each select="object/member[@name='imovel']">
<Listing>
  <ListingID>
    <xsl:value-of select="object/member[@name='imv_referencia']"/>
  </ListingID>
  <Title>
    <xsl:value-of select="object/member[@name='imv_titulo']"/>
  </Title>
  <TransactionType>
  <xsl:choose>
    <xsl:when test="starts-with(object/member[@name='prop_tp'],'Aluguel')">For Rent</xsl:when>
    <xsl:otherwise>For Sale</xsl:otherwise>
  </xsl:choose>
  </TransactionType>
  <ListDate><xsl:value-of select="concat(substring(object/member[@name='imv_dtcadastro'],1,10),'T',substring(object/member[@name='imv_dtcadastro'],12,8))" /></ListDate>
  <LastUpdateDate><xsl:value-of select="concat(substring(object/member[@name='imv_dtcadastro'],1,10),'T',substring(object/member[@name='imv_dtcadastro'],12,8))" /></LastUpdateDate>
  <DetailViewUrl> </DetailViewUrl>
  <xsl:if test="object/member[@name='prop_destaque']=0">
    <Featured>true</Featured>
  </xsl:if>
  <Status>
    <PropertyStatus>Available</PropertyStatus>
    <StatusDate><xsl:value-of select="concat(substring(object/member[@name='imv_dtcadastro'],1,10),'T',substring(object/member[@name='imv_dtcadastro'],12,8))" /></StatusDate>
  </Status>
  <Media>
    <Item medium="image" primary="true">
      <xsl:value-of select="concat('base64:', object/member[@name='Imagens']/array/object/member[@name='Link'])"/>
    </Item>
  <xsl:for-each select="object/member[@name='Imagens']/array/object/member[@name='Link']">
    <Item medium="image">
      <xsl:value-of select="concat('base64:', .)"/>
    </Item>
  </xsl:for-each>
  </Media>
    <Details>
      <PropertyType>
        <xsl:value-of select="object/member[@name='imv_tipoid']"/>
      </PropertyType>
      <Description><xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
      <xsl:value-of select="concat(object/member[@name='imv_titulo'], ' - ', object/member[@name='imv_obs1'], ' - ', object/member[@name='imv_obs2'])"/>
      <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
      </Description>
      <xsl:choose>
        <xsl:when test="starts-with(object/member[@name='prop_tp'],'Aluguel')">
          <RentalPrice currency="BRL"><xsl:value-of select="substring-before(object/member[@name='prop_valor']/string,'.')" />
          </RentalPrice>
        </xsl:when>
        <xsl:when test="starts-with(object/member[@name='prop_tp'],'Venda')">
          <ListPrice currency="BRL"><xsl:value-of select="substring-before(object/member[@name='prop_valor']/string,'.')" />
          </ListPrice>
        </xsl:when>
        <xsl:otherwise>
          <ListPrice currency="BRL"><xsl:value-of select="substring-before(object/member[@name='prop_valor']/string,'.')" />
          </ListPrice>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Terreno (m²)'] != ''">
	     	<LotArea unit="square metres">
      			<xsl:value-of select="substring-before(translate(translate(translate(object/member[@name='Propriedades']/object/member[@name='Terreno (m²)']/string, '{{a-zA-Z}}', '' ), 'm²', ''),'.',''),',')"/>
		  	</LotArea>
	  </xsl:if>
      <ConstructedArea unit="square metres">0</ConstructedArea>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)'] != ''">
            <LivingArea unit="square metres">
            	<xsl:choose>
            		<xsl:when test="contains(object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)']/string, ',' )">
            			<xsl:value-of select="substring-before(translate(translate(translate(object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)']/string, ' ', ''),'m²' , ''), '.', '' ), ',' )"/>
            		</xsl:when>
            		<xsl:when test="contains(object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)']/string, '.' )">
            			<xsl:value-of select="substring-before(translate(translate(translate(object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)']/string, ' ', ''),'m²' , ''), ',', '' ), '.' )"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:value-of select="translate(translate(translate(object/member[@name='Propriedades']/object/member[@name='Área Útil (m²)']/string, ' ', ''),'m²' , ''), ',', '.' )"/>
            		</xsl:otherwise>
            	</xsl:choose>
			</LivingArea>
	  </xsl:if>
      <DevelopmentLevel>Built</DevelopmentLevel>
      <YearBuilt>0</YearBuilt>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Dormitórios'] != ''">
      <Bedrooms>
      <xsl:value-of select="object/member[@name='Propriedades']/object/member[@name='Dormitórios']"/>
      </Bedrooms>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Banheiro']">
      <Bathrooms>
      <xsl:value-of select="object/member[@name='Propriedades']/object/member[@name='Banheiro']"/>
      </Bathrooms>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='+ Suítes'] != ''">
      <Suites>
      <xsl:value-of select="object/member[@name='Propriedades']/object/member[@name='+ Suítes']"/>
      </Suites>
      </xsl:if>
<!--       <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Garagem'] != ''"> -->
<!-- 	      <Garage type="Parking Space"> -->
<!-- 	      	<xsl:value-of select="substring-before(translate(object/member[@name='Propriedades']/object/member[@name='Garagem']/string, '+' ,'' ), ' ')"/> -->
<!-- 	      </Garage> -->
<!--       </xsl:if> -->
      <xsl:if test="object/member[@name='imv_end_num'] != ''">
        <UnitNumber><xsl:value-of select="object/member[@name='imv_end_num']" /></UnitNumber>
      </xsl:if>
      <Features>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Garagem'] != ''">
      <Feature>RV Parking</Feature>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Churrasqueira'] != ''">
      <Feature>BBQ</Feature>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/membar[@name='Cozinha'] != ''">
      <Feature>Kitchen</Feature>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Sacada'] != ''">
      <Feature>Balcony/Terrace</Feature>
      </xsl:if>
      <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Elevador'] != ''">
      <Feature>Elevator</Feature>
      </xsl:if>
    <xsl:if test="object/member[@name='Propriedades']/object/member[@name='Ar Condicionado'] != ''">
    <Feature>Air Conditioning</Feature>
    </xsl:if>
    </Features>
    </Details>
       <Location>
    <Country abbreviation="BR">BR</Country>
    <State>
      <xsl:attribute name="abbreviation"><xsl:value-of select="object/member[@name='Estado']" /></xsl:attribute>
      <xsl:choose>
        <xsl:when test="object/member[@name='Estado'] = 'SP'">
               Sao Paulo
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'RJ'">
                Rio de Janeiro
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'MG'">
                Minas Gerais
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'PR'">
                Parana
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'ES'">
                Espirito Santo
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'SC'">
                Santa Catarina
        </xsl:when>
        <xsl:when test="object/member[@name='Estado'] = 'RS'">
                Rio Grande do Sul
        </xsl:when>
        <xsl:otherwise>
                <xsl:value-of select="object/member[@name='Estado']" />
        </xsl:otherwise>
      </xsl:choose>
    </State>
    <City>
      <xsl:value-of select="object/member[@name='Cidade']"/>
    </City>
    <Neighborhood>
      <xsl:value-of select="object/member[@name='Bairro']"/>
    </Neighborhood> 
    <Address>
      <xsl:choose>
        <xsl:when test="object/member[@name='imv_show_endereco'] = '0'">
              <xsl:attribute name="publiclyVisible">false</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="publiclyVisible">true</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="concat(object/member[@name='imv_endereco'], ', ', object/member[@name='imv_end_num'], ' - ', object/member[@name='imv_end_complemento'])"/>
    </Address>
    <xsl:if test="object/member[@name='imv_cep'] != '' ">
      <PostalCode>
        <xsl:value-of select="object/member[@name='imv_cep']"/>
      </PostalCode>
    </xsl:if>
    <xsl:if test="object/member[@name='imv_map_lat'] != ''">
      <Latitude><xsl:value-of select="substring(object/member[@name='imv_map_lat'], 1, 10)"/></Latitude>
    </xsl:if>
    <xsl:if test="object/member[@name='imv_map_long'] != ''">
            <Longitude><xsl:value-of select="substring(object/member[@name='imv_map_long'], 1, 10)"/></Longitude>
    </xsl:if>
    </Location>
      <ContactInfo>
        <Name>Imobiliaria Cliente Atlantico Web</Name>
        <Email>customer@atlanticoweb.com.br</Email>
       <Telephone>(47) 3368-5502</Telephone>
        <Website>WebSite</Website>
        <Photo>www.customeratlanticoweb.com.br/Photo.jpg</Photo>
        <Logo>www.customeratlanticoweb.com.br/Logo.jpg</Logo>
        <OfficeName>Imobiliaria Locação</OfficeName>
        <Location>
          <Country abbreviation="BR">Brasil</Country>
          <State abbreviation="SC">Santa Catarina</State>
          <City>Florianópolis</City>
          <Neighborhood>TBD</Neighborhood>
          <Address publiclyVisible="false">Rua A ser definida</Address>
          <PostalCode>03709-000</PostalCode>
          <Latitude>-25.4188</Latitude>
          <Longitude>-49.3386</Longitude>
        </Location>
      </ContactInfo>
</Listing>
    </xsl:for-each>
  </Listings>
</ListingDataFeed>
</xsl:template>
</xsl:stylesheet>
