$csvfile = "D:\TEMP\WORK3\Clusterinfo.txt"
$masternode = "hogehogehost01"
$ownerfile = "D:\TEMP\work3\OwnerNode.txt"
$ownertrim = "D:\TEMP\work3\OwnerNode_trim.txt"

try{
Get-ClusterResource | Select-Object OwnerGroup,OwnerNode ,ResourceType, Name, State | Sort-Object OwnerGroup | ConvertTo-Csv -NoTypeInformation -Delimiter "," | Out-File $csvfile

$csv = Import-Csv $csvfile
$csv | Select-Object OwnerNode | Out-String -Stream | ForEach-Object {$_.trim()} | Select-String "JP" | Out-File $ownerfile
Get-Content $ownerfile | ? {$_.trim() -ne "" } | Out-File $ownertrim
foreach ($l in Get-Content $ownertrim) { if ( $l -ne $masternode ) { Write-Host "異常終了：クラスタリソースに異常があります";exit 10 }}
}catch [Exception]{
    Write-Host "catch例外処理です"
    Write-host $error
    exit 10
}
Write-Host "正常終了：クラスタリソースに異常はありません"
exit 0