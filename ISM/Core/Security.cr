module ISM

    module Core

        module Security

            module Default

                Name = "ism"
                Id = 250

            end

            def self.runAsSuperUser(validCondition = true, &)
                if validCondition
                    uidResult = LibC.setresuid( realId: 0,
                                                effectiveId: 0,
                                                savedId: Default::Id)
                    gidResult = LibC.setresgid( realId: 0,
                                                effectiveId: 0,
                                                savedId: Default::Id)

                    if uidResult.negative? || gidResult.negative?
                        ISM::Error.show(className: "CommandLine",
                                        functionName: "runAsSuperUser",
                                        errorTitle: "Privilege escalation failure",
                                        error: "It mean probably that the uid and gid bit are not set.")
                    end
                end

                begin
                    yield
                ensure
                    #We ensure we exit without superuser access
                    LibC.setresuid( realId: Default::Id,
                                    effectiveId: Default::Id,
                                    savedId: 0)
                    LibC.setresgid( realId: Default::Id,
                                    effectiveId: Default::Id,
                                    savedId: 0)
                end

                rescue exception
                    ISM::Error.show(className: "CommandLine",
                                    functionName: "runAsSuperUser",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def self.ranAsSuperUser : Bool
                return (LibC.getuid == 0)

                rescue exception
                    ISM::Error.show(className: "CommandLine",
                                    functionName: "ranAsSuperUser",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def self.ranAsMemberOfIsmGroup : Bool
                groupSystemFile = Core::Security.runAsSuperUser {
                    File.read_lines("/etc/group")
                }

                groupSystemFile.each do |line|
                    userName = System::User.find_by(id: LibC.getuid.to_s).username

                    if line.starts_with?(Default::Name) && (line.includes?(userName) || userName == Default::Name)
                        return true
                    end
                end

                return false


                rescue exception
                    ISM::Error.show(className: "CommandLine",
                                    functionName: "ranAsMemberOfGroupIsm",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def self.changeFileMode(path : String, mode : String)
                File.chmod( path: path,
                            permissions: mode.to_i(8))

                rescue exception
                    ISM::Error.show(className: "CommandLine",
                                    functionName: "changeFileMode",
                                    errorTitle: "Execution failure",
                                    error: "Failed to set mode #{mode} to #{path}",
                                    exception: exception)
            end

            def self.changeFileOwner(path : String, user : String, group : String)
                uid = (user.to_i? ? System::User.find_by(id: user).id.to_i : System::User.find_by(name: user).id.to_i)
                gid = (group.to_i? ? System::Group.find_by(id: group).id.to_i : System::Group.find_by(name: group).id.to_i)

                File.chown( path: path,
                            uid: uid,
                            gid: gid)

                rescue exception
                    ISM::Error.show(className: "CommandLine",
                                    functionName: "changeFileOwner",
                                    errorTitle: "Execution failure",
                                    error: "Failed to change the owner of #{path} to #{user}:#{group}",
                                    exception: exception)
            end

        end

    end

end
