module ISM

    class Software

        property information = ISM::Default::Software::Information
        property mainSourceName = ISM::Default::Software::MainSourceName
        property mainSourceExtensionName = ISM::Default::Software::InformationMainSourceExtensionName
        property mainSourceDirectoryName = ISM::Default::Software::InformationMainSourceDirectoryName

        def initialize( informationPath = ISM::Default::Filename::Information,
                        mainSourceName = ISM::Default::Software::MainSourceName,
                        mainSourceExtensionName = ISM::Default::Software::InformationMainSourceExtensionName,
                        mainSourceDirectoryName = ISM::Default::Software::InformationMainSourceDirectoryName)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceName = mainSourceName
            @mainSourceExtensionName = mainSourceExtensionName
            @mainSourceDirectoryName = mainSourceDirectoryName
        end

        def download
            Dir.cd(Ism.settings.sourcesPath)
            Dir.mkdir(@information.versionName)
            Dir.cd(@information.versionName)
            Ism.notifyOfDownload(@information)

            #Adapt when multiple links are available and when some of there are broken
            Process.run("curl",args: ["-O","#{@information.downloadLinks[0]}"],output: :inherit)
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            Process.run("tar",args: ["-xf", "#{@mainSourceName+@mainSourceExtensionName}"],output: :inherit)
            Dir.cd(@mainSourceDirectoryName)
        end
        
        def patch
            Ism.notifyOfPatch(@information)
        end
    
        def prepare
            Ism.notifyOfPrepare(@information)
        end
        
        def configure
            Ism.notifyOfConfigure(@information)
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end
        
        def install
            Ism.notifyOfInstall(@information)
        end
        
        def clean
            Ism.notifyOfClean(@information)
            Dir.cd(Ism.settings.sourcesPath)
            Dir.delete(Ism.settings.sourcesPath)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end