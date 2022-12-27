set-location "$PSScriptRoot"
$inputFile = "3sample.txt"
$inputFile = "3.txt"

$prioritySum = 0
$i = 1
function compareLines() {
    param ($first, $second, $third)
    $commonFirst = Compare-Object $first $second -PassThru -IncludeEqual -ExcludeDifferent
    $commonAll = Compare-Object $commonFirst $third -PassThru -IncludeEqual -ExcludeDifferent
    return $commonAll
}

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
    switch($i){
        1 {$first = $line.ToCharArray() | Sort-Object}
        2 {$second = $line.ToCharArray() | Sort-Object}
        3 {
            $third = $line.ToCharArray() | Sort-Object
            $common = compareLines $first $second $third
            $prioritySum += (get-value $common)
        }
    }
    $i = $i%3+1
}


Write-Host "Total Sum: $prioritySum"