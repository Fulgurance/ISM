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

        def self.runSystemCommand(  command : String,
                                    path = ISM::CommandLineSettings.loadConfiguration.installByChroot ? "/" : ISM::CommandLineSettings.loadConfiguration.rootPath,
                                    environment = Hash(String, String).new,
                                    environmentFilePath = String.new,
                                    quiet = false,
                                    asRoot = false,
                                    shell = true,
                                    chroot = true,
                                    input = Process::Redirect::Inherit,
                                    output = Process::Redirect::Inherit,
                                    error = Process::Redirect::Inherit,
                                    ignoreErrorCodeList = Array(Int32).new)

            #########################TASKS#########################

            #Common variables preparation
            taskFilePath =  "#{realRootPath}#{ISM::Default::Filename::Task}"
            asSuperuser =   (asRoot && ISM::Core::Security.systemHandleUserAccess)
            viaChroot =     (ISM::CommandLineSettings.loadConfiguration.installByChroot && chroot ? true : false)
            sudoCommand =   (shell ? "sudo" : "/usr/bin/sudo")
            chrootCommand = (shell ? "chroot" : "/usr/sbin/chroot")
            inputValue =    (quiet ? Process::Redirect::Close : input)
            outputValue =   (quiet ? Process::Redirect::Close : output)
            errorValue =    (quiet ? Process::Redirect::Close : error)
            realRootPath =  "#{(viaChroot ? ISM::CommandLineSettings.loadConfiguration.rootPath : "/")}"

            #Exclusive variables preparation
            chrootTaskPrefix =  "HOME=/var/lib/ism #{sudoCommand} #{chrootCommand} #{asSuperuser ? "" : "--userspec=#{ISM::Default::Core::Security::SystemName}:#{ISM::Default::Core::Security::SystemName}"} #{ISM::CommandLineSettings.loadConfiguration.rootPath}"
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
                                        input: (quiet ? Process::Redirect::Close : input),
                                        output: (quiet ? Process::Redirect::Close : output),
                                        error: (quiet ? Process::Redirect::Close : error))

                #Then we delete it
                process = Process.run(  command: "/usr/bin/sudo",
                                        args: ["/usr/bin/rm",taskFilePath],
                                        shell: false,
                                        input: (quiet ? Process::Redirect::Close : input),
                                        output: (quiet ? Process::Redirect::Close : output),
                                        error: (quiet ? Process::Redirect::Close : error))
            end

            #Generate a new task file
            File.write(taskFilePath, tasks)

            #We make it executable
            process = Process.run(  command: "/usr/bin/sudo",
                                    args: ["/usr/bin/chmod","+x",taskFilePath],
                                    shell: false,
                                    input: (quiet ? Process::Redirect::Close : input),
                                    output: (quiet ? Process::Redirect::Close : output),
                                    error: (quiet ? Process::Redirect::Close : error))

            #We now lock the new task to avoid any modification
            process = Process.run(  command: "/usr/bin/sudo",
                                    args: ["/usr/bin/chattr","-f","+i",taskFilePath],
                                    shell: false,
                                    input: (quiet ? Process::Redirect::Close : input),
                                    output: (quiet ? Process::Redirect::Close : output),
                                    error: (quiet ? Process::Redirect::Close : error))

            #We can now run the generated task
            process = Process.run(  command: processCommand,
                                    shell: true,
                                    input: (quiet ? Process::Redirect::Close : input),
                                    output: (quiet ? Process::Redirect::Close : output),
                                    error: (quiet ? Process::Redirect::Close : error))

            if !process.exit_code != 0 && !ignoreErrorCodeList.includes?(process.exit_code)
                raise <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{processCommand}
                path: #{realRootPath}
                environment: #{environmentCommand}
                asRoot: #{asSuperuser}
                chroot: #{viaChroot}
                shell:  #{shell}
                ERROR
            end

            #If the process fail, we first check if there is any error code we can ignore and then raise the error properly
            rescue
                raise <<-ERROR
                #{ISM::Default::Error::SystemCommandFailure}
                command: #{processCommand}
                path: #{realRootPath}
                environment: #{environmentCommand}
                asRoot: #{asSuperuser}
                chroot: #{viaChroot}
                shell:  #{shell}
                ERROR
        end

        #rootPath = (@settings.installByChroot || !@settings.installByChroot && (@settings.rootPath != "/") ? @settings.rootPath : "/")

    end

end
