module ISM

    module Default

        module Software

            SourcesArchiveBaseName = "Sources"
            PatchesArchiveBaseName = "Patches"
            ArchiveExtensionName = ".tar.xz"
            ArchiveMd5sumExtensionName = "#{ArchiveExtensionName}.md5sum"
            SourcesArchiveName = "#{SourcesArchiveBaseName}#{ArchiveExtensionName}"
            PatchesArchiveName = "#{PatchesArchiveBaseName}#{ArchiveExtensionName}"
            SourcesMd5sumArchiveName = "#{SourcesArchiveBaseName}#{ArchiveMd5sumExtensionName}"
            PatchesMd5sumArchiveName = "#{PatchesArchiveBaseName}#{ArchiveMd5sumExtensionName}"
            SourcesDirectoryName = "Sources/"
            PatchesDirectoryName = "Patches/"
            DownloadSourceRedirectionErrorText1 = "Got status "
            DownloadSourceRedirectionErrorText2 = " but no location was sent"
            DownloadSourceCodeErrorText = "Received HTTP status code "

        end

    end

end
