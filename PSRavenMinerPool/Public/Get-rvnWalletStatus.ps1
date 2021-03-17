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