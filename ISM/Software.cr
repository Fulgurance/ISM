module ISM

    class Software

        property information = ISM::Default::Software::Information

        def initialize(information = ISM::Default::Software::Information)
            @information = information
        end

        def download
            Ism.notifyOfDownload(@information)
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
        
        def uninstall
            Ism.notifyOfUninstall(@information)
        end

    end

end