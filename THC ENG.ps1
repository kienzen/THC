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
Write-Host "Marijuana consumption time - calculation script"
Write-Host "==================================================="
Write-Host 'IMPORTANT! USE A POINT AND NOT A COMMA AS A DECIMAL SEPARATOR!
GOOD: 8.3 BAD: 8,3'
Write-Host "==================================================="

$PlasmaTHC = Read-Host -Prompt 'Please input the measured blood THC concentration'
$TimeInMinutes = Read-Host -Prompt "Time between the incident and taking of the blood sample, in minutes"
$PlasmaTHCCOOH = Read-Host -Prompt 'Please input the measured blood THCOOH concentration.If unavailable, press ENTER to omit the second model.'

<#Model 1#>
[System.Collections.Hashtable]$dane = calculateTHC -PlasmaTHC $PlasmaTHC

$wynik = "According to Model I marijuana consuption occured " + $dane.T + " minutes ago. With 95% confidence, it occured between " + $dane.LowerCI + " minuts ago, and " + $dane.UpperCI + " minutes ago."

Write-Host "==================================================="
Write-Output ""
Write-Output ""

Write-Output $wynik

<#Model 2 - opcjonalny#>
if (![string]::IsNullOrEmpty($PlasmaTHCCOOH)) {

    [System.Collections.Hashtable]$dane2 = calculateTHCCOOH -PlasmaTHC $PlasmaTHC -PlasmaTHCCOOH $PlasmaTHCCOOH

    $wynik2 = "According to Model II marijuana consuption occured " + $dane2.T + " minutes ago. With 95% confidence, it occured between " + $dane2.LowerCI + " minutes ago, and " + $dane2.UpperCI + " minutes ago."

    Write-Output ""
    Write-Output $wynik2
    Write-Output ""

}

<#THC w chwili zdarzenia#>
$THCZdarzenie = [double]$PlasmaTHC * [Math]::Pow(2, ($TimeInMinutes/168))
$wynik3 = "THC concentration at the time of incident: " + $THCZdarzenie

Write-Output $wynik3
Write-Output ""
Write-Output ""
Write-Output ""
Write-Output ""
Read-Host -Prompt "Press ENTER to quit"