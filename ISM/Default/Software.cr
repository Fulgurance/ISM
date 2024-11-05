module ISM

    module Default

        module Software

            SourcesArchiveBaseName = "Sources"
            PatchesArchiveBaseName = "Patches"
            MainBuildDirectoryEntry = "MainBuild"
            ArchiveExtensionName = ".tar.xz"
            ArchiveMd5sumExtensionName = "#{ArchiveExtensionName}.md5sum"
            SourcesArchiveName = "#{SourcesArchiveBaseName}#{ArchiveExtensionName}"
            SourcesMd5sumArchiveName = "#{SourcesArchiveBaseName}#{ArchiveMd5sumExtensionName}"
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
