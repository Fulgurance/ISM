module ISM

    class Software

        property information = ISM::Default::Software::Information
        property mainSourceDirectoryName = ISM::Default::Software::InformationMainSourceDirectoryName

        def initialize( informationPath = ISM::Default::Filename::Information,
                        mainSourceDirectoryName = ISM::Default::Software::InformationMainSourceDirectoryName)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = mainSourceDirectoryName
        end

        def download
            Dir.cd(Ism.settings.sourcesPath)
            Dir.mkdir(@information.versionName)
            Dir.cd(@information.versionName)
            Ism.notifyOfDownload(@information)

            #Adapt when multiple links are available and when some of there are broken
            Process.run("wget",args: [@information.downloadLinks[0]],output: :inherit)
            
            if !@information.patchesLinks.empty?
                Process.run("wget",args: [@information.patchesLinks[0]],output: :inherit)
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            Process.run("tar",args: ["-xf", @information.downloadLinks[0].lchop(@information.downloadLinks[0][0..@information.downloadLinks[0].rindex("/")])],output: :inherit)
            Dir.cd(@mainSourceDirectoryName)
        end
        
        def patch
            Ism.notifyOfPatch(@information)
            Process.run("patch",args: ["-Np1","-i",@information.patchesLinks[0].lchop(@information.patchesLinks[0][0..@information.patchesLinks[0].rindex("/")])],output: :inherit)
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
            FileUtils.rm_r(@information.versionName)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end