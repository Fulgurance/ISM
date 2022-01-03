module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String

        def initialize( informationPath : String,
                        @mainSourceDirectoryName)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
        end

        def download
            Dir.mkdir(Ism.settings.sourcesPath+"/"+@information.versionName)
            Ism.notifyOfDownload(@information)

            #Adapt when multiple links are available and when some of there are broken
            Process.run("wget", args: [@information.downloadLinks[0]],
                                output: :inherit,
                                chdir: Ism.settings.sourcesPath+"/"+@information.versionName)
            
            if !@information.patchesLinks.empty?
                Process.run("wget", args: [@information.patchesLinks[0]],
                                    output: :inherit,
                                    chdir: Ism.settings.sourcesPath+"/"+@information.versionName)
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            Process.run("tar",  args: ["-xf", @information.downloadLinks[0].lchop(@information.downloadLinks[0][0..@information.downloadLinks[0].rindex("/")])],
                                output: :inherit,
                                chdir: Ism.settings.sourcesPath+"/"+@information.versionName)
        end
        
        def patch
            Ism.notifyOfPatch(@information)
            if !@information.patchesLinks.empty?
                Process.run("patch",args: ["-Np1","-i",@information.patchesLinks[0].lchop(@information.patchesLinks[0][0..@information.patchesLinks[0].rindex("/")])],
                                    output: :inherit,
                                    chdir: Ism.settings.sourcesPath+"/"+@information.versionName+"/"+@mainSourceDirectoryName)
            end
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
            FileUtils.rm_r(Ism.settings.sourcesPath+@information.versionName)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end