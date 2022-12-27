set-location "$PSScriptRoot"
$inputFile = "6sample.txt"
$inputFile = "6.txt"
$lines = Get-Content $inputFile


$markerLength = 14

foreach($line in $lines) {
    $lineLength = $line.Length
    for($i = ($markerLength-1); $i -lt $lineLength; $i++) {
        $arr = $line[($i-$markerLength+1)..($i)]
        $tmp = ($arr | Group-Object)
        if ($tmp.length -eq $markerLength) {
            write-host "You will need to process $($i+1) characters before the first start-of-packet marker has passed"
            break;
        }
    }
}