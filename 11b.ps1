set-location "$PSScriptRoot"
$inputFile = "11sample.txt"
#$inputFile = "11.txt"

$lines = Get-Content $inputFile
$monkeys = @()

$rounds = 1000

foreach($line in $lines) {
    $line = $line.trim()
    $parts = $line -split " "
    $parts = $parts.Trim(",");
    if($parts[0] -eq "Monkey") {
        $monkey = @{}
        $monkey.number = $parts[1].trim(":")
        [int[]]$monkey.items = @()
        $monkey.inspections = 0
    } elseif ($parts[0] -eq "Starting") {
        $nrItems = $parts.length
        for($k = 2; $k -lt $nrItems; $k++) {
            $monkey.items += [int]$parts[$k]
        }
    } elseif ($parts[0] -eq "Operation:") {
        $monkey.operator = $parts[4]
        $monkey.operatorAmount = $parts[5]
        #aaa
    } elseif ($parts[0] -eq "Test:") {
        $monkey.test = [int]$parts[3]
        #bb
    } elseif ($parts[0] -eq "If") {
        if($parts[1] -eq "true:") {
            $monkey.true = [int]$parts[5]
        } else {
            $monkey.false = [int]$parts[5]
        }
    } else {
        $monkeys += $monkey
    }
}

foreach($round in 1..$rounds) {
    foreach($k in (0..($monkeys.length-1))) {
        if($monkeys[$k].items.Length -gt 0) {
            foreach($l in (0..($monkeys[$k].items.Length-1))) {
                #inspect item
                $monkeys[$k].inspections++

                #increase worry level
                $amount = [int]0
                if($monkeys[$k].operatorAmount -eq "old") { 
                    $amount = [int]$monkeys[$k].items[$l]
                } else {
                    $amount = [int]$monkeys[$k].operatorAmount
                }
                if($monkeys[$k].operator -eq "*") {
                    $monkeys[$k].items[$l] = ($monkeys[$k].items[$l] * $amount)
                } elseif ($monkeys[$k].operator -eq "+") {
                    $monkeys[$k].items[$l] = ($monkeys[$k].items[$l] + $amount)
                }

                #divide worry level
                $monkeys[$k].items[$l] = [Math]::floor($monkeys[$k].items[$l]/3)
                if($monkeys[$k].items[$l] -ge 9699690) {
                    $monkeys[$k].items[$l] -= 9699690
                }
                #test application
                if(($monkeys[$k].items[$l] % $monkeys[$k].test) -eq 0) {
                    $monkeys[$monkeys[$k].true].items += $monkeys[$k].items[$l]
                    #throw true
                } else {
                    $monkeys[$monkeys[$k].false].items += $monkeys[$k].items[$l]
                    #throw false
                }
                # I would remove the item here and operate on index[0] the next iteration,
                # but it seems Powershell has a limitation updating an array whilst looping
                # through it
            }
            $monkeys[$k].items = @()
        } else {
            #no items
        }
    }
}

$a, $b = $monkeys.inspections | Sort-Object -descending | Select-Object -first 2
write-host "Monkey Business = $($a * $b)"
write-host "== After round $rounds =="
foreach($monkey in $monkeys) {
    write-host "Monkey $($monkey.number) inspected items $($monkey.inspections) times."
}