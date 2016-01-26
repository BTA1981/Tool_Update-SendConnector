# Set variables
[string]$Site = "https://relay.zorgmail.nl/domainbook.txt"
[string]$Export = "D:\Mgmt\Zorgmail\domeinen.txt"
$emailspaces = @() # Empty Array

# Load Exchange cmdlets
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

# Create new object with .NET webclient class
$domeinen = New-Object net.webclient

# Get content of site
$domeinen = $domeinen.DownloadString($Site)

# Loop through contents, split each line and put it into an array
foreach($domein in $domeinen.split("`n")) { $emailspaces = $emailspaces + $domein }

# Filter out first line (index [0] and last 2 lines with empty spaces (total count -2))
$emailspaces = $emailspaces[1..($emailspaces.count - 2)]

#test
$emailspaces | out-file $Export

#Fill send connector with address space 
Set-SendConnector -Identity "Zorgmail" -AddressSpaces $emailspaces -verbose #-whatif
