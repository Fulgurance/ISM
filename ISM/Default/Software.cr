module ISM

    module Default

        module Software

            SourcesArchiveBaseName = "Sources"
            PatchesArchiveBaseName = "Patches"
            MainBuildDirectoryEntry = "MainBuild"
            ArchiveExtensionName = ".tar.xz"
            ArchiveSha512ExtensionName = "#{ArchiveExtensionName}.sha512"
            ArchiveSignatureExtensionName = "#{ArchiveExtensionName}.sig"
            SourcesArchiveName = "#{SourcesArchiveBaseName}#{ArchiveExtensionName}"
            SourcesSha512ArchiveName = "#{SourcesArchiveBaseName}#{ArchiveSha512ExtensionName}"
            SourcesSignatureArchiveName = "#{SourcesArchiveBaseName}#{ArchiveSignatureExtensionName}"
            SourcesDirectoryName = "Sources/"
            PatchesDirectoryName = "Patches/"
            DownloadSourceRedirectionErrorText1 = "Got status "
            DownloadSourceRedirectionErrorText2 = " but no location was sent"
            DownloadSourceCodeErrorText = "Received HTTP status code "
            KconfigKeywords = { :config => "config",
                                :bool => "bool",
                                :dependsOn => "depends on",
                                :endif => "endif",
                                :if => "if",
                                :menuconfig => "menuconfig",
                                :tristate => "tristate",
                                :select => "select",
                                :source => "source",
                                :help => "help"}

        end

    end

end
