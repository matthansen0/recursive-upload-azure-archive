# Recursive Upload to Azure Storage Archive Tier

This script recursively uploads everything in a folder structure to Azure Blob and directly to the Archive tier.

```Upload-FileToAzureStorageContainer -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -ContainerName $ContainerName -sourceFileRootDirectory $sourceFileRootDirectory -Verbose```

## Contributing

Issues and PRs welcome.