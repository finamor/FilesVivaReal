<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:template name="imoveis" match="ListingDataFeed">
<ListingDataFeed>
		<xsl:for-each select="Listings/Listing">
			<xsl:if test="ContactInfo/Email = 'revenda@mybrokerimoveis.com.br'">
				<xsl:call-template name="minhaLista" />
			</xsl:if>
		</xsl:for-each>
</ListingDataFeed>
	</xsl:template>
	<xsl:template name="minhaLista" match="ListingDataFeed/Listings/Listing">
  <Listings>
    <Listing>
      <ListingID><xsl:value-of select="ListingID" /></ListingID>
      <xsl:if test="Title != ''">
      <Title><xsl:value-of select="Title" /></Title>
      </xsl:if>
      <TransactionType><xsl:value-of select="TransactionType" /></TransactionType>
      <Featured><xsl:value-of select="Featured" /></Featured>
      <ListDate><xsl:value-of select="ListDate" /></ListDate>
      <LastUpdateDate><xsl:value-of select="LastUpdateDate" /></LastUpdateDate>
      <DetailViewUrl><xsl:value-of select="DetailViewUrl" /></DetailViewUrl>
      <xsl:if test="Media/Item != ''">
      <Media>
      	<xsl:for-each select="Media/Item">
          <Item medium="image">
            <xsl:choose>
              <xsl:when test="primary = 'true'">
                <xsl:attribute name="primary">true</xsl:attribute>
                <xsl:attribute name="caption"><xsl:value-of select="caption" /></xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:otherwise>
	            <xsl:attribute name="caption"><xsl:value-of select="caption" /></xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:otherwise>
            </xsl:choose>
          </Item>
		</xsl:for-each>
      </Media>
      </xsl:if>
      <Details>
        <PropertyType><xsl:value-of select="Details/PropertyType" /></PropertyType>
        <Description><xsl:value-of select="Details/Description" /></Description>
	<xsl:if test="Details/ListPrice != ''">
	<ListPrice currency="BRL"><xsl:value-of select="Details/ListPrice" /></ListPrice>
	</xsl:if>
        <xsl:if test="Details/RentalPrice != ''">
        <RentalPrice currency="BRL"><xsl:value-of select="Details/RentalPrice" /></RentalPrice>
        </xsl:if>
        <AvailableDate><xsl:value-of select="Details/AvailableDate" /></AvailableDate>
<xsl:if test="ConstructedArea != ''">
	<ConstructedArea unit="square metres"><xsl:value-of select="Details/ConstructedArea" /></ConstructedArea>
</xsl:if>
<xsl:if test="LotArea !='' ">
        <LotArea unit="square metres"><xsl:value-of select="Details/LotArea" /></LotArea>
</xsl:if>
<xsl:if test="LivingArea !=''">
        <LivingArea unit="square metres"><xsl:value-of select="Details/LivingArea" /></LivingArea>
</xsl:if>
<xsl:if test="DevelopmentLevel != ''">
        <DevelopmentLevel><xsl:value-of select="Details/DevelopmentLevel" /></DevelopmentLevel>
</xsl:if>
<xsl:if test="Bedrooms != ''">
        <Bedrooms><xsl:value-of select="Details/Bedrooms" /></Bedrooms>
</xsl:if>
<xsl:if test="Bathrooms != ''">
        <Bathrooms><xsl:value-of select="Details/Bathrooms" /></Bathrooms>
</xsl:if>
<xsl:if test="Suites != ''">
        <Suites><xsl:value-of select="Details/Suites" /></Suites>
</xsl:if>
<xsl:if test="Garage != ''">
        <Garage><xsl:value-of select="Details/Garage" /></Garage>
</xsl:if>
        <UnitNumber><xsl:value-of select="Details/UnitNumber" /></UnitNumber>
      </Details>
      <Location>
        <Country><xsl:value-of select="Location/Country" /></Country>
        <State abbreviation="PR"><xsl:value-of select="Location/State" /></State>
        <City><xsl:value-of select="Location/City" /></City>
        <Neighborhood><xsl:value-of select="Location/Neighborhood" /></Neighborhood>
        <Address><xsl:value-of select="Location/Address" /></Address>
<xsl:if test="PostalCode !='' ">
        <PostalCode><xsl:value-of select="Location/PostalCode" /></PostalCode>
</xsl:if>
<xsl:if test="Latitude != ''">
        <Latitude><xsl:value-of select="Location/Latitude" /></Latitude>
</xsl:if>
<xsl:if test="Longitude != ''">
        <Longitude><xsl:value-of select="Location/Longitude" /></Longitude>
</xsl:if>
      </Location>
      <ContactInfo>
        <Name><xsl:value-of select="ContactInfo/Name" /></Name>
        <Email><xsl:value-of select="ContactInfo/Email" /></Email>
        <Telephone><xsl:value-of select="ContactInfo/Telephone" /></Telephone>
        <Website><xsl:value-of select="ContactInfo/Website" /></Website>
        <Logo><xsl:value-of select="ContactInfo/Logo" /></Logo>
        <OfficeName><xsl:value-of select="ContactInfo/OfficeName" /></OfficeName>
        <Location>
          <Country><xsl:value-of select="ContactInfo/Location/Country" /></Country>
          <State><xsl:value-of select="ContactInfo/Location/State" /></State>
          <City><xsl:value-of select="ContactInfo/Location/City" /></City>
          <Neighborhood><xsl:value-of select="ContactInfo/Location/Neighborhood" /></Neighborhood>
          <Address><xsl:value-of select="ContactInfo/Location/Address" /></Address>
          <PostalCode><xsl:value-of select="ContactInfo/Location/PostalCode" /></PostalCode>
          <Latitude><xsl:value-of select="ContactInfo/Location/Latitude" /></Latitude>
          <Longitude><xsl:value-of select="ContactInfo/Location/Longitude" /></Longitude>
        </Location>
      </ContactInfo>
    </Listing>
  </Listings>
	</xsl:template>
</xsl:stylesheet>
