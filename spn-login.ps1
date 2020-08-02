param(
    [Parameter(Mandatory=$true)]
    [string]$JsonFile
)

$json = Get-Content -Raw -Path $jsonfile | ConvertFrom-Json
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$passwd = ConvertTo-SecureString $json[0].object.SPN_PW -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($json[0].object.SPN_ID, $passwd) 
$Azure = Get-AzEnvironment 'AzureCloud'
Login-AzAccount -Environment $Azure -TenantId $json[0].object.TENANT_ID -Credential $cred -ServicePrincipal -WarningAction Ignore
Write-Host
Write-Host -ForegroundColor Green "You are authenicated (SPN) by:"
Write-Host -ForegroundColor Red  ("SPN_ID    : " + $json[0].object.SPN_ID)
Write-Host -ForegroundColor Red  ("TENANT_ID : " + $json[0].object.TENANT_ID)
Write-Host -ForegroundColor Green "Don't forget to select a Subscrtiption by going ahead."
Write-Host -ForegroundColor Gray (Get-AzSubscription | Select-Object Name,ID,State | Where-Object {$_.Status -ne "Disabled"})