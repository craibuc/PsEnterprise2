[cmdletbinding()]
param ()

begin {
    Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin"
    import-module PsEnterprise -force
    }

process {

	try {

		$server = Read-Host -Prompt "Server"
		$account = Read-Host -Prompt "Account"
		
		$securePassword = Read-Host -AsSecureString -Prompt "Password"
		$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
		$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
		
		Get-Session -svr $server -acct $account -pwd $password | Out-Null
		
		$query = "SELECT TOP 5 si_name FROM ci_infoobjects WHERE si_kind='CrystalReport' ORDER BY si_name ASC"
		$infoObjects = Get-InfoObjects -cmd $query #| Out-Null
		
		foreach ($infoObject in $infoObjects) {
			Write-Host $infoObject.Title
		}
	}
	catch {
		write-host $_.Exception.Message
	}
	finally {
		[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
	}
}

end {Write-Verbose "$($MyInvocation.MyCommand.Name)::End"}