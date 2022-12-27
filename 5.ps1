set-location "$PSScriptRoot"
$inputFile = "5sample.txt"
$inputFile = "5.txt"
$lines = Get-Content $inputFile

$stacks=@{}

function moveSingleCrate($from, $to) {
    $stacks[$to] += $stacks[$from][$($stacks[$from]).length-1]
    if($stacks[$from].length -eq 1) {
        $stacks[$from] = @()
    } else {
        $tempStack = $stacks[$from][0..($stacks[$from].length-2)] #-2 due to removing last entry
        $stacks[$from] = $tempStack
    }
}


$maxHeight = 0
foreach($line in $lines){
    if($line -notlike "*[[]*") {
        $amountOfColumns = $($line -replace " ","").Length
        break
    }
    $maxHeight++
}

for($i=$maxHeight-1; $i -ge 0; $i--){
    $column=1
    $line = $lines | Select -skip $i -first 1
    for($j=1;$j -lt $line.Length;$j+=4){
        $crateLetter = $line[$j]
        $column = $(($j-1)/4+1)
        
        if(-not $stacks.ContainsKey($column)){$stacks.Add($column,@())}
        if($crateLetter -ne " "){
            $stacks[$column] += $crateLetter
        }
    }
}

foreach($line in $lines){
    if($line -notlike "move*"){
        continue;
    }
    $commands = $line -split " "
    $amount = [int]$commands[1]
    $fromColumn = [int]$commands[3]
    $toColumn = [int]$commands[5]
    for($i=1;$i -le $amount; $i++) {
        moveSingleCrate $fromColumn $toColumn
    }
}

$topCrates = ""
for($i=1;$i -le $amountOfColumns; $i++){
    $topInColumn = $stacks[$i][($stacks[$i].length-1)]
    $topCrates += $topInColumn
}
write-host "top crates: $topCrates"