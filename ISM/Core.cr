module ISM

    module Core

        def self.setTerminalTitle(title : String)
            if Ism.initialTerminalTitle == ""
                Ism.initialTerminalTitle = "\e"
            end

            STDOUT << "\e]0; #{title}\e\\"

            rescue exception
            ISM::Core::Error.show(  className: "Core",
                                    functionName: "setTerminalTitle",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.resetTerminalTitle
            self.setTerminalTitle(Ism.initialTerminalTitle)

            rescue exception
            ISM::Core::Error.show(  className: "Core",
                                    functionName: "resetTerminalTitle",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.exitProgram(code = 0)
            exit code

            rescue exception
            ISM::Core::Error.show(  className: "Core",
                                    functionName: "exitProgram",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.taskFileDirectory : String
            return "#{targetedRootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}"
        end

        def self.taskFilePath : String
            return "#{taskFileDirectory}#{ISM::Default::Filename::Task}"
        end

        def self.runTasks(tasks, quiet = false, asRoot = false, viaChroot = false, input = Process::Redirect::Inherit, output = Process::Redirect::Inherit, error = Process::Redirect::Inherit) : Process::Status

            # We first check if there is any task left
            if File.exists?("#{taskFilePath}")
                process = Process.run(  command:    "sudo chattr -f -i #{taskFilePath}",
                                        shell:      true)

                process = Process.run(  command: "sudo rm #{taskFilePath}",
                                        shell: true)
            end

            if !Dir.exists?(taskFileDirectory)
                Dir.mkdir_p(taskFileDirectory)
            end

            File.write(taskFilePath, tasks)

            process = Process.run(  command:    "sudo chmod +x #{taskFilePath}",
                                    input:      (quiet ? Process::Redirect::Close : input),
                                    output:     (quiet ? Process::Redirect::Close : output),
                                    error:      (quiet ? Process::Redirect::Close : error),
                                    shell:      true)

            systemUserId = ISM::Default::Core::SystemUserId
            systemUserName = ISM::Default::Core::SystemUserName

            noChrootCommand = (asRoot ? "sudo" : "sudo -u #{systemUserName} -g #{systemUserName}")
            viaChrootCommand = "HOME=/var/lib/ism sudo chroot #{asRoot ? "" : "--userspec=#{systemUserId}:#{systemUserId}"} #{commandLineSettings.rootPath}"

            mainCommand = (viaChroot ? viaChrootCommand : noChrootCommand)

            command = "#{mainCommand} #{taskFilePath}"

            process = Process.run(  command:    command,
                                    input:      (quiet ? Process::Redirect::Close : input),
                                    output:     (quiet ? Process::Redirect::Close : output),
                                    error:      (quiet ? Process::Redirect::Close : error),
                                    shell:      true)

            File.delete(taskFilePath)

            return process

            rescue exception
                raisedError =  <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{command}
                asRoot: #{asRoot}
                viaChroot: #{viaChroot}
                ERROR

                ISM::Core::Error.show(  className: "Core",
                                        functionName: "runTasks",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the following process:\n#{raisedError}",
                                        exception: exception)
        end

        def self.runSystemCommand(command : String, path = commandLineSettings.installByChroot ? "/" : commandLineSettings.rootPath, environment = Hash(String, String).new, environmentFilePath = String.new, quiet = false, asRoot = false, viaChroot = true, input = Process::Redirect::Inherit, output = Process::Redirect::Inherit, error = Process::Redirect::Inherit) : Process::Status
            superuser = (asRoot && commandLineSystemInformation.handleUserAccess)

            environmentCommand = String.new

            if environmentFilePath != ""
                environmentCommand = "source \"#{environmentFilePath}\" && "
            end

            environment.keys.each do |key|
                environmentCommand += "#{key}=\"#{environment[key]}\" "
            end

            command = <<-CODE
            #!/bin/bash

            if \[ -f "/etc/profile" \]; then
                source /etc/profile
            fi

            cd #{path} && #{environmentCommand} #{command}
            CODE

            process = runTasks( tasks:      command,
                                quiet:      quiet,
                                asRoot:     superuser,
                                viaChroot:  (commandLineSettings.installByChroot && viaChroot),
                                input:      input,
                                output:     output,
                                error:      error)

            return process

            rescue exception
                raisedError =  <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{command}
                asRoot: #{asRoot}
                viaChroot: #{viaChroot}
                ERROR

                ISM::Core::Error.show(  className: "Core",
                                        functionName: "runSystemCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the following process:\n#{raisedError}",
                                        exception: exception)
        end

        def self.progressivePrint(text : String, delay = 1)
            text.each_char do |character|
                sleep(Time::Span.new(nanoseconds: delay * 1000000))

                print character
            end
        end

        def self.commandLineSettings
            return ISM::CommandLineSettings.loadConfiguration
        end

        def self.commandLineSystemInformation
            return ISM::CommandLineSystemInformation.loadConfiguration
        end

        def self.targetedRootPath : String
            return (commandLineSettings.installByChroot || !commandLineSettings.installByChroot && (commandLineSettings.rootPath != "/") ? commandLineSettings.rootPath : "/")
        end

    end

end
