set-location "$PSScriptRoot"
$inputFile = "13sample-small.txt"
$inputFile = "13sample.txt"
$inputFile = "13.txt"

function insertLists($aa, $bb) {
    $a = $aa -split ",|(\[)|(\])"
    $a = $a.split('',[System.StringSplitOptions]::RemoveEmptyEntries)
    $b = $bb -split ",|(\[)|(\])"
    $b = $b.split('',[System.StringSplitOptions]::RemoveEmptyEntries)
    
    $g = joinArray $a
    $h = joinArray $b
    $orderedRight = $false

    for($k=0;$k -lt $a.length; $k++) {
        if($a[$k] -eq "[" -and ($b[$k] -eq "[")) {
#            write-host "both START of list"
        } elseif (($a[$k] -match '\d') -and ($b[$k] -match '\d')) {
            if([int]$a[$k] -lt [int]$b[$k]) {
                #left is smaller, NOT right order
                $orderedRight = $true
                break;
            } elseif([int]$a[$k] -gt [int]$b[$k]) {
                #right is smaller, NOT right order
                $orderedRight = $false
                break;
            } elseif([int]$a[$k] -eq [int]$b[$k]) {
                #same numbers, continue searching
            } else {
                write-host "this situation shouldnt ever occur"
            }
#            write-host "both numbers - a: $($a[$k]), b: $($b[$k])"
        } elseif ($a[$k] -eq "]" -and ($b[$k] -eq "]")) {
#            write-host "both END of list"
        } elseif (($a[$k] -match '\d') -and ($b[$k] -eq "[")) {
            #a digit, $b start of list
#            write-host "converting $($a[$k]) to list"
            $a = insertCharacter $a $($k+1) "]"
            $a = insertCharacter $a $k "["
            $k = 0 #start over from start
            $g = joinArray $a #ease of debugging
        } elseif (($b[$k] -match '\d') -and ($a[$k] -eq "[")) {
            #b digit, $a start of list
#            write-host "converting $($b[$k]) to list"
            $b = insertCharacter $b $($k+1) "]"
            $b = insertCharacter $b $k "["
            $k = 0 #start over from start
            $h = joinArray $b #ease of debugging
        } elseif(($a[$k] -match '\d') -and ($b[$k] -eq "]")) {
#            write-host "a number, b closing list -> right out of items -> wrong order
            $orderedRight = $false
            break;
        } elseif(($a[$k] -eq "]") -and ($b[$k] -match '\d')) {
#            write-host "a closing list, b number -> left ran out of items -> right order"
            $orderedRight = $true
            break;
        } elseif($k -eq $b.Length) {
            break            
        } elseif(($a[$k] -eq "[") -and ($b[$k] -eq "]")) {
            #b ran out of numbers, NOT in order
            $orderedRight = $false
            break;
        } elseif(($a[$k] -eq "]") -and ($b[$k] -eq "[")) {
            #a ran out of numbers, so IN order
            $orderedRight = $true
            break;
        } elseif($k -eq ($a.length-1)) {
            #reached end of a, which puts them in right order
            $orderedRight = $false
            break;
        } else {
            write-host "unsolved situation - a: $($a[$k]), b: $($b[$k])"
        }
    }
    #join variables
    $g = joinArray $a
    $h = joinArray $b
    return $orderedRight
}

function joinArray($arr) {
    $g = ""
    for($k=0; $k -lt $arr.Length; $k++) {
        if(($arr[$k] -eq "[") -or ($arr[$k] -eq "]")) {
            $g += $arr[$k]
            if($arr[$k] -eq "]") {
                if(($arr[$k+1] -eq "[") -or ($arr[$k+1] -match '\d')) {
                    $g += ","
                }
            }
        } else {
            $g += $arr[$k]
            if($($arr[$k+1]) -ne "]") {
                $g += ","
            }
        }
    }
    return $g
}

function insertCharacter($arr, $i, $c) {
    $v = $arr[0..($i-1)]
    $w = $arr[$i..($arr.length)]
    $output = $v + $c + $w
    return $output
}

$lines = Get-Content $inputFile
$index = 0
$indexSum = 0

for($i = 0; $i -lt $lines.Length; $i = $i +3) {
    $index++
    $first = $lines[$i]
    $second = $lines[$i+1]

    $orderedRight = insertLists $first $second

    if($orderedRight) {
        $indexSum += $index
    }
}

write-host "program done. Total sum of indeces: $indexSum"

<# part two #>
<# index of divider [[2]] is the amount of lines which are smaller than [[2]]#>
<# index of divider [[6]] is the amount of lines which are smaller than [[6]] plus 1#>

$pos2 = 1
$pos6 = 2

for($i=0; $i -lt $lines.Length; $i++) {
    if($i % 3 -eq 2) {
        <# this is a blank line, lets skip it #>
    } else {
        if(insertLists $lines[$i] "[[2]]") {
            $pos2++
            $pos6++
        } elseif(insertLists $lines[$i] "[[6]]") {
            $pos6++
        }
    }
}
$mult = $pos2 * $pos6
write-host "distress signal decoder: $mult"