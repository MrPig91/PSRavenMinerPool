function Get-rvnPoolCurrency {
    $Currencies = Invoke-RestMethod -Uri "https://www.ravenminer.com/api/currencies"
    $currencyNames = ($Currencies | Get-Member -MemberType NoteProperty).Name
    foreach ($name in $currencyNames){
        $Currencies.$name
    }
}