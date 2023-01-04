set-location "$PSScriptRoot"
$inputFile = "14sample.txt"
$inputFile = "14.txt"
$lines = get-content $inputFile

$part1 = $false

function getExtremes($lline, $xxmin, $xxmax, $yymax) {
    $wallPartDescriptors = $lline -split " -> "
    for($k=0; $k -lt $wallPartDescriptors.Length; $k++) {
        [int]$x, [int]$y = $wallPartDescriptors[$k] -split ","
        if($x -lt $xxmin) { $xxmin = $x}
        if($x -gt $xxmax) { $xxmax = $x}
        if($y -gt $yymax) { $yymax = $y}
    }
    return [int]$xxmin, [int]$xxmax, [int]$yymax
}

function visualizeGrid($gridToVis) {
    $ll = ""
    for($l=0; $l -le $ymax; $l++, ($ll += "`n")) {
        for($k=$xmin; $k -le $xmax; $k++) {
            if($gridToVis.containsKey("$k,$l")) {
                $ll += $gridToVis["$k,$l"]
            } else {
                $ll += "."
            }
        }
    }
    write-host "$ll"
}

function dropSandPiece($sX, $sY, $inGrid, $cont) {
    
    if($part1) {
        if($($sY+1) -gt $ymax) { #check if in Abyss     
        $cont = $false
        break;
        }
    }
    
    if(-not($inGrid.containsKey("$sX,$($sY+1)"))) { #check directly below
        $inGrid, $cont = dropSandPiece $sX $($sY+1) $inGrid $cont
    } elseif(-not($inGrid.containsKey("$($sX-1),$($sY+1)"))) { #check left below
        $inGrid, $cont = dropSandPiece $($sX-1) $($sY+1) $inGrid $cont
    } elseif(-not($inGrid.containsKey("$($sX+1),$($sY+1)"))) { #check right below
        $inGrid, $cont = dropSandPiece $($sX+1) $($sY+1) $inGrid $cont
    } else { #piece should stay here
        if("$sx,$sy" -eq $sandSourcePos) {
            $inGrid["$sX,$sY"] = "o"
            $cont = $false
            break;
        } else {
            $inGrid.add("$sX,$sY", "o")
        }
    }

    return $inGrid, $cont
}

$sandSourcePos = "500,0"
$xmin, $xmax = $sandSourcePos -split ","
$ymax = 0
foreach($line in $lines) {
    $xmin, $xmax, $ymax = getExtremes $line $xmin $xmax $ymax
}

$grid = @{}
$grid.Add("500,0",'S')
foreach($line in $lines) {
    $wallDescriptors = $line -split " -> "
    for($k=0; $k -lt ($wallDescriptors.Length -1); $k++) {
        $x1, $y1 = $wallDescriptors[$k] -split ","
        $x2, $y2 = $wallDescriptors[($k+1)] -split ","
        foreach($xcord in ($($($x1)..$($x2)))) {
            foreach($ycord in ($($($y1)..$($y2)))) {
                if(-not($grid.ContainsKey("$xcord,$ycord"))) {
                    $grid.add("$xcord,$ycord",'#')
                }
            }
        }
    }
}

if(-not($part1)) {
    $ymax = $ymax + 2
    $xmin = 500 - $ymax
    $xmax = 500 + $ymax
    for($k = ($xmin);$k -le ($xmax); $k++) {
        $grid.add("$k,$ymax","#")
    }
}

$fallingSand = $true
$sandPieces = 0

while($fallingSand) {
    [int]$x, [int]$y = $sandSourcePos -split ","
    #drop piece at 500,0
    $grid, $fallingSand = dropSandPiece $x $y $grid $fallingSand
    if($fallingSand) {
        $sandPieces++
    }
}

visualizeGrid $grid
if(-not($part1)) { #count extra piece at 500,0
    $sandPieces++
}
write-host "total sandpieces: $sandPieces"