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

            #Improve this part to after alternate to an another link if the first one is broken
            #downloadList =  @information.downloadLinks[0] #+
                            #@information.signatureLinks + 
                            #@information.shasumLinks

            #downloadList.each do |link|
                #Process.run("curl",args: ["-O","#{link}"],output: :inherit)
            #end
            Process.run("curl",args: ["#{@information.downloadLinks[0]}", ">", "#{@information.versionName}+.tar.xz"],output: :inherit)
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            Process.run("tar",args: ["-xf", "#{@information.versionName}+.tar.xz"],output: :inherit)
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