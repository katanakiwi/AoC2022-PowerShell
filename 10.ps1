set-location "$PSScriptRoot"
$inputFile = "10sample.txt"
$inputFile = "10.txt"

$lines = Get-Content $inputFile
$cycles = @()
$x = 1

foreach($line in $lines) {
    $cycles += $x
    $operation, $amount = $line -split " "
    if($operation -eq "addx") {
        $cycles += $x
        $x += $amount
    }
}
$i = @()
(0..5).foreach{ $i += (20*(1+2*$_))}

$signalStrength = 0
foreach($k in $i) {
    write-host "during cycle $k, the value of X is: $($cycles[($k -1)])"
    $signalStrength += ($cycles[$k]*$k)
}
write-host "Final signal strength: $signalStrength`n"
write-host "now visualizing CRT`n"
$output = ""
foreach($cycle in (0..(($cycles.Length)-1))){
    if(($cycle % 40) -in (($cycles[$cycle]-1),$cycles[$cycle],($cycles[$cycle]+1))) {
        $output += "▓▓"
    } else {
        $output += "░░"
    }
    if((($cycle+1) % 40) -eq 0){
        $output += "`n"
    }
}
$output