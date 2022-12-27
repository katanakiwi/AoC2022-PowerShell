set-location "$PSScriptRoot"
$inputFile = "7sample.txt"
$inputFile = "7.txt"
$lines = Get-Content $inputFile

$global:tree = @()

function makeFolder($folderName) {
    $folder = New-Object PSObject | Select-Object Path, Name, Size, Type

    $folder.Path = $folderName
    $folder.Type = "folder"

    $global:tree += $folder
}

function makeFile() {
    param ($filepath, $newFile, $size)
    $file = New-Object PSObject | Select-Object Path, Name, Size, Type

    $file.Path = $filepath
    $file.Name = $newFile
    [int]$file.Size = $size
    $file.Type = "file"

    $global:tree += $file
    updateFolderSizes $filepath $size
}

function updateFolderSizes($folderToUpdate, $size) {
    $indexOfFolderToUpdate = $tree.indexOf(($tree | Where-Object {($_.Path -eq $folderToUpdate) -and ($_.type -eq "folder")}))
    [int]$global:tree[$indexOfFolderToUpdate].Size = [int]$global:tree[$indexOfFolderToUpdate].Size + [int]$size
    if(-not ($folderToUpdate -eq "/")){
        $dirAbove = getFolderAbove($folderToUpdate)
        updateFolderSizes $dirAbove $size
    }
}

function getFolderAbove($currentFolder) {
    $dirparts = @()
    $dirParts += ($currentFolder -split "/" | Where-Object {$_ -ne ""})
    $charactersToRemove = $dirParts[$dirParts.Length-1].Length +1
    $aboveFolder = $currentFolder.SubString(0,$currentFolder.Length-$charactersToRemove)
    return $aboveFolder
}

$currentDir = ""
foreach($line in $lines) {
    
    $parts = $line -split " "
    if($line -eq "`$ cd /") {
        $currentDir = "/"
        makeFolder($currentDir)
    } elseif((($parts[0] + $parts[1]) -eq "`$cd") -and ($parts[2] -ne "..")) {
        $currentDir += $parts[2] + "/"
        makeFolder($currentDir)
    } elseif ((($parts[0] + $parts[1]) -eq "`$cd")) {
        $currentDir = getFolderAbove($currentDir)
#        write-host "we should move one folder up"
        #move current directory up
    } elseif ((($parts[0] + $parts[1]) -eq "`$ls") -or ($parts[0] -eq "dir")) {
        #do nothing
    } else {
        makeFile $currentDir $parts[1] $parts[0]
#        write-host "line should contain a file: $line"
    }
}

$smallDirectories = ($tree | Where-Object {($_.Type -eq "folder") -and ($_.Size -le 100000)})
$smallSum = 0
for($i = 0; $i -lt $smallDirectories.Length; $i++) {
    $smallSum += $smallDirectories[$i].Size
}
Write-Host "Sum of small directories is: $smallSum"

$fileSystemSpace = 70000000
$requiredSpace = 30000000
$usedSpace = $tree[0].Size
$freeSpace = $fileSystemSpace - $usedSpace
$neededSpace = $requiredSpace - $freeSpace
write-host "We need to clear up $neededSpace amount of space"
$sizes = New-Object int[] $tree.Length
for($i = 0; $i -lt $tree.Length; $i++) {
    $sizes[$i] = $tree[$i].Size
}
$sizes = $sizes | Sort-Object
for($i = 0; $i -lt $sizes.Length; $i++) {
    if($sizes[$i] -gt $neededSpace) {
        $inTree = ($tree | Where-Object {$_.size -eq $sizes[$i]})
        $indexInTree = $tree.IndexOf($inTree)
        write-host "should be at index $indexInTree"
        write-host $tree[$indexInTree]
        break;
    }
}
Write-Host "algorithm done..."