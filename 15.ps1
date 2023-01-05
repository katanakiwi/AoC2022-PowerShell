set-location "$PSScriptRoot"
$inputFile = "15sample.txt"
#$inputFile = "15.txt"
$lines = get-content $inputFile

function createSensors($rows) {
    $sensors = @{}
    foreach($row in $rows) {    
        $rest,$a,$b,$c,$d = $row -split "="
        [int]$xS, $rest = $a -split ","
        [int]$yS, $rest = $b -split ":"
        [int]$xB, $rest = $c -split ","
        [int]$yB = [int]$d
        $node = @{}
        $node.xS = $xS
        $node.yS = $yS
        $node.xB = $xB
        $node.yB = $yB
        $manhdist = [Math]::Abs($xS - $xB) + [Math]::Abs($yS - $yB)
        $node.beaconDistance = $manhdist
        $sensors.add("$($row.ReadCount)", $node)
    }
    return $sensors
}

function findExtremes($nds) {
    $xx = $nds.values.xS + $nds.values.xB
    $yy = $nds.values.yS + $nds.values.yB

    

    $miX = ($xx | Measure-Object -Minimum).minimum
    $maX = ($xx | Measure-Object -Maximum).maximum
    $miY = ($yy | Measure-Object -Minimum).minimum
    $maY = ($yy | Measure-Object -Maximum).maximum

    return $miX, $maX, $miY, $maY
}

function findBeaconFreeCandidates($nodes, $row) {
    <# voor elke sensor:
    kijk of de afstand naar diens beacon kleiner is dan de afstand naar de lijn
    Als de beacon verder weg ligt dan punten op de lijn, zet de markeer de punten op de lijn 
    Voor part B waarschijnlijk heel het array, dan lijn voor lijn hier doorheen en het resultaat tussentijds in een counter opslaan
    keep in mind that beacons on line #linenr ARE a beacon and should not be counted
    #>
    $arrSize = ($minX..$maxX).count
    $arr = New-Object boolean[] $arrSize
    for($k = 1; $k -le $nodes.Count; $k++) {
        $distLineSensor = [Math]::Abs($nodes["$k"].yS -$row)
        $diff = ($nodes["$k"].beaconDistance) - $distLineSensor
        if($diff -eq 0) {
            $arr[($nodes["$k"].xS + $minX)] = $true
        } elseif($diff -gt 0) {
            #set only at X coordinate of node
            foreach($l in ($nodes["$k"].xS-$diff)..($nodes["$k"].Xs+$diff)) {
                $arr[($nodes["$l"].xS + $minX)] = $true
            }
        }
    }
    write-host "added all?"

    return 0
}

function getNrBeaconsOnRow($nodes, $row) {
    <# for a given row, returns the amount of beacons in that row #>
    return 0
}

$nodes = createSensors $lines
$minX, $maxX, $minY, $maxY = findExtremes($nodes)

[int]$lineToSearch = 0
if($inputFile -eq "15.txt") {
    $lineToSearch = 2000000
} else {
    $lineToSearch = 10
}
$beaconFreeSlots = findBeaconFreeCandidates $nodes $lineToSearch

Write-Host "Line $lineToSearch has $beaconFreeSlots that cannot contain a beacon"