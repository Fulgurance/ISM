module ISM

    module Core

        module Security

            def self.systemHandleUserAccess : Bool
                return ISM::CommandLineSystemInformation.loadConfiguration.handleUserAccess
            end

            def self.ranAsSuperUser : Bool
                return (LibC.getuid == 0)
            end

            def self.ranAsMemberOfGroupIsm : Bool
                processResult = IO::Memory.new

                ISM::Core.runSystemCommand( command: "id -G",
                                            output: processResult)

                return processResult.to_s.strip.split(" ").includes?(ISM::Default::Core::Security::SystemId)
            end

            def self.stillHaveSudoAccess : Bool
                process = Process.run(  "sudo -n true 2>/dev/null",
                                        shell: true)

                return (process.exit_code == 0)
            end

            def self.setSystemAccess(locked : Bool)
                mode = (locked ? "+" : "-")

                rootPath = (ISM::CommandLineSettings.loadConfiguration.installByChroot || !ISM::CommandLineSettings.loadConfiguration.installByChroot && (ISM::CommandLineSettings.loadConfiguration.rootPath != "/") ? ISM::CommandLineSettings.loadConfiguration.rootPath : "/")

                binary = "/usr/bin/chattr"

                setLib = "#{binary} -R -f #{mode}i #{rootPath}usr/lib64"
                setBin = "#{binary} -R -f #{mode}i  #{rootPath}usr/bin"
                setSbin = "#{binary} -R -f #{mode}i  #{rootPath}usr/sbin"
                setLibexec = "#{binary} -R -f #{mode}i  #{rootPath}usr/libexec"

                requestedCommands = <<-CMD
                                    #{setLib} && #{setBin} && #{setSbin} && #{setLibexec}
                                    CMD

                ISM::Core.runSystemCommand( command: requestedCommands,
                                            shell: false,
                                            asRoot: true,
                                            chroot: false,
                                            ignoreErrorCodeList: [1])
            end

            def self.lockSystemAccess
                self.setSystemAccess(locked: true)
            end

            def self.unlockSystemAccess
                self.setSystemAccess(locked: false)
            end

        end

    end

end
