module ISM

    module Core

        module Security

            def self.systemHandleUserAccess : Bool
                return ISM::CommandLineSystemInformation.loadConfiguration.handleUserAccess

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "systemHandleUserAccess",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

            def self.ranAsSuperUser : Bool
                return (LibC.getuid == 0)

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "ranAsSuperUser",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

            def self.ranAsMemberOfGroupIsm : Bool
                processResult = IO::Memory.new

                ISM::Core.runSystemCommand( command: "id -G",
                                            output: processResult)

                return processResult.to_s.strip.split(" ").includes?(ISM::Default::Core::Security::SystemId)

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "ranAsMemberOfGroupIsm",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

            def self.stillHaveSudoAccess : Bool
                process = Process.run(  "sudo -n true 2>/dev/null",
                                        shell: true)

                return (process.exit_code == 0)

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "stillHaveSudoAccess",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
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

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "setSystemAccess",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

            def self.lockSystemAccess
                self.setSystemAccess(locked: true)

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "lockSystemAccess",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

            def self.unlockSystemAccess
                self.setSystemAccess(locked: false)

                rescue exception
                ISM::Core::Error.show(  className: "Core::Security",
                                        functionName: "unlockSystemAccess",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
            end

        end

    end

end
