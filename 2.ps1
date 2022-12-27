set-location "$PSScriptRoot"
$inputFile = "2sample.txt"
$inputFile = "2.txt"

$score = 0
foreach($line in get-content $inputFile){
    $chars = $line.ToCharArray()
    $opponent = ""
    $opponent = $chars[0]
    $me = $chars[2]
    $outcome = resolveRPS $opponent $me
    switch($outcome){
        loss {$score += 0}
        win {$score += 6}
        tie {$score += 3}
    }
    switch($me){
        X {$score += 1}
        Y {$score += 2}
        Z {$score += 3}
    }
}

write-host "Total score: $score"

function resolveRPS() {
    param ($in1,$in2)
    Switch($in1){
        A {
            if($in2 -eq "X"){return "tie"}
            if($in2 -eq "Y"){return "win"}
            return "loss"
        }
        B {
            if($in2 -eq "Y"){return "tie"}
            if($in2 -eq "Z"){return "win"}
            return "loss"
        }
        C {
            if($in2 -eq "Z"){return "tie"}
            if($in2 -eq "X"){return "win"}
            return "loss"
        }
    }
}