set-location "$PSScriptRoot"
$inputFile = "9sample.txt"
$inputFile = "9.txt"
#$inputFile = "9sample2.txt"

$lines = Get-Content $inputFile

$rope = [ordered]@{}
$head = @{x = 0; y = 0}
$rope.add(0,$head)
$nrTailPieces = 9
foreach($k in (1..$nrTailPieces)){
    $piece = @{x = 0; y = 0}
    $rope.add($k, $piece)
}
$visited = @{}
$visited.add("$($rope[0].x) $($rope[0].y)",$true)

function moveTailPiece($a, $b) {
    $diffX = $a.x-$b.x
    $diffY = $a.y-$b.y
    if(([Math]::Abs($diffX) -gt 1) -or ([Math]::Abs($diffY) -gt 1)) {
        $b.x += [Math]::Sign($diffX)
        $b.y += [Math]::Sign($diffY)
    }
}

foreach($line in $lines) {
    $dir, $amount = $line -split " "
    foreach($k in (1..$amount)) {
        switch($dir) {
            R { $rope[0].x += 1 }
            U { $rope[0].y += 1 }
            L { $rope[0].x -= 1 }
            D { $rope[0].y -= 1 }
            default { write-host "error parsing inputfile"}
        }
        foreach($l in (1..$nrTailPieces)){
            moveTailPiece $rope[($l-1)] $($rope[$l])
        }
        $tailLocation = "$($rope[$nrTailPieces].x) $($rope[$nrTailPieces].y)"
        if(-not($visited.($tailLocation))) {
            $visited.add($tailLocation,$true)
        }
    }
}

write-host "amount of spaces visited: $($visited.Count)"