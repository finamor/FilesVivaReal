<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:x="http://www.vivareal.com/schemas/1.0/VRSync" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="x" version="1.0">
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space()"/>
  </xsl:template>
  <xsl:template match="comment()"/>

  <!--Ajustes em Location -->
  <xsl:template match="x:Listing/x:Location">
    <xsl:choose>
      <xsl:when test="not(x:StreetNumber)">
        <xsl:call-template name="location"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="location">
    <Location>
      <xsl:choose>
        <xsl:when test="x:Address[@publiclyVisible='false'] or not(x:Address) or x:Address=''">
          <xsl:attribute name="displayAddress">Neighborhood</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="displayAddress">All</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:copy-of select="x:Country"/>
      <xsl:copy-of select="x:City"/>
      <xsl:copy-of select="x:State"/>
      <xsl:copy-of select="x:Zone"/>
      <xsl:copy-of select="x:Province"/>
      <xsl:copy-of select="x:PostalCode"/>
      <xsl:copy-of select="x:Latitude"/>
      <xsl:copy-of select="x:Longitude"/>
      <xsl:copy-of select="x:Neighborhood"/>
      <xsl:if test="x:Address">
        <xsl:choose>
          <xsl:when test="contains(x:Address, ',')">
            <xsl:element name="Address">
              <xsl:value-of select="normalize-space(substring-before(x:Address, ','))"/>
            </xsl:element>
            <xsl:element name="StreetNumber">
              <xsl:value-of select="normalize-space(substring-after(x:Address, ','))"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="Address">
              <xsl:value-of select="x:Address"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </Location>
  </xsl:template>
</xsl:stylesheet>
