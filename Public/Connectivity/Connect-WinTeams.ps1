function Connect-WinTeams {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft Teams',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile,
        [switch] $Output
    )

    $Credentials = Request-Credentials -UserName $Username `
        -Password $Password `
        -AsSecure:$AsSecure `
        -FromFile:$FromFile `
        -Service $SessionName `
        -Output

    if ($Credentials -isnot [PSCredential]) {
        if ($Output) {
            return $Credentials
        } else {
            return
        }
    }
    try {
        $Session = Connect-MicrosoftTeams -Credential $Credentials -ErrorAction Stop
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinTeams - Failed with error message: $ErrorMessage"
            return
        }
    }
    if (-not $Session) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}