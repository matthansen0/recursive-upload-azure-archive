##########################################################
####           Recursive upload to Azure Archive      ####
####                                                  ####
####   https://github.com/matthansen0/batch-docx2pdf  ####
##########################################################

$StorageAccountName = "xxxxxxxxxxxx"
$StorageAccountKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$ContainerName = "xxxx"
$sourceFileRootDirectory = "xxxxxxxx" # i.e. D:\Docs
$StorageTier = "Archive"

function Upload-FileToAzureStorageContainer {
    [cmdletbinding()]
    param(
        $StorageAccountName,
        $StorageAccountKey,
        $ContainerName,
        $sourceFileRootDirectory,
        $Force
    )

    $ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $container = Get-AzStorageContainer -Name $ContainerName -Context $ctx

    $container.CloudBlobContainer.Uri.AbsoluteUri
    if ($container) {
        $filesToUpload = Get-ChildItem $sourceFileRootDirectory -Recurse -File

        foreach ($x in $filesToUpload) {
            $targetPath = ($x.fullname.Substring($sourceFileRootDirectory.Length + 1)).Replace("\", "/")

            Write-Verbose "Uploading $("\" + $x.fullname.Substring($sourceFileRootDirectory.Length + 1)) to $($container.CloudBlobContainer.Uri.AbsoluteUri + "/" + $targetPath)"
            Set-AzStorageBlobContent -StandardBlobTier $StorageTier -File $x.fullname -Container $container.Name -Blob $targetPath -Context $ctx -Force:$Force | Out-Null
        }
    }
}


Upload-FileToAzureStorageContainer -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -ContainerName $ContainerName -sourceFileRootDirectory $sourceFileRootDirectory -Verbose
