set-location "$PSScriptRoot"
$inputFile = "12sample.txt"
$inputFile = "12.txt"

$lines = Get-Content $inputFile

$height = $lines.Length
$width = $lines[0].Length
$start = @()
$end = @()
$hashTable = @{}
function findValidMoves($index, $arr) {
    $returnVal = @{}
    $x = $index.x
    $y = $index.y
    $returnVal.U = $false
    $returnVal.L = $false
    $returnVal.D = $false
    $returnVal.R = $false

    if($x -ne 0) {
        #check left
        $xl = $index.x-1
        $yl = $index.y
        $returnVal.L = checkValidMove $index $arr["$xl,$yl"]
    } 
    if($y -ne 0) {
        #check above
        $xu = $index.x
        $yu = $index.y-1
        $returnVal.U = checkValidMove $index $arr["$xu,$yu"]
    } 
    if($x -ne ($width-1)) {
        #check right
        $xr = $index.x+1
        $yr = $index.y
        $returnVal.R = checkValidMove $index $arr["$xr,$yr"]
    } 
    if($Y -ne ($height-1)) {
        #check below
        $xb = $index.x
        $yb = $index.y+1
        $returnVal.D = checkValidMove $index $arr["$xb,$yb"]
     } 

    return $returnVal
}

function checkValidMove($a,$b) {
    #write-host "checking $($a.x),$($a.y) vs $($b.x),$($b.y)"
    if($a.height -gt $b.height) {
        return $true
        break;
    } elseif (($b.height-$a.height) -le 1) {
        return $true
        break;
    }

    return $false
}

foreach($i in (0..($lines.Length-1))) {
    foreach($j in (0..($lines[0].Length-1))) {
        $key = "$j,$i"
        $index = @{}
        $index.x = $j
        $index.y = $i
        $index.drawIcon = "."
        $index.letter = $lines[$i][$j]
        $index.parent = $false

        if($index.letter -ceq "S") {
            write-host "Start at $i,$j"
            $start = "$j,$i"
            $index.letter = "a"
            $index.parent = "start"
        } elseif ($index.letter -ceq "E") {
            write-host "End at $i,$j"
            $end = "$j,$i"
            $index.letter = "z"
        }

        $index.height = [int][char]$index.letter - 97 #maps a to 0
        $index.visited = $false
        $index.validMoves = @{}
        $hashTable.Add($key,$index)
    }
}

foreach($index in $hashTable.keys) {
    $hashtable[$index].validMoves = findValidMoves $hashTable["$index"] $hashTable
}

$queue = @()
$queue += $hashTable[$start]
$result = @()

while($queue.Length -gt 0) {
    #dequeue first in 
    $currentVex = $queue[0]
    if($queue.Length -gt 1) {
        $queue = $queue[1..$($queue.Length-1)]
    } else { $queue = @() }
    
    if(-not($currentVex.visited)) { #if currentVex not visited yet
        $xt = $currentVex.x
        $yt = $currentVex.y
        $hashTable["$xt,$yt"].visited = $true
        $result += $currentVex

        #add edges to queue
        if($currentVex.validMoves.U) {
            $var = "$($xt),$($yt-1)"
            if(-not($hashTable["$var"].visited)){
                $queue += $hashTable["$var"]
                if(-not($hashTable["$var"].parent)) {
                    $hashTable["$var"].parent = $currentVex
                }
            }
        }
        if($currentVex.validMoves.D) {
            $var = "$($xt),$($yt+1)"
            if(-not($hashTable["$var"].visited)){
                $queue += $hashTable["$var"]
                if(-not($hashTable["$var"].parent)) {
                    $hashTable["$var"].parent = $currentVex
                }
            }
        }
        if($currentVex.validMoves.L) {
            $var = "$($xt-1),$($yt)"
            if(-not($hashTable["$var"].visited)){
                $queue += $hashTable["$var"]
                if(-not($hashTable["$var"].parent)) {
                    $hashTable["$var"].parent = $currentVex
                }
            }
        }
        if($currentVex.validMoves.R) {
            $var = "$($xt+1),$($yt)"
            if(-not($hashTable["$var"].visited)){
                $queue += $hashTable["$var"]
                if(-not($hashTable["$var"].parent)) {
                    $hashTable["$var"].parent = $currentVex
                }
            }
        }
    }
}

function drawMap {
    Write-Host ""
    for($t=0; $t -lt $height; $t++) {
        $output = ""
        for($s=0; $s -lt $width; $s++) {
            $output += $hashTable["$s,$t"].drawIcon
        }
        write-host $output
    }
    Write-Host ""
}

write-host "finding shortest path..."
$pathlength = 0
$revPath = $hashTable[$end]
while($($revPath.parent) -ne "start") {
    $pathLength += 1
    $hashTable["$($revPath.x),$($revPath.y)"].drawIcon = "X"
    $revPath = $revPath.parent
    #drawMap
}
$hashTable["$start"].drawIcon = "X"
drawmap
write-host "Pathlength: $pathlength"