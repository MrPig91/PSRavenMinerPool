function Get-rvnPoolStatus {
    try{
        $Algorithms = Invoke-RestMethod -Uri "https://www.ravenminer.com/api/status"
        $algoNames = ($Algorithms | Get-Member -MemberType NoteProperty).Name
        foreach ($algo in $algoNames){
            $Algorithms.$algo
        }
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}