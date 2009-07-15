require 'nokogiri'

NS = {
  'mets' => 'http://www.loc.gov/METS/',
  'premis' => 'info:lc/xmlns/premis-v2'
}


Then /^a PREMIS document should be returned$/ do
  last_response.status.should == 200
  doc = LibXML::XML::Parser.string(last_response.body).parse
  doc.find_first('/premis:premis', NS).should_not be_nil
  doc.find_first('/premis:premis/premis:object', NS).should_not be_nil
end

Given /^a PREMIS\-in\-METS document with PREMIS embedded as a container$/ do
  @doc = <<XML
<?xml-stylesheet href="/pim2html.xsl" type="text/xsl"?>
<mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:premis="info:lc/xmlns/premis-v2" xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version18/mets.xsd            info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd">
  <amdSec ID="PREMIS_AMD">
    <digiprovMD ID="dp-XX">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <premis xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">
     
  <!-- Representation object -->
  <object xsi:type="representation">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>E20090127_AAAAAA/representation/1</objectIdentifierValue>
    </objectIdentifier>
    <relationship>
      <relationshipType>structural</relationshipType>
      <relationshipSubType>includes</relationshipSubType>
      <relatedObjectIdentification>
        <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
        <relatedObjectIdentifierValue>F20090127_AAAAAA</relatedObjectIdentifierValue>
      </relatedObjectIdentification>     
    </relationship>
    <relationship>
      <relationshipType>structural</relationshipType>
      <relationshipSubType>includes</relationshipSubType>
      <relatedObjectIdentification>
        <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
        <relatedObjectIdentifierValue>F20090127_AAAAAC</relatedObjectIdentifierValue>
      </relatedObjectIdentification>     
    </relationship>
  </object>
  
  <!-- File objects -->
  <object xsi:type="file">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>F20090127_AAAAAA</objectIdentifierValue>
    </objectIdentifier>
    <objectCharacteristics>
      <compositionLevel>0</compositionLevel>
      <fixity>
        <messageDigestAlgorithm>SHA-1</messageDigestAlgorithm>
        <messageDigest>34bcb73f6ea7c852989b5dd108060c1bda989ddb</messageDigest>
      </fixity>
      <size>49236</size>
      <format>
        <formatDesignation>
	      <formatName>jpeg</formatName>
        </formatDesignation>
      </format>
    </objectCharacteristics>
    <storage>
      <contentLocation>
        <contentLocationType>EXT3</contentLocationType>
        <contentLocationValue>foo/bar/baz.jpg</contentLocationValue>
      </contentLocation>
    </storage>
  </object>
  
  <object xsi:type="file">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>F20090127_AAAAAC</objectIdentifierValue>
    </objectIdentifier>
    <objectCharacteristics>
      <compositionLevel>0</compositionLevel>
      <format>
        <formatDesignation>
	      <formatName>xml</formatName>
          <formatVersion>1.0</formatVersion>
        </formatDesignation>
      </format>
    </objectCharacteristics>
  </object>  

  <event>
    <eventIdentifier>
      <eventIdentifierType>local</eventIdentifierType>
      <eventIdentifierValue>E20090127_AAAAAA/event/488374</eventIdentifierValue>
    </eventIdentifier>
    <eventType>virus check</eventType>
    <eventDateTime>2009-01-27T14:32:12-05:00</eventDateTime>
 
    <eventDetail>Checked for virus during DataFile creation</eventDetail>
    <eventOutcomeInformation>
      <eventOutcome>SUCCESS</eventOutcome>
      <eventOutcomeDetail>
        <eventOutcomeDetailNote/>
      </eventOutcomeDetail>
    </eventOutcomeInformation>

    <linkingObjectIdentifier>
      <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
      <linkingObjectIdentifierValue>F20090127_AAAAAA</linkingObjectIdentifierValue>
    </linkingObjectIdentifier>

    <linkingObjectIdentifier>
      <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
      <linkingObjectIdentifierValue>E20090127_AAAAAA/representation/1</linkingObjectIdentifierValue>
        <linkingObjectRole>associated representation</linkingObjectRole>
    </linkingObjectIdentifier>
  </event>

  <agent>
    <agentIdentifier>
      <agentIdentifierType>local</agentIdentifierType>
      <agentIdentifierValue>FDA</agentIdentifierValue>
    </agentIdentifier>
    <agentName>FDA</agentName>
    <agentType>organization</agentType>
  </agent>

  <rights>
    <rightsStatement>
      <rightsStatementIdentifier>
        <rightsStatementIdentifierType>URI</rightsStatementIdentifierType>
        <rightsStatementIdentifierValue>info:fcla/rights/rights1</rightsStatementIdentifierValue>
      </rightsStatementIdentifier>
      <rightsBasis>copyright</rightsBasis>
      <copyrightInformation>
        <copyrightStatus>publicdomain</copyrightStatus>
        <copyrightJurisdiction>us</copyrightJurisdiction>
      </copyrightInformation>

    </rightsStatement>
  </rights>


