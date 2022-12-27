set-location "$PSScriptRoot"
$inputFile = "3sample.txt"
$inputFile = "3.txt"

$prioritySum = 0

function get-value() {
    param($a)
    
    $value = [int[]][char[]]$a
    if($value[0] -gt 91){
        $value = $value[0] -96
    } else {
        $value = $value[0] -38
    }
    return $value
}

foreach($line in get-content $inputFile){
    $halfLength =  $line.Length/2
    $left = $($line.Substring(0,$halfLength)).toCharArray()
    $right = $($line.Substring($halfLength)).toCharArray()
    $doubleChar = Compare-Object $left $right -PassThru -includeEqual -ExcludeDifferent

    $prioritySum += (get-value $doubleChar[0])
}

Write-Host "Total Sum: $prioritySum"