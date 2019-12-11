
Set-StrictMode -Version Latest

Get-ChildItem -Path "$PSScriptRoot\functions" -Filter '*.ps1' -Recurse | ForEach-Object {
    . $_.FullName
    Export-ModuleMember -Function $_.BaseName
}

$Script:NotConnectedMessage = 'No connection supplied or stored. Please either call `Connect-Zendesk` or call `Get-ZendeskConnection` and pass the result to all additional calls.'
$Script:InvalidConnection = 'Provided connection is invalid.'
