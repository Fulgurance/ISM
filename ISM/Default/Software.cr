module ISM

    module Default

        module Software

            SourcesArchiveBaseName = "Sources"
            SourcesPublicKeyBaseFileName = "PublicKey"
            PatchesArchiveBaseName = "Patches"
            MainBuildDirectoryEntry = "MainBuild"
            PublicKeyExtensionName = ".cert"
            ArchiveExtensionName = ".tar.xz"
            ArchiveSha512ExtensionName = "#{ArchiveExtensionName}.sha512"
            ArchiveSignatureExtensionName = "#{ArchiveExtensionName}.sig"
            SourcesArchiveName = "#{SourcesArchiveBaseName}#{ArchiveExtensionName}"
            SourcesSha512ArchiveName = "#{SourcesArchiveBaseName}#{ArchiveSha512ExtensionName}"
            SourcesSignatureArchiveName = "#{SourcesArchiveBaseName}#{ArchiveSignatureExtensionName}"
            SourcesPublicKeyFileName = "#{SourcesPublicKeyBaseFileName}#{PublicKeyExtensionName}"
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
