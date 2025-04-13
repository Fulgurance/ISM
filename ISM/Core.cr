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

        def self.runSystemCommand(  command : String,
                                    path = (ISM::CommandLineSettings.loadConfiguration.installByChroot ? "/" : ISM::CommandLineSettings.loadConfiguration.rootPath),
                                    environment = Hash(String, String).new,
                                    environmentFilePath = String.new,
                                    quiet = false,
                                    asRoot = false,
                                    shell = true,
                                    chroot = true,
                                    input = Process::Redirect::Inherit,
                                    output = Process::Redirect::Inherit,
                                    error = Process::Redirect::Inherit,
                                    ignoreErrorCodeList = Array(Int32).new) : Process::Status

            #########################TASKS#########################
            settings = ISM::CommandLineSettings.loadConfiguration

            #Common variables preparation
            asSuperuser =   (asRoot && ISM::Core::Security.systemHandleUserAccess)
            viaChroot =     ((settings.installByChroot && chroot) ? true : false)
            sudoCommand =   (shell ? "sudo" : "/usr/bin/sudo")
            chrootCommand = (shell ? "chroot" : "/usr/sbin/chroot")
            inputValue =    (quiet ? Process::Redirect::Close : input)
            outputValue =   (quiet ? Process::Redirect::Close : output)
            errorValue =    (quiet ? Process::Redirect::Close : error)
            realRootPath =  "#{(viaChroot ? settings.rootPath : "/")}"
            taskFilePath =  "#{realRootPath}#{ISM::Default::Filename::Task}"

            #Exclusive variables preparation
            chrootTaskPrefix =  "HOME=/var/lib/ism #{sudoCommand} #{chrootCommand} #{asSuperuser ? "" : "--userspec=#{ISM::Default::Core::Security::SystemName}:#{ISM::Default::Core::Security::SystemName}"} #{settings.rootPath}"
            taskPrefix =        "#{asSuperuser ? "#{sudoCommand} " : ""}"

            #Determine what will prefix the requested command
            prefix = (viaChroot ? chrootTaskPrefix : taskPrefix)

            #Loading environment
            environmentCommand = String.new

            if !environmentFilePath.empty?
                environmentCommand = "source \"#{environmentFilePath}\" && "
            end

            environment.keys.each do |key|
                environmentCommand += "#{key}=\"#{environment[key]}\" "
            end

            #Task core
            tasks = <<-CODE
            #!/bin/bash

            if \[ -f "/etc/profile" \]; then
                source /etc/profile
            fi

            cd #{realRootPath} && #{environmentCommand} #{command}
            CODE

            processCommand = "#{prefix}/#{ISM::Default::Filename::Task}"

            #########################TASKS#########################

            #Clean leftover from previous task
            if File.exists?(taskFilePath)
                #We need first to unlock it
                process = Process.run(  command: "/usr/bin/sudo",
                                        args: ["/usr/bin/chattr","-f","-i",taskFilePath],
                                        shell: false,
                                        input: inputValue,
                                        output: outputValue,
                                        error: errorValue)

                #Then we delete it
                process = Process.run(  command: "/usr/bin/sudo",
                                        args: ["/usr/bin/rm",taskFilePath],
                                        shell: false,
                                        input: inputValue,
                                        output: outputValue,
                                        error: errorValue)
            end

            #Generate a new task file
            File.write(taskFilePath, tasks)

            #We make it executable
            process = Process.run(  command: "/usr/bin/sudo",
                                    args: ["/usr/bin/chmod","+x",taskFilePath],
                                    shell: false,
                                    input: inputValue,
                                    output: outputValue,
                                    error: errorValue)

            #We now lock the new task to avoid any modification
            process = Process.run(  command: "/usr/bin/sudo",
                                    args: ["/usr/bin/chattr","-f","+i",taskFilePath],
                                    shell: false,
                                    input: inputValue,
                                    output: outputValue,
                                    error: errorValue)

            #We can now run the generated task
            process = Process.run(  command: processCommand,
                                    shell: true,
                                    input: inputValue,
                                    output: outputValue,
                                    error: errorValue)

            return process

            rescue exception
                raisedError =  <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{processCommand}
                path: #{realRootPath}
                environment: #{environmentCommand}
                asRoot: #{asSuperuser}
                chroot: #{viaChroot}
                shell:  #{shell}
                ERROR

                ISM::Core::Error.show(  className: "Core",
                                        functionName: "runSystemCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the following process:\n#{raisedError}",
                                        exception: exception)
        end


        def self.progressivePrint(text : String, delay = 10)
            text.each_char do |character|
                sleep(Time::Span.new(nanoseconds: delay * 1000000))

                print character
            end
        end

        def self.targetedRootPath : String
            settings = ISM::CommandLineSettings.loadConfiguration
            return (settings.installByChroot || !settings.installByChroot && (settings.rootPath != "/") ? settings.rootPath : "/")
        end

    end

end
