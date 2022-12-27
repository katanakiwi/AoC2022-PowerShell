set-location "$PSScriptRoot"
$inputFile = "2sample.txt"
$inputFile = "2.txt"

$score = 0
$round = 0
foreach($line in get-content $inputFile){
    $round++
    $chars = $line.ToCharArray()
    $opponent = $chars[0]
    $desiredResult = $chars[2]
    $me = chooseResult $opponent $desiredResult
    Switch($desiredResult){
        X {$score += 0}
        Y {$score += 3}
        Z {$score += 6}
    }
    Switch($me){
        A {$score += 1}
        B {$score += 2}
        C {$score += 3}
    }
    Write-Host "Score after round ${round}: $score"
}

write-host "Total score: $score"

function chooseResult() {
    param ($opponent, $desiredResult)

    Switch($desiredResult) {
        #loss
        X {Switch($opponent){
           A {return "C";break}
           B {return "A";break}
           C {return "B";break}}}
        #draw
        Y {Switch($opponent){
           A {return "A";break}
           B {return "B";break}
           C {return "C";break}}}
        #win
        Z {Switch($opponent) {
            A {return "B";break}
            B {return "C";break}
            C {return "A";break}}}
    }
}