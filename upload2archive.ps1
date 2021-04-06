##########################################################################
####           Recursive Upload to Azure Archive Storage              ####
####                                                                  ####
####   https://github.com/matthansen0/recursive-upload-azure-archive  ####
##########################################################################

$StorageAccountName = "xxxxxxxxxxxx" #i.e. storageaccount1
$StorageAccountKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$ContainerName = "xxxx" #i.e. "container1"
$sourceFileRootDirectory = "xxxxxxxx" # i.e. C:\upload
$StorageTier = "Archive"

function Upload-RecursiveToAzureStorage {
    [cmdletbinding()]
    param(
        $StorageAccountName,
        $StorageAccountKey,
        $ContainerName,
        $sourceFileRootDirectory,
        $Force
    )

    $context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $container = Get-AzStorageContainer -Name $ContainerName -Context $context

    $container.CloudBlobContainer.Uri.AbsoluteUri
    if ($container) {
        $filesToUpload = Get-ChildItem $sourceFileRootDirectory -Recurse -File

        foreach ($file in $filesToUpload) {
            $targetPath = ($file.fullname.Substring($sourceFileRootDirectory.Length + 1)).Replace("\", "/")

            Write-Verbose "Uploading $("\" + $file.fullname.Substring($sourceFileRootDirectory.Length + 1)) to $($container.CloudBlobContainer.Uri.AbsoluteUri + "/" + $targetPath)"
            Set-AzStorageBlobContent -StandardBlobTier $StorageTier -File $file.fullname -Container $container.Name -Blob $targetPath -Context $context -Force:$Force | Out-Null
        }
    }
}


Upload-RecursiveToAzureStorage -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -ContainerName $ContainerName -sourceFileRootDirectory $sourceFileRootDirectory -Verbose
