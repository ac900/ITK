<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:lxslt="http://xml.apache.org/xslt"
    xmlns:redirect="org.apache.xalan.lib.Redirect"
    extension-element-prefixes="redirect">

  <!--
       Use DashboardStamp as a parameter, default to most recent
       The proper flags to Xalan are in the form -PARAM DashboardStamp "string('foo')"
       -->
 <xsl:param name="DashboardPath"/> 
 <xsl:param name="DashboardStamp" select="string('MostRecentResults-Nightly')"/>
 <xsl:param name="TestDocDir">.</xsl:param>
 <xsl:variable name="DashboardDir" select="concat('../../../../Dashboard/', $DashboardStamp)"/>
 <xsl:variable name="IconDir">../../../../Icons</xsl:variable>
 <xsl:include href="Insight.xsl"/>


  <xsl:template match="/">
    <xsl:call-template name="Summary"/>
    <xsl:call-template name="CoverageByName"/>
    <xsl:call-template name="CoverageByCount"/>
 </xsl:template>

 <xsl:template name="CoverageByName">
  <redirect:write select="concat(string('{$TestDocDir}'), '/CoverageByName.html' )" file="dan.html">
    <xsl:call-template name="InsightHeader">
      <xsl:with-param name="Title">Coverage Log</xsl:with-param>
      <xsl:with-param name="IconDir">../../../../Icons</xsl:with-param>
      <xsl:with-param name="CoverageIcon">CoverageBlue.gif</xsl:with-param>
      <xsl:with-param name="DashboardDir" select="$DashboardDir"/>
    </xsl:call-template>

  <xsl:call-template name="SummaryTable"/>
 <br/><br/> 
  <table>
      <tr>
        <th>Filename <img border="0"><xsl:attribute name="src"><xsl:value-of select="$IconDir"/>/DownBlack.gif</xsl:attribute></img></th>
        <th>Percentage ( <a href="CoverageByCount.html">sort by</a> )</th>
      </tr>
      <xsl:for-each select="Site/Coverage/File">
        <xsl:sort select="@Covered" order="descending"/>
        <xsl:sort select="@FullPath"/>
        <xsl:call-template name="File"/>
      </xsl:for-each>
    </table>
    <xsl:call-template name="InsightFooter"/>
 </redirect:write> 
 </xsl:template>

 <xsl:template name="CoverageByCount">
  <redirect:write select="concat(string('{$TestDocDir}'), '/CoverageByCount.html' )" file="dan.html">
    <xsl:call-template name="InsightHeader">
      <xsl:with-param name="Title">Coverage Log</xsl:with-param>
      <xsl:with-param name="IconDir">../../../../Icons</xsl:with-param>
      <xsl:with-param name="CoverageIcon">CoverageBlue.gif</xsl:with-param>
      <xsl:with-param name="DashboardDir" select="$DashboardDir"/>
    </xsl:call-template>

  <xsl:call-template name="SummaryTable"/>
  <br/><br/> 
  <table>
      <tr>
        <th>Filename( <a href="CoverageByName.html">sort by</a> )</th> 
        <th>Percentage <img border="0"><xsl:attribute name="src"><xsl:value-of select="$IconDir"/>/DownBlack.gif</xsl:attribute></img></th> 
      </tr>
      <xsl:for-each select="Site/Coverage/File">
        <xsl:sort select="@Covered" order="ascending"/>
        <xsl:sort select="PercentCoverage" data-type="number" order="ascending"/>
        <xsl:call-template name="File"/>
      </xsl:for-each>
    </table>
    <xsl:call-template name="InsightFooter"/>
  </redirect:write>  
 </xsl:template>

  <xsl:template name="File">
    <tr>
      <xsl:if test="position() mod 2 = 0">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$LightBlue"/></xsl:attribute>
      </xsl:if>
      
      <xsl:choose>
        <xsl:when test="@Covered='true'">
          <td align="left">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="TranslateTestName">
                  <xsl:with-param name="Prefix">../Coverage/</xsl:with-param>
                  <xsl:with-param name="TestName" select="@FullPath"/>
                  <xsl:with-param name="Postfix">.html</xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:value-of select="@FullPath"/>
            </a>
          </td>
          <td align="center">
            <xsl:choose>
              <xsl:when test="PercentCoverage &lt; 50">
                <xsl:attribute name="bgcolor"><xsl:value-of select="$ErrorColor"/></xsl:attribute>
              </xsl:when> 
              <xsl:when test="PercentCoverage &gt;= 70.0">
                <xsl:attribute name="bgcolor"><xsl:value-of select="$NormalColor"/></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="bgcolor"><xsl:value-of select="$WarningColor"/></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="PercentCoverage"/>%
          </td>
        </xsl:when>
        <xsl:when test="@Covered='false'">
          <td align="left"><xsl:value-of select="@FullPath"/></td>
          <td align="center">UNTESTED</td>
        </xsl:when>
      </xsl:choose>
    </tr>
  </xsl:template>

    <xsl:template name="SummaryTable">
    <h3>Coverage started on <xsl:value-of select="Site/Coverage/StartDateTime"/></h3>
 <table cellpadding="30">
 <tr>
 <td>   
 <table border="2" cellpadding="0" cellspacing="2" width="300">
      <tr>
        <td align="left" width="60%"> Total Coverage</td> 
        <td align="center">
        <xsl:choose>
            <xsl:when test="Site/Coverage/PercentCoverage &lt; 50">
              <xsl:attribute name="bgcolor"><xsl:value-of select="$ErrorColor"/></xsl:attribute>
            </xsl:when> 
            <xsl:when test="Site/Coverage/PercentCoverage &gt;= 70.0">
              <xsl:attribute name="bgcolor"><xsl:value-of select="$NormalColor"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="bgcolor"><xsl:value-of select="$WarningColor"/></xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="Site/Coverage/PercentCoverage"/>%
        </td>
      </tr>    
      <tr>
        <td align="left"> Tested lines</td>
        <td align="right"><xsl:value-of select="Site/Coverage/LOCTested"/></td>
      </tr>
      <tr>
        <td align="left">Untested lines</td> 
        <td align="right"><xsl:value-of select="Site/Coverage/LOCUntested"/></td>
      </tr>
      <tr>
        <td align="left">Files Coverage</td>
        <td align="center"><xsl:value-of select="count(Site/Coverage/File[@Covered='true'])"/>  of <xsl:value-of select="count(Site/Coverage/File)"/></td>
      </tr>
      <tr>
        <td align="left">Covered &gt; 70.0%</td>
        <td align="right"><xsl:value-of select="count(Site/Coverage/File[@Covered='true']/PercentCoverage[node() &gt;= 70.0])"/></td>
      </tr>
      <tr>
        <td align="left">Covered &lt; 70.0%</td>
        <td align="right"><xsl:value-of select="count(Site/Coverage/File[@Covered='true']/PercentCoverage[node() &lt; 70.0])"/></td>
      </tr>
    </table>
   </td>
   <td valign="Top">
   <b>Legend</b>
   <table border="1" cellspacing="0" width="150" >
   <tr>
      <td align="center">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$NormalColor"/></xsl:attribute>
        &gt; 70%
      </td>
   </tr> 
   <tr>
     <td align="center">
       <xsl:attribute name="bgcolor"><xsl:value-of select="$WarningColor"/></xsl:attribute>
       50% &lt; x &lt; 70%
     </td>
  </tr> 
  <tr>
      <td align="center">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$ErrorColor"/></xsl:attribute>
        &lt; 50%
      </td>
   </tr></table>
   </td></tr></table>
 </xsl:template>

