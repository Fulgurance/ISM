module ISM

    class Software

        property information = ISM::Default::Software::Information

        def initialize(information = ISM::Default::Software::Information)
            @information = information
        end

        def download
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::DownloadText +
                    @information.name
        end
        
        def check
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::CheckText +
                    @information.name
        end
        
        def extract
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::ExtractText +
                    @information.name
        end
        
        def prepare
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::PrepareText +
                    @information.name
        end
        
        def configure
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::ConfigureText +
                    @information.name
        end
        
        def build
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::BuildText +
                    @information.name
        end
        
        def install
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::InstallText +
                    @information.name
        end
        
        def uninstall
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::Software::UninstallText +
                    @information.name
        end

    end

end