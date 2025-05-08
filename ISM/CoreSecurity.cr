module ISM

    module Core

        module Security

            module Default
                SystemId = 250
                SystemName = "#{CommandLine::Name}"
            end

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

            def self.setLibSystemAccess(locked : Bool)
                mode = (locked ? "+" : "-")
                target = "usr/lib64"

                command = "/usr/bin/chattr -R -f #{mode}i #{ISM::Core.targetedRootPath}#{target}"

                process = ISM::Core.runSystemCommand(   command: command,
                                                        asRoot: true,
                                                        viaChroot: false)

                if !process.success? && process.exit_code != 1
                    ISM::Core::Error.show(  className: "CoreSecurity",
                                            functionName: "setLibSystemAccess",
                                            errorTitle: "Failed to set the system access for /#{target}",
                                            error: "An error occured while trying to modify the system access")
                end
            end

            def self.setBinSystemAccess(locked : Bool)
                mode = (locked ? "+" : "-")
                target = "usr/bin"

                command = "/usr/bin/chattr -R -f #{mode}i #{ISM::Core.targetedRootPath}#{target}"

                process = ISM::Core.runSystemCommand(   command: command,
                                                        asRoot: true,
                                                        viaChroot: false)

                if !process.success? && process.exit_code != 1
                    ISM::Core::Error.show(  className: "CoreSecurity",
                                            functionName: "setBinSystemAccess",
                                            errorTitle: "Failed to set the system access for /#{target}",
                                            error: "An error occured while trying to modify the system access")
                end
            end

            def self.setSbinSystemAccess(locked : Bool)
                mode = (locked ? "+" : "-")
                target = "usr/sbin"

                command = "/usr/bin/chattr -R -f #{mode}i #{ISM::Core.targetedRootPath}#{target}"

                process = ISM::Core.runSystemCommand(   command: command,
                                                        asRoot: true,
                                                        viaChroot: false)

                if !process.success? && process.exit_code != 1
                    ISM::Core::Error.show(  className: "CoreSecurity",
                                            functionName: "setSbinSystemAccess",
                                            errorTitle: "Failed to set the system access for /#{target}",
                                            error: "An error occured while trying to modify the system access")
                end
            end

            def self.setLibexecSystemAccess(locked : Bool)
                mode = (locked ? "+" : "-")
                target = "usr/libexec"

                command = "/usr/bin/chattr -R -f #{mode}i #{ISM::Core.targetedRootPath}#{target}"

                process = ISM::Core.runSystemCommand(   command: command,
                                                        asRoot: true,
                                                        viaChroot: false)

                if !process.success? && process.exit_code != 1
                    ISM::Core::Error.show(  className: "CoreSecurity",
                                            functionName: "setLibexecSystemAccess",
                                            errorTitle: "Failed to set the system access for /#{target}",
                                            error: "An error occured while trying to modify the system access")
                end
            end

            def self.setSystemAccess(locked : Bool)

                setLibSystemAccess(locked)
                setBinSystemAccess(locked)
                setSbinSystemAccess(locked)
                setLibexecSystemAccess(locked)

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
