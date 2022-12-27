set-location "$PSScriptRoot"
$inputFile = "1sample.txt"
$inputFile = "1.txt"

$elves = @(); $elves += 0
#$inputFile = "1sample.txt"
foreach($line in get-content $inputFile) {
    if($line -eq ''){
        $elves += 0
    } else {
        $elves[$elves.Length-1] += $line
    }
}

$mostCalories = $elves | sort-object -Descending | select-object -first 1

Write-Host "Elf $($elves.IndexOf($mostCalories)+1) has the most calories: $($mostCalories)"


$top = $elves | sort-object -Descending | select-object -first 3
$sum = 0
foreach($line in $top){
    $sum += $line
}
Write-Host "total calories: $sum"