</premis>
        </xmlData>
      </mdWrap>
    </digiprovMD>
  </amdSec>
  <fileSec>
    <fileGrp ADMID="PREMIS_AMD">
      <file ID="file-1" OWNERID="F20090127_AAAAAA" SIZE="49236" CHECKSUM="34bcb73f6ea7c852989b5dd108060c1bda989ddb" CHECKSUMTYPE="SHA-1">
        <FLocat LOCTYPE="OTHER" OTHERLOCTYPE="EXT3" xlink:href="foo/bar/baz.jpg"/>
      </file>
      <file ID="file-2" OWNERID="F20090127_AAAAAC"/>
    </fileGrp>
  </fileSec>
  <structMap ID="representation-1">
    <div>
      <fptr FILEID="file-1"/>
      <fptr FILEID="file-2"/>
    </div>
  </structMap>
</mets>
XML

end

Given /^a PREMIS\-in\-METS document with PREMIS embedded as buckets$/ do
  @doc = <<XML
<mets xmlns="http://www.loc.gov/METS/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:premis="info:lc/xmlns/premis-v2" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version18/mets.xsd                                info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd                                http://www.loc.gov/mix/v10 http://www.loc.gov/standards/mix/mix10/mix10.xsd">
  <amdSec>
    <techMD ID="object-1">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="file">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>F20090127_AAAAAA</objectIdentifierValue>
    </objectIdentifier>
    <objectCharacteristics>
      <compositionLevel>0</compositionLevel>
      <fixity>
        <messageDigestAlgorithm>SHA-1</messageDigestAlgorithm>
        <messageDigest>34bcb73f6ea7c852989b5dd108060c1bda989ddb</messageDigest>
      </fixity>
      <size>49236</size>
      <format>
        <formatDesignation>
	      <formatName>jpeg</formatName>
        </formatDesignation>
      </format>
    </objectCharacteristics>
    <storage>
      <contentLocation>
        <contentLocationType>EXT3</contentLocationType>
        <contentLocationValue>foo/bar/baz.jpg</contentLocationValue>
      </contentLocation>
    </storage>
  </object>
        </xmlData>
      </mdWrap>
    </techMD>
    <techMD ID="object-2">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="file">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>F20090127_AAAAAC</objectIdentifierValue>
    </objectIdentifier>
    <objectCharacteristics>
      <compositionLevel>0</compositionLevel>
      <format>
        <formatDesignation>
	      <formatName>xml</formatName>
          <formatVersion>1.0</formatVersion>
        </formatDesignation>
      </format>
    </objectCharacteristics>
  </object>
        </xmlData>
      </mdWrap>
    </techMD>
    <techMD ID="representation-1">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="representation">
    <objectIdentifier>
      <objectIdentifierType>local</objectIdentifierType>
      <objectIdentifierValue>E20090127_AAAAAA/representation/1</objectIdentifierValue>
    </objectIdentifier>
    <relationship>
      <relationshipType>structural</relationshipType>
      <relationshipSubType>includes</relationshipSubType>
      <relatedObjectIdentification>
        <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
        <relatedObjectIdentifierValue>F20090127_AAAAAA</relatedObjectIdentifierValue>
      </relatedObjectIdentification>     
    </relationship>
    <relationship>
      <relationshipType>structural</relationshipType>
      <relationshipSubType>includes</relationshipSubType>
      <relatedObjectIdentification>
        <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
        <relatedObjectIdentifierValue>F20090127_AAAAAC</relatedObjectIdentifierValue>
      </relatedObjectIdentification>     
    </relationship>
  </object>
        </xmlData>
      </mdWrap>
    </techMD>
    <rightsMD ID="rights-1">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <rights xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <rightsStatement>
      <rightsStatementIdentifier>
        <rightsStatementIdentifierType>URI</rightsStatementIdentifierType>
        <rightsStatementIdentifierValue>info:fcla/rights/rights1</rightsStatementIdentifierValue>
      </rightsStatementIdentifier>
      
      <rightsBasis>copyright</rightsBasis>
      <copyrightInformation>
        <copyrightStatus>publicdomain</copyrightStatus>
        <copyrightJurisdiction>us</copyrightJurisdiction>
      </copyrightInformation>

    </rightsStatement>
  </rights>
        </xmlData>
      </mdWrap>
    </rightsMD>
    <digiprovMD ID="event-1" ADMID="object-1">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <event xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <eventIdentifier>
      <eventIdentifierType>local</eventIdentifierType>
      <eventIdentifierValue>E20090127_AAAAAA/event/488374</eventIdentifierValue>
    </eventIdentifier>
    <eventType>virus check</eventType>
    <eventDateTime>2009-01-27T14:32:12-05:00</eventDateTime>
 
    <eventDetail>Checked for virus during DataFile creation</eventDetail>
    <eventOutcomeInformation>
      <eventOutcome>SUCCESS</eventOutcome>
      <eventOutcomeDetail>
        <eventOutcomeDetailNote/>
      </eventOutcomeDetail>
    </eventOutcomeInformation>

    <linkingObjectIdentifier>
      <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
      <linkingObjectIdentifierValue>F20090127_AAAAAA</linkingObjectIdentifierValue>
    </linkingObjectIdentifier>

    <linkingObjectIdentifier>
      <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
      <linkingObjectIdentifierValue>E20090127_AAAAAA/representation/1</linkingObjectIdentifierValue>
        <linkingObjectRole>associated representation</linkingObjectRole>
    </linkingObjectIdentifier>
  </event>
        </xmlData>
      </mdWrap>
    </digiprovMD>
    <digiprovMD ID="agent-1">
      <mdWrap MDTYPE="PREMIS">
        <xmlData>
          <agent xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <agentIdentifier>
      <agentIdentifierType>local</agentIdentifierType>
      <agentIdentifierValue>FDA</agentIdentifierValue>
    </agentIdentifier>
    <agentName>FDA</agentName>
    <agentType>organization</agentType>
  </agent>
        </xmlData>
      </mdWrap>
    </digiprovMD>
  </amdSec>
  <fileSec>
    <fileGrp>
      <file ID="file-1" ADMID="object-1" OWNERID="F20090127_AAAAAA" SIZE="49236" CHECKSUM="34bcb73f6ea7c852989b5dd108060c1bda989ddb" CHECKSUMTYPE="SHA-1">
        <FLocat LOCTYPE="OTHER" OTHERLOCTYPE="EXT3" xlink:href="foo/bar/baz.jpg"/>
      </file>
      <file ID="file-2" ADMID="object-2" OWNERID="F20090127_AAAAAC"/>
    </fileGrp>
  </fileSec>
  <structMap>
    <div ADMID="representation-1">
      <fptr FILEID="file-1"/>
      <fptr FILEID="file-2"/>
    </div>
  </structMap>
