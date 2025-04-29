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

        def self.taskFileDirectory(relatedToChroot = false) : String
            return "#{relatedToChroot ? "/" : targetedRootPath}#{ISM::Default::Path::TemporaryDirectory}"
        end

        def self.taskFilePath(relatedToChroot = false) : String
            return "#{taskFileDirectory(relatedToChroot)}#{ISM::Default::Filename::Task}"
        end

        def self.runChrootTasks(chrootTasks, quiet = false, asRoot = false, input = Process::Redirect::Inherit, output = Process::Redirect::Inherit, error = Process::Redirect::Inherit) : Process::Status

            # We first check if there is any task left
            if File.exists?("#{taskFilePath}")
                process = Process.run(  command:    "/usr/bin/sudo /usr/bin/chattr -f -i #{taskFilePath}",
                                        input:      (quiet ? Process::Redirect::Close : input),
                                        output:     (quiet ? Process::Redirect::Close : output),
                                        error:      (quiet ? Process::Redirect::Close : error),
                                        shell:      true)

                process = Process.run(  command: "/usr/bin/sudo /usr/bin/rm #{taskFilePath}",
                                        input:      (quiet ? Process::Redirect::Close : input),
                                        output:     (quiet ? Process::Redirect::Close : output),
                                        error:      (quiet ? Process::Redirect::Close : error),
                                        shell: true)
            end

            if !Dir.exists?(taskFileDirectory)
                Dir.mkdir_p(taskFileDirectory)
            end

            File.write(taskFilePath, chrootTasks)

            process = Process.run(  "/usr/bin/sudo /usr/bin/chmod +x #{taskFilePath}",
                                    input:      (quiet ? Process::Redirect::Close : input),
                                    output:     (quiet ? Process::Redirect::Close : output),
                                    error:      (quiet ? Process::Redirect::Close : error),
                                    shell: true)

            command = "HOME=/var/lib/ism /usr/bin/sudo /usr/sbin/chroot #{asRoot ? "" : "--userspec=#{ISM::Default::Core::SystemUserId}:#{ISM::Default::Core::SystemUserId}"} #{commandLineSettings.rootPath} ./#{taskFilePath(relatedToChroot: true)}"

            process = Process.run(  command: command,
                                    input:      (quiet ? Process::Redirect::Close : input),
                                    output:     (quiet ? Process::Redirect::Close : output),
                                    error:      (quiet ? Process::Redirect::Close : error),
                                    shell: true)

            return process

            rescue exception
                raisedError =  <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{command}
                asRoot: #{asRoot}
                ERROR

                ISM::Core::Error.show(  className: "Core",
                                        functionName: "runChrootTasks",
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

            if commandLineSettings.installByChroot && viaChroot
                chrootCommand = <<-CODE
                #!/bin/bash

                if \[ -f "/etc/profile" \]; then
                    source /etc/profile
                fi

                cd #{path} && #{environmentCommand} #{command}
                CODE

                process = runChrootTasks(chrootCommand, quiet, superuser, input, output, error)
            else
                environmentHash = Hash(String, String).new

                #Substitute all environment variables by the real value
                environment.keys.each do |key|
                    environmentHash[key] = environment[key].gsub(/\$([A-Z0-9]+)/) do |_, match|
                        begin
                            ENV[match[1]]
                        rescue
                            #Return empty string if the var don't exist
                            String.new
                        end
                    end
                end

                process = Process.run(  command:    "#{asRoot ? "sudo" : ""} #{command}",
                                        input:      (quiet ? Process::Redirect::Close : input),
                                        output:     (quiet ? Process::Redirect::Close : output),
                                        error:      (quiet ? Process::Redirect::Close : error),
                                        shell:      true,
                                        chdir:      (path.empty? ? nil : path),
                                        env:        environmentHash)
            end

            return process

            rescue exception
                raisedError =  <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                commands: #{command}
                asRoot: #{asRoot}
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

        def self.selectedKernel : ISM::SoftwareInformation
            file = "#{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::SelectedKernel}"

            if File.exists?(file)
                return ISM::SoftwareInformation.loadConfiguration(file)
            else
                return ISM::SoftwareInformation.new
            end

            rescue exception
            ISM::Core::Error.show(  className: "Core",
                                    functionName: "selectedKernel",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.kernelIsSelected
            return selectedKernel.isValid

            rescue exception
            ISM::Core::Error.show(  className: "Core",
                                    functionName: "kernelIsSelected",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.mainKernelName : String
            return selectedKernel.versionName.downcase

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "mainKernelName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.mainKernelHeadersName : String
            return "#{selectedKernel.name.downcase}-headers-#{selectedKernel.version.downcase}"

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "mainKernelHeadersName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.mainKernelVersion : String
            return ISM::Core.selectedKernel.version

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "mainKernelVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.kernelSourcesPath : String
            return "#{commandLineSettings.rootPath}usr/src/#{mainKernelName}/"

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "kernelSourcesPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.kernelConfigPath : String
            return "#{kernelSourcesPath}/.config"

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "kernelConfigPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

    end

end
