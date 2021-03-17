<#
.SYNOPSIS
    This function will grab your wallet mining status and includes your miners if you use the IncludeMiners switch.
.DESCRIPTION
    This function will grab your wallet mining status and includes your miners if you use the IncludeMiners switch.
.EXAMPLE
    PS C:\> Get-rvnWalletStatus -Address "RT55FzSWAYv8FoMSohceAu5qFBeo2UwrvF" -IncludeMiners -OutVariable Status

    currency : RVN
    unsold   : 0.72561798
    balance  : 2.27226802
    unpaid   : 2.99788600
    paid24h  : 11.37018751
    total    : 14.36807351
    miners   : {@{version=GMiner/2.44; password=x; ID=Example; algo=kawpow; difficulty=0.05332044; subscribe=0; accepted=19138793.663; rejected=0}}
    
    PS C:\>$Status.miners

    Id   algo   difficulty accepted     rejected version     password subscribe
    --   ----   ---------- --------     -------- -------     -------- ---------
    Test kawpow 0.05233044 19138793.663 0        GMiner/2.44 x        0

    This example gets general information associated with your receiving wallet address used with RavenMiner pool along with all your miners.
    We use the outvariable paramter to also store the results in the variable $Status. We then display all our miners by running $Status.miners

.INPUTS
    [String] Wallet Address
.OUTPUTS
    PSCustomObject
.NOTES
    API's can change, please report any issues to the github for this module. If you want to leave a tip to the author of this module use the address in the example.
#>
function Get-rvnWalletStatus {
    [cmdletbinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("WalletAddress")]
        [string[]]$Address,
        [switch]$IncludeMiners
    )

    Begin{
        if ($IncludeMiners){
            $url = "https://www.ravenminer.com/api/walletEx?address="
        }
        else{
            $url = "https://www.ravenminer.com/api/wallet?address="
        }
    } #begin

    Process{
        foreach ($add in $Address){
            try{
                $Status = Invoke-RestMethod -Uri ($url + $add) 
                if ([string]::IsNullOrEmpty($Status)){
                    Write-Warning "The command ran successfully but no wallet was found, please check your wallet address and try again"
                }
                else{
                    if ($IncludeMiners){
                        $Status.miners | foreach {$_.psobject.TypeNames.Insert(0,"PSRavenMinerPool.Miner")}
                    }
                    $Status
                }
            }
            catch{
                $PSCmdlet.WriteError($_)
            }
        } #foreach
    } #process
}