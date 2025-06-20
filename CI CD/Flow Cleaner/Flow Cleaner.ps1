# SFCP - Salesforce Flow Clean - Cleans the flow LocationX and LocationY nodes
# Params:
# -d: Flow directory
# -dn: do not convert to AUTO_LAYOUT_CANVAS (optional)
# -n: Flow name - if provided, the flow will be cleaned in the directory
# Description:
# - Provide the flow directory or flow name to clean the flow
# - When name is provided, the command is invoked from a dx project
# - No limitation when providing a directory
Function sfcf {
    param(
        [string]$d,
        [switch]$dn,
        [string]$n
    )

    $ErrorActionPreference = "Stop"

    $nodesUpdated = 0

    if($d){
        $XmlFilePath = $d
    } elseif(-not $d -and $n){
        $XmlFilePath = "force-app/main/default/flows/$n.flow-meta.xml"
    } else {
        Write-Error "Flow directory or flow name is required"
        return
    }

    # Load XML content
    [xml]$xml = Get-Content $XmlFilePath

    # Handle Salesforce namespace
    $nsManager = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $nsManager.AddNamespace('sf', 'http://soap.sforce.com/2006/04/metadata')

    # Check for AUTO_LAYOUT_CANVAS anywhere in the document
    $autoLayoutNode = $xml.SelectSingleNode("//sf:stringValue[text()='AUTO_LAYOUT_CANVAS']", $nsManager)
    $freeFormNode = $xml.SelectSingleNode("//sf:stringValue[text()='FREE_FORM_CANVAS']", $nsManager)

    if (-not $autoLayoutNode -and $freeFormNode) {

        if($dn){
            Write-Host "Exiting flow as it is FREE_FORM_CANVAS"
            return
        }

        $freeFormNode.InnerText = "AUTO_LAYOUT_CANVAS"

        Write-Warning "Converted Flow to AUTO_LAYOUT_CANVAS"

    } elseif (-not $autoLayoutNode) {
        Write-Error "Flow Canvas mode not found, make sure that you are working on a flow file".
        return
    }

    # Find all LocationX and LocationY nodes in the document
    $locationNodes = $xml.SelectNodes("//sf:locationX | //sf:locationY", $nsManager)

    if ($locationNodes.Count -eq 0) {
        Write-Host "No LocationX/LocationY nodes found"
        return
    }

    # Update all found nodes
    foreach ($node in $locationNodes) {

        if($node.InnerText -ne "0"){
            $node.InnerText = "0"
            $nodesUpdated++
        }
    }

    if($nodesUpdated -eq 0){
        Write-Warning "No Locations found to clean"
        return
    }

    # Save changes with proper formatting
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Indent = $true
    $settings.IndentChars = "    "
    $settings.NewLineChars = "`n"

    $writer = [System.Xml.XmlWriter]::Create($XmlFilePath, $settings)
    $xml.WriteContentTo($writer)
    $writer.Close()

    Write-Host "Updated $($nodesUpdated) coordinates to 0 in the flow $XmlFilePath"
}

# SFPF - Salesforce Flow Pull - Retrieves the flow from Salesforce and cleans it
# Params:
# -n: Flow name (required)
# -o: Org name (optional) - target org of dx project is considered if not provided
# -dn: do not convert to AUTO_LAYOUT_CANVAS (optional)
# TODO: -d: Flow directory (optional) - if provided, the flow will be retrieved from the directory
Function sfpf {
    param(
        [string]$n,
        [string]$o,
        [switch]$dn
        # [string]$d
    )

    $ErrorActionPreference = "Stop"

    # if($n -and $d){
    #     Write-Error "Only one of the following parameters must be provided: -n (flow name) or -d (Flow directory)"
    #     return
    # }

    if(-not $o){
        # sf project retrieve start $(if($n){"-m flow:$n"}else{"-d $d"})
        sf project retrieve start -m flow:$n
    }
    else{
        sf project retrieve start -m flow:$n -o $o
    }

    if($dn){
        sfcf -d "force-app/main/default/flows/$n.flow-meta.xml" -dn
        }
    else{
        sfcf -d "force-app/main/default/flows/$n.flow-meta.xml"
    }    
}