</mets>
XML

end

Given /^an invalid PREMIS\-in\-METS document$/ do
    @doc = <<XML
  <mets xmlns="http://www.loc.gov/METS/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:premis="info:lc/xmlns/premis-v2" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.loc.gov/METS/ http://www.loc.gov/standards/mets/version18/mets.xsd                                info:lc/xmlns/premis-v2 http://www.loc.gov/standards/premis/premis.xsd                                http://www.loc.gov/mix/v10 http://www.loc.gov/standards/mix/mix10/mix10.xsd">
    <amdSec>
      <techMD ID="object-1">
        <mdWrap MDTYPE="PREMISSSSSSS"> <!-- invalid MDTYPE -->
          <xmlData>
            <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="file">
      <objectIdentifier>
        <objectIdentifierType>local</objectIdentifierType>
        <objectIdentifierValue>F20090127_AAAAAA</objectIdentifierValue>
      </objectIdentifier>
      <objectCharacteristics>
        <compositionLevel>0</compositionLevel>
        <fixity>
          <messageDigestAlgorithm>SHA-1</messageDigestAlgorithm>
          <messageDigest>34bcb73f6ea7c852989b5dd108060c1bda989ddb</messageDigest>
        </fixity>
        <size>49236</size>
        <format>
          <formatDesignation>
  	      <formatName>jpeg</formatName>
          </formatDesignation>
        </format>
      </objectCharacteristics>
      <storage>
        <contentLocation>
          <contentLocationType>EXT3</contentLocationType>
          <contentLocationValue>foo/bar/baz.jpg</contentLocationValue>
        </contentLocation>
      </storage>
    </object>
          </xmlData>
        </mdWrap>
      </techMD>
      <techMD ID="object-2">
        <mdWrap MDTYPE="PREMIS">
          <xmlData>
            <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="file">
      <objectIdentifier>
        <objectIdentifierType>local</objectIdentifierType>
        <objectIdentifierValue>F20090127_AAAAAC</objectIdentifierValue>
      </objectIdentifier>
      <objectCharacteristics>
        <compositionLevel>0</compositionLevel>
        <format>
          <formatDesignation>
  	      <formatName>xml</formatName>
            <formatVersion>1.0</formatVersion>
          </formatDesignation>
        </format>
      </objectCharacteristics>
    </object>
          </xmlData>
        </mdWrap>
      </techMD>
      <techMD ID="representation-1">
        <mdWrap MDTYPE="PREMIS">
          <xmlData>
            <object xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="representation">
      <objectIdentifier>
        <objectIdentifierType>local</objectIdentifierType>
        <objectIdentifierValue>E20090127_AAAAAA/representation/1</objectIdentifierValue>
      </objectIdentifier>
      <relationship>
        <relationshipType>structural</relationshipType>
        <relationshipSubType>includes</relationshipSubType>
        <relatedObjectIdentification>
          <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
          <relatedObjectIdentifierValue>F20090127_AAAAAA</relatedObjectIdentifierValue>
        </relatedObjectIdentification>     
      </relationship>
      <relationship>
        <relationshipType>structural</relationshipType>
        <relationshipSubType>includes</relationshipSubType>
        <relatedObjectIdentification>
          <relatedObjectIdentifierType>local</relatedObjectIdentifierType>
          <relatedObjectIdentifierValue>F20090127_AAAAAC</relatedObjectIdentifierValue>
        </relatedObjectIdentification>     
      </relationship>
    </object>
          </xmlData>
        </mdWrap>
      </techMD>
      <rightsMD ID="rights-1">
        <mdWrap MDTYPE="PREMIS">
          <xmlData>
            <rights xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <rightsStatement>
        <rightsStatementIdentifier>
          <rightsStatementIdentifierType>URI</rightsStatementIdentifierType>
          <rightsStatementIdentifierValue>info:fcla/rights/rights1</rightsStatementIdentifierValue>
        </rightsStatementIdentifier>

        <rightsBasis>copyright</rightsBasis>
        <copyrightInformation>
          <copyrightStatus>publicdomain</copyrightStatus>
          <copyrightJurisdiction>us</copyrightJurisdiction>
        </copyrightInformation>

      </rightsStatement>
    </rights>
          </xmlData>
        </mdWrap>
      </rightsMD>
      <digiprovMD ID="event-1" ADMID="object-1">
        <mdWrap MDTYPE="PREMIS">
          <xmlData>
            <event xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <eventIdentifier>
        <eventIdentifierType>local</eventIdentifierType>
        <eventIdentifierValue>E20090127_AAAAAA/event/488374</eventIdentifierValue>
      </eventIdentifier>
      <eventType>virus check</eventType>
      <eventDateTime>2009-01-27T14:32:12-05:00</eventDateTime>

      <eventDetail>Checked for virus during DataFile creation</eventDetail>
      <eventOutcomeInformation>
        <eventOutcome>SUCCESS</eventOutcome>
        <eventOutcomeDetail>
          <eventOutcomeDetailNote/>
        </eventOutcomeDetail>
      </eventOutcomeInformation>

      <linkingObjectIdentifier>
        <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
        <linkingObjectIdentifierValue>F20090127_AAAAAA</linkingObjectIdentifierValue>
      </linkingObjectIdentifier>

      <linkingObjectIdentifier>
        <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
        <linkingObjectIdentifierValue>E20090127_AAAAAA/representation/1</linkingObjectIdentifierValue>
          <linkingObjectRole>associated representation</linkingObjectRole>
      </linkingObjectIdentifier>
    </event>
          </xmlData>
        </mdWrap>
      </digiprovMD>
      <digiprovMD ID="agent-1">
        <mdWrap MDTYPE="PREMIS">
          <xmlData>
            <agent xmlns="info:lc/xmlns/premis-v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <agentIdentifier>
        <agentIdentifierType>local</agentIdentifierType>
        <agentIdentifierValue>FDA</agentIdentifierValue>
      </agentIdentifier>
      <agentName>FDA</agentName>
      <agentType>organization</agentType>
    </agent>
          </xmlData>
        </mdWrap>
      </digiprovMD>
    </amdSec>
    <fileSec>
      <fileGrp>
        <file ID="file-1" ADMID="object-1" OWNERID="F20090127_AAAAAA" SIZE="49236" CHECKSUM="34bcb73f6ea7c852989b5dd108060c1bda989ddb" CHECKSUMTYPE="SHA-1">
          <FLocat LOCTYPE="OTHER" OTHERLOCTYPE="EXT3" xlink:href="foo/bar/baz.jpg"/>
        </file>
        <file ID="file-2" ADMID="object-2" OWNERID="F20090127_AAAAAC"/>
      </fileGrp>
    </fileSec>
    <structMap>
      <div ADMID="representation-1">
        <fptr FILEID="file-1"/>
        <fptr FILEID="file-2"/>
      </div>
    </structMap>
  </mets>
XML
end

Then /^some validation errors should be returned$/ do
  last_response.body.should contain('PREMISSSSSSS')
  last_response.body.should have_selector('div#flash') do |tag|
    tag.should contain('Cannot convert: validation errors exist')
  end
end

Then /^the status should be 400$/ do
  last_response.status.should == 400
end
