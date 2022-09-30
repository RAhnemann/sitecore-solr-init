
$prefix = "sitecore"
$topology = "xm"
$manifestPath = "c:\data\manifest.json"
$sitecoreTemplatePath = "C:\data\sc-template"
$xdbTemplatePath = "C:\data\sc-template"
$outPath = "C:\solr"
$inclueRebuild = $false

$additionalScCores = ""
$additionalXdbCores = ""

#Parse Environment Variables

if($env:SOLR_CORE_PREFIX_NAME)
{
    Write-Host "Found SOLR_CORE_PREFIX_NAME environment variable: $env:SOLR_CORE_PREFIX_NAME"
    $prefix = $env:SOLR_CORE_PREFIX_NAME.Trim()
}
else {
    Write-Host "SOLR_CORE_PREFIX_NAME not found. Default: $prefix"
}

if($env:TOPOLOGY)
{
    Write-Host "Found TOPOLOGY environment variable: $env:TOPOLOGY"
    $topology = $env:TOPOLOGY.Trim()
}
else {
    Write-Host "TOPOLOGY not found. Default: $topology"
}

if($env:INCLUDE_REBUILD)
{
    Write-Host "Found INCLUDE_REBUILD environment variable: $env:INCLUDE_REBUILD"
    $topology = [boolean]$env:INCLUDE_REBUILD
}
else {
    Write-Host "INCLUDE_REBUILD not found. Default: False"
}

if($env:ADDITIONAL_SITECORE_CORES)
{
    Write-Host "Found ADDITIONAL_SITECORE_CORES environment variable: $env:ADDITIONAL_SITECORE_CORES"
    $additionalScCores = $env:ADDITIONAL_SITECORE_CORES
}
else {
    Write-Host "No additional Sitecore cores found"
}

if($env:ADDITIONAL_XDB_CORES)
{
    Write-Host "Found ADDITIONAL_XDB_CORES environment variable: $env:ADDITIONAL_XDB_CORES"
    $additionalXdbCores = $env:ADDITIONAL_XDB_CORES
}
else {
    Write-Host "No additional xdb cores found"
}

$manifest = Get-Content -Raw -Path $manifestPath | ConvertFrom-Json

$toplogy = $manifest.Topologies | Where-Object { $_.Name -eq $topology }

Function CreateCore($coreName, $coreType) {

    Write-Host "Creating [$coreType] core: $coreName"

    if ($coreType -eq "sitecore") {
        $templatePath = $sitecoreTemplatePath
    }
    else {
        $templatePath = $xdbTemplatePath
    }

    $destPath = Join-Path $outPath "${prefix}${coreName}"

    if(Test-Path $destPath -PathType Container)
    {
        Write-Host "Core at [$destPath] already exists. Skipping." -ForegroundColor Yellow
        return
    }

    Copy-Item $templatePath $destpath -Recurse

    $propsFile = Join-Path $destPath "core.properties"

    ((Get-Content -path $propsFile -Raw) -replace "__corename__", "${prefix}${coreName}") | Set-Content -Path $propsFile
    Write-Host "Core created at: $destPath" 
}

if ($toplogy.Cores.sitecore) {
    $toplogy.Cores.sitecore | ForEach-Object { 
        CreateCore $_ "sitecore" 

        if ($inclueRebuild) {
            $coreName = $_ + "_rebuild" 
            CreateCore $coreName "sitecore"
        }
    }
}

if ($toplogy.Cores.xdb) {
    $toplogy.Cores.xdb | ForEach-Object { 
        CreateCore($_, "xdb") 
    }
}

if($additionalScCores -ne "")
{
    $additionalScCores.Split("|") | ForEach-Object {
        CreateCore $_ "sitecore"
    }
}

if($additionalXdbCores -ne "")
{
    $additionalXdbCores.Split("|") | ForEach-Object {
        CreateCore $_ "xdb"
    }
}

Write-Host "Core creation complete!"