set-location "$PSScriptRoot"
$inputFile = "9sample.txt"
$inputFile = "9.txt"
$lines = Get-Content $inputFile

$Hpos = @(0,0)
$Tpos = @(0,0)
$visited = @{}
$visited.add("$Tpos", $true)

function step($head, $tail, $ammount, $dir) {

}

foreach($line in $lines) {
    $dir, $amount = $line -split " "
    foreach($k in (1..$amount)) {
        switch($dir) {
            R { $Hpos[0] += 1 }
            U { $Hpos[1] += 1 }
            L { $Hpos[0] -= 1 }
            D { $Hpos[1] -= 1 }
            default { write-host "not found"}
        }
        $diffX = $Hpos[0]-$Tpos[0]
        $diffY = $Hpos[1]-$Tpos[1]
        if(([Math]::Abs($diffX) -gt 1) -or ([Math]::Abs($diffY) -gt 1)) {
            $Tpos[0] += [Math]::Sign($diffX)
            $Tpos[1] += [Math]::Sign($diffY)
            if(-not($visited.("$Tpos"))) { $visited.add("$Tpos",$true) }
        }
    }
}

write-host "final position of Head: $($Hpos[0]),$($Hpos[1])"
write-host "final position of Tail: $($Tpos[0]),$($Tpos[1])"

$spacesVisited = $visited.Count
write-host "amount of spaces visited: $spacesVisited"