
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
		
		Get-Session -svr $server -acct $account -pwd $password #| Out-Null
		
	}
	catch {
		write-host $_.Exception.Message
	}
	finally {
		[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
	}
}

end {Write-Verbose "$($MyInvocation.MyCommand.Name)::End"}