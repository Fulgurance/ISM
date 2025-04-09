module ISM

    module Core

        def self.setTerminalTitle(title : String)
            if Ism.initialTerminalTitle == ""
                Ism.initialTerminalTitle = "\e"
            end

            STDOUT << "\e]0; #{title}\e\\"
        end

        def self.resetTerminalTitle
            self.setTerminalTitle(Ism.initialTerminalTitle)
        end

        def self.exitProgram(code = 0)
            exit code
        end


        #rootPath = (@settings.installByChroot || !@settings.installByChroot && (@settings.rootPath != "/") ? @settings.rootPath : "/")

    end

end
