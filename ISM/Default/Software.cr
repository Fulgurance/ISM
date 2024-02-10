module ISM

    module Default

        module Software

            SourcesArchiveBaseName = "Sources"
            MainBuildDirectoryEntry = "MainBuild"
            BuildDirectoryNames = { MainBuildDirectoryEntry => "mainBuild" }
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
            KconfigKeywords = { :config => /[\t\s]+config[\t\s]+/,
                                :bool => /[\t\s]+bool[\t\s]+/,
                                :dependsOn => /[\t\s]+depends[\t\s]+on[\t\s]+/,
                                :endif => /[\t\s]+endif[\t\s]+/,
                                :if => /[\t\s]+if[\t\s]+/,
                                :menuconfig => /[\t\s]+menuconfig[\t\s]+/,
                                :tristate => /[\t\s]+tristate[\t\s]+/,
                                :select => /[\t\s]+select[\t\s]+/,
                                :source => /[\t\s]+source[\t\s]+/}

        end

    end

end
