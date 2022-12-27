set-location "$PSScriptRoot"
$inputFile = "8sample.txt"
#$inputFile = "8sampleCustom.txt"
#$inputFile = "8.txt"
$lines = Get-Content $inputFile

function checkVisibility($a, $b, $array, $visibleArray) {
    if (($a -eq 0) -or ($b -eq 0) -or ($a -eq $array.Length-1) -or ($b -eq $array[0].Length-1)) { #edges
        $visibleArray[$a,$b] = $true
        #write-host "visible from: edge"
    } elseif (checkAbove $a $b $array) { #above
        $visibleArray[$a,$b] = $true
        #write-host "visible from: above"
    } elseif (checkBelow $a $b $array) { #below
        $visibleArray[$a,$b] = $true
        #write-host "visible from: below"
    } elseif (checkLeft $a $b $array) { #left
        $visibleArray[$a,$b] = $true
        #write-host "visible from: left"
    } elseif (checkRight $a $b $array) { #right
        $visibleArray[$a,$b] = $true
        #write-host "visible from: right"
    } else { #tree is not visible
        #write-host "not visible from any side"
        $visibleArray[$a,$b] = $false
    }
    #printVisibilityForest $visibleArray
    #write-host "" 
}

function checkFirstLessEqualSecond($a, $b, $c, $d, $array) {
    #check if a,b less or equal than c,d
    return ($array[$a][$b] -le $array[$c][$d])
}

function checkAbove($a, $b, $array) {
    for($k = 0; $k -lt $a; $k++) {
        if(checkFirstLessEqualSecond $a $b $k $b $array) {
            return $false
            break;
        }
    }
    return $true
}
function checkBelow($a, $b, $array) {
    for($k = ($array.length-1); $k -gt $a; $k--) {
        if(checkFirstLessEqualSecond $a $b $k $b $array) {
            return $false
            break;
        }
    }
    return $true
}
function checkLeft($a, $b, $array) {
    for($k = 0; $k -lt $b; $k++) {
        if(checkFirstLessEqualSecond $a $b $a $k $array) {
            return $false
            break;
        }
    }
    return $true
}
function checkRight($a, $b, $array) {
    for($k = ($array.length-1); $k -gt $b; $k--) {
        if(checkFirstLessEqualSecond $a $b $a $k $array) {
            return $false
            break;
        }
    }
    return $true
}

function printVisibilityForest($forest) {
    for($i = 0; $i -lt $forestWidth; $i++) {
        $line = ""
        for($j = 0; $j -lt $forestDepth; $j++) {
            if($forest[$i,$j]) {
                $line += "X "
            } else {
                $line += ". "
            }
        }
        write-host $line
    }
}

function printForest($forest) {
    for($i = 0; $i -lt $forest.Length; $i++) {
        $line = ""
        for($j = 0; $j -lt $forest[0].length; $j++) {
            $line += "$($forest[$i][$j]) "
        }
        write-host $line
    }
}

function checkAmountLeft($g, $h, $arr) {
    for($i = 1; $i -lt $h; $i++) {
        if(checkFirstLessEqualSecond $g $h $g $($h-$i) $arr) {
            #write-host "left trees $i"
            break;
        }
    }
    return $i
}
function checkAmountRight($g, $h, $arr) {
    $k = 1
    for($i = ($h+1); $i -lt ($arr[0].length-1); $i++,$k++) {
        if(checkFirstLessEqualSecond $g $h $i $h $arr) {
            #write-host "right trees $k"
            break;
        }
    }
    return $k
}
function checkAmountUp($g, $h, $arr) {
    for($i = 1; $i -lt $g; $i++) {
        if(checkFirstLessEqualSecond $g $h $($g-$i) $h $arr) {
            #write-host "up trees $i"
            break;
        }
    }
    return $i
}
function checkAmountDown($g, $h, $arr) {
    $k = 1
    for($i = ($g+1); $i -le ($arr[0].length-1); $i++, $k++) {
        if(checkFirstLessEqualSecond $g $h $i $h $arr) {
            #write-host "down trees $k"
            break;
        }
    }
    return $k
}

$forestDepth = $lines.Count
$forestWidth = $lines[0].Length
$visibleArray = New-Object 'object[,]' $forestWidth,$forestDepth

for($i = 0; $i -lt $forestWidth; $i++) {
    for($j = 0; $j -lt $forestDepth; $j++) {
        $visibleArray[$i,$j] = $false
    }
}

for($i = 0; $i -lt $forestWidth; $i++) {
    for($j = 0; $j -lt $forestDepth; $j++) {
        if(-not ($visibleArray[$i,$j])) {
            checkVisibility $i $j $lines $visibleArray
        }
    }
}
<#
write-host ""
printForest $lines
write-host ""
printVisibilityForest $visibleArray
#>

$amountOfVisibleTrees = ($visibleArray | Where-Object {$_ -eq $True}).Count
write-host "Amount of visible trees from around the forest: $amountOfVisibleTrees"

$scenicScore = @{}
for([int]$s = 1; $s -lt $lines.Length -1; $s++){
    for([int]$t = 1; $t -lt $lines.Length -1; $t++){
        if(($s -eq 49) -and ($t -eq 14)){
            write-host "reached supposed max value, lets investigate why we get the wrong result"
        }
        #write-host "checking index $s,$t"
        $left = checkAmountLeft $s $t $lines 
        $right = checkAmountRight $s $t $lines 
        $up = checkAmountUp $s $t $lines 
        $down = checkAmountDown $s $t $lines 
        $amount = $left * $right * $up *$down
        $var = ""
        if ($s -le 9) {
            $var += "0"+ "$s"
        } else {
            $var += "$s"
        }
        if ($t -le 9) {
            $var += "0" + "$t"
        } else {
            $var += "$t"
        }
        $scenicScore.add($var, $amount)
        #calculate scenic score
    }
}
$maxScenicScore = ($scenicSCore.values | Sort-Object -Descending | Select-Object -first 1)
write-host "maximum Scenic Score: $maxScenicScore"
$maxKey = ($scenicScore.GetEnumerator() | Where-Object { $_.Value -eq "$maxScenicScore" }).key
write-host "this is at index $maxKey"