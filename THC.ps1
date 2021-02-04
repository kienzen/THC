function calculateTHC {
    param(
        [Parameter(Mandatory = $true)]
        [double]$PlasmaTHC
    )

    $results = New-Object System.Collections.Hashtable

    $LogT = -0.698*([Math]::Log10($PlasmaTHC))+ 0.687
    $T = ([Math]::Pow(10,$LogT))*60

    $LOG_THC_UpperCI = $LogT + 0.343
    $T_UpperCI = ([Math]::Pow(10, $LOG_THC_UpperCI))*60
    $LOG_THC_LowerCI = $LogT - 0.343
    $T_LowerCI = ([Math]::Pow(10, $LOG_THC_LowerCI))*60

    $null = $results.add("LowerCI", [Math]::Round($T_LowerCI))
    $null = $results.add("T",[Math]::Round($T))
    $null = $results.add("UpperCI",[Math]::Round($T_UpperCI))

return $results
}

function calculateTHCCOOH {
    param(
        [Parameter(Mandatory = $true)]
        [double]$PlasmaTHC,
        [Parameter(Mandatory = $true)]
        [double]$PlasmaTHCCOOH
    )

    $results = New-Object System.Collections.Hashtable

    $LogT = 0.576*([Math]::Log10($PlasmaTHCCOOH/$PlasmaTHC))-0.176
    $T = ([Math]::Pow(10,$LogT))*60

    $LOG_THC_UpperCI = $LogT + 0.42
    $T_UpperCI = ([Math]::Pow(10, $LOG_THC_UpperCI))*60
    $LOG_THC_LowerCI = $LogT - 0.42
    $T_LowerCI = ([Math]::Pow(10, $LOG_THC_LowerCI))*60

    $null = $results.add("LowerCI", [Math]::Round($T_LowerCI))
    $null = $results.add("T",[Math]::Round($T))
    $null = $results.add("UpperCI",[Math]::Round($T_UpperCI))

return $results
}

Write-Host "==================================================="
Write-Host "Skrypt obliczajacy szacunkowy czas spozycia marihuany"
Write-Host "==================================================="
Write-Host 'UWAGA! PROSZE UZYC KROPKI, NIE PRZECINKA DLA WARTOSCI ULAMKOWYCH!
Dobrze: 8.3 Źle: 8,3'
Write-Host "==================================================="

$PlasmaTHC = Read-Host -Prompt 'Prosze wpisac zmierzona zawartosc THC we krwi'
$TimeInMinutes = Read-Host -Prompt "Czas od zdarzenia do pobrania, w minutach"
$PlasmaTHCCOOH = Read-Host -Prompt 'Prosze wpisac zmierzona zawartosc THCCOOH we krwi. Jesli wartosc nie jest określona, prosze wcisnac ENTER aby pominac'

<#Model 1#>
[System.Collections.Hashtable]$dane = calculateTHC -PlasmaTHC $PlasmaTHC

$wynik = "Wedlug Modelu I, spozycie nastapilo około " + $dane.T + " minut temu. Z 95% prawdopodobieństwem nastapilo pomiedzy " + $dane.LowerCI + " minut temu, a " + $dane.UpperCI + " minut temu."

Write-Host "==================================================="
Write-Output ""
Write-Output ""

Write-Output $wynik

<#Model 2 - opcjonalny#>
if (![string]::IsNullOrEmpty($PlasmaTHCCOOH)) {

    [System.Collections.Hashtable]$dane2 = calculateTHCCOOH -PlasmaTHC $PlasmaTHC -PlasmaTHCCOOH $PlasmaTHCCOOH

    $wynik2 = "Wedlug Modelu II, spozycie nastapilo około " + $dane2.T + " minut temu. Z 95% prawdopodobieństwem nastapilo pomiedzy " + $dane2.LowerCI + " minut temu, a " + $dane2.UpperCI + " minut temu."

    Write-Output ""
    Write-Output $wynik2
    Write-Output ""

}

<#THC w chwili zdarzenia#>
$THCZdarzenie = [double]$PlasmaTHC * [Math]::Pow(2, ($TimeInMinutes/168))
$wynik3 = "THC w chwili zdarzenia: " + $THCZdarzenie

Write-Output $wynik3
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Read-Host -Prompt "Nacisnij klawisz ENTER zeby zamknac"