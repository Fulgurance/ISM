module ISM

    class Software

        property information = ISM::Default::Software::Information

        def initialize(informationPath = ISM::Default::Filename::Information)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
        end

        def download
            Dir.cd(Ism.settings.sourcesPath)
            Dir.mkdir(@information.versionName)
            Dir.cd(@information.versionName)
            Ism.notifyOfDownload(@information)

            downloadList =  @information.downloadLinks +
                            @information.signatureLinks + 
                            @information.shasumLinks

            downloadList.each do |link|
                Process.run("curl",args: ["-O","#{link}"],output: :inherit)
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
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
            Dir.rmdir(Ism.settings.sourcesPath)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end