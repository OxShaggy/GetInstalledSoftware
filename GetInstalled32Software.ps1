#Taken from https://devblogs.microsoft.com/scripting/use-powershell-to-quickly-find-installed-software/
## NOTE THIS DOES NOT WORK YET
### It runs in ISE but not by itself. One line cmd: Get-WmiObject -Class Win32_Product | Select-Object -Property Name
#### Run at your own Risk!! Win32_Product QUERIES and CHANGES everything in Product and Features. If system is healthy, no isssue but slowness. If ther are problems, it may corrupt data in programs

$computername=$env:computername

#key that holds Currently Installed Software
	 $UninstallKey=”SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall”  
	
#Create an isntance of the registry object
	$reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername)  

#Drill down into the Uninstall key using the OpenSubKey Method
	$regkey=$reg.OpenSubKey($UninstallKey)  
	
#Retreive an array of string that contains all the subkey names
	$subkeys=$regkey.GetSubKeyNames()  

#Open each subkey and use the GetValue method to return the string for DisplayName for each
foreach ($key in $subkeys)
{
		$thiskey=$UninstallKey+"\\"+$key
		$thisSubKey=$reg.OpenSubKey($thiskey)
		$DisplayName=$thisSubKey.GetValue("DisplayName")
		Write-Host $$computername, $DisplayName
}