<xsl:template name="Summary">
  <redirect:write select="concat(string('{$TestDocDir}'), '/CoverageSummary.xml' )">
    <Coverage>
      <SiteName><xsl:value-of select="Site/@Name"/></SiteName>
      <BuildName><xsl:value-of select="Site/@BuildName"/></BuildName>
      <BuildStamp><xsl:value-of select="Site/@BuildStamp"/></BuildStamp>
      <StartDateTime><xsl:value-of select="Site/Coverage/StartDateTime"/></StartDateTime>
      <PercentCoverage><xsl:value-of select="Site/Coverage/PercentCoverage"/></PercentCoverage>
      <LOCTested><xsl:value-of select="Site/Coverage/LOCTested"/></LOCTested>
      <LOCUntested><xsl:value-of select="Site/Coverage/LOCUntested"/></LOCUntested>
      <LOC><xsl:value-of select="Site/Coverage/LOC"/></LOC>
      <Passed><xsl:value-of select="count(Site/Coverage/File/PercentCoverage[node() &gt;= 70])"/></Passed>
      <Failed><xsl:value-of select="count(Site/Coverage/File/PercentCoverage[node() &lt; 70])"/></Failed>
      <EndDateTime><xsl:value-of select="Site/Coverage/EndDateTime"/></EndDateTime>
    </Coverage>
  </redirect:write>
 </xsl:template>


</xsl:stylesheet>