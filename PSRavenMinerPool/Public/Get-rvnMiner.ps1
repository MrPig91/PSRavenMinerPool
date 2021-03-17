function Get-rvnMiner {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("WalletAddress")]
        [string[]]$Address
    )

    Process {
        foreach ($add in $Address){
            (Get-rvnWalletStatus -Address $add -IncludeMiners).Miners
        }
    }
}