set-location "$PSScriptRoot"
$inputFile = "4sample.txt"
$inputFile = "4.txt"

$contains = 0
$overlaps = 0

function get-contains($1,$2,$3,$4) {
    if(($1..$2) -contains $3 -and ($1..$2) -contains $4) {return "true";break}
    if(($3..$4) -contains $1 -and ($3..$4) -contains $2) {return "true";break}
}

function get-overlaps($1,$2,$3,$4) {
    if(($1..$2) -contains $3 -or ($1..$2) -contains $4) {return "true";break}
    if(($3..$4) -contains $1 -or ($3..$4) -contains $2) {return "true";break}
}

foreach($line in get-content $inputFile){
    $parts= $line -split ","
    $parts = $parts -split "-"
    [int]$1 = $parts[0]
    [int]$2 = $parts[1]
    [int]$3 = $parts[2]
    [int]$4 = $parts[3]

    if(get-contains $1 $2 $3 $4){$contains++}
    if(get-overlaps $1 $2 $3 $4){$overlaps++}
}
Write-Host "$contains Elves have containing jobs"
Write-Host "$overlaps Elves have overlapping jobs"