set-location "$PSScriptRoot"
$inputFile = "5sample.txt"
$inputFile = "5.txt"
$lines = Get-Content $inputFile

$stacks=@{}

function moveStackOfCrates($amount, $from, $to) {

    for($i = 0; $i -lt $amount; $i++){ #first, copy all crates
        $stacks[$to] += $stacks[$from][($stacks[$from].Length - $amount + $i)]
    }
    if ($stacks[$from].length -eq $amount) { #then remove them in bulk
        $stacks[$from] = @()
    } else {
        $stacks[$from] = $stacks[$from][0..($stacks[$from].Length - $amount -1)]
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
    $line = $lines | Select-Object -skip $i -first 1
    for($j=1;$j -lt $line.Length;$j+=4){
        $crateLetter = $line[$j]
        $column = $(($j-1)/4+1)
        
        if(-not $stacks.ContainsKey($column)){$stacks.Add($column,@())}
        if($crateLetter -ne " "){
            $stacks[$column] += $crateLetter
        }
    }
}
write-host "Stacks have been populated!"
write-host "From bottom to top:"
$stacks

foreach($line in $lines){
    if($line -notlike "move*"){
        continue;
    }
    $commands = $line -split " "
    $amount = [int]$commands[1]
    $from = [int]$commands[3]
    $to = [int]$commands[5]

    moveStackOfCrates $amount $from $to
}

$topCrates = ""
for($i=1;$i -le $amountOfColumns; $i++){
    $topInColumn = $stacks[$i][($stacks[$i].length-1)]
    $topCrates += $topInColumn
}
write-host "top crates: $topCrates"