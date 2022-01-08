module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = String.new
        end

        def download
            Dir.mkdir(Ism.settings.sourcesPath+"/"+@information.versionName)
            Ism.notifyOfDownload(@information)
        end

        def downloadSource(link : String)
            if !Process.run("wget", args: [link],
                output: :inherit,
                error: :inherit,
                chdir: Ism.settings.sourcesPath+"/"+@information.versionName).success?
                notifyOfDownloadError(link)
                exit 1
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
        end

        def extractSource(archive : String)
            if !Process.run("tar",  args: ["-xf", archive],
                                    output: :inherit,
                                    chdir: Ism.settings.sourcesPath+"/"+@information.versionName).success?
                notifyOfExtractError(archive)
                exit 1
            end
        end
        
        def patch
            Ism.notifyOfPatch(@information)
        end
        
        def applyPatch(patch : String)
            if !Process.run("patch",    args: ["-Np1","-i",patch],
                                        output: :inherit,
                                        chdir: Ism.settings.sourcesPath+"/"+@information.versionName+"/"+@mainSourceDirectoryName).success?
                notifyOfApplyPatchError(patch)
                exit 1
            end
        end

        def prepare
            Ism.notifyOfPrepare(@information)
        end

        def moveFile(path : String, newPath : String)
            FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                            @information.versionName + "/" +
                            path,
                            Ism.settings.sourcesPath + "/" + 
                            @information.versionName + "/" +
                            newPath)
        end

        def makeDirectory(directory : String)
            Dir.mkdir(  Ism.settings.sourcesPath + "/" + 
                        @information.versionName + "/" +
                        directory)
        end
        
        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments : Array(String), path = String.new)
            if !Process.run("./configure", args: arguments,
                                            output: :inherit,
                                            error: :inherit,
                                            chdir:  Ism.settings.sourcesPath + "/" + 
                                                    @information.versionName + "/" +
                                                    @mainSourceDirectoryName + "/" +
                                                    path)
                notifyOfConfigureError(path)
                exit 1
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makeSource(arguments : Array(String), path = String.new)
            if !Process.run("make", args: arguments,
                                    output: :inherit,
                                    error: :inherit,
                                    chdir:  Ism.settings.sourcesPath + "/" + 
                                            @information.versionName + "/" +
                                            @mainSourceDirectoryName + "/" +
                                            path)
                notifyOfMakeError(path)
                exit 1
            end
        end
        
        def install
            Ism.notifyOfInstall(@information)
        end
        
        def clean
            Ism.notifyOfClean(@information)
            FileUtils.rm_r(Ism.settings.sourcesPath+"/"+@information.versionName)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end
