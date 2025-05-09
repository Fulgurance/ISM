module ISM

    module Option

        class PortSetTargetVersion < ISM::CommandLineOption

            module Default
                ShortText = "-stv"
                LongText = "settargetversion"
                Description = "Set the target version for all ports, based on a ISM version"
                SetTitle = "ISM start to set the target version: "
                SetWaitingText = "Setting the target version"
                SetText = "Setting the default target version to "
                SetTextError1 = "Impossible to target the given version:  "
                SetTextError2 = ". This version doesn't exist."
            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    targetVersion = ARGV[2]
                    validVersion = false

                    if !Ism.ports.empty?
                        print Default::SetTitle
                        text = Default::SetWaitingText

                        Ism.ports.each do |port|
                            process = Process.new(  "git switch --detach #{targetVersion}",
                                                    shell: true,
                                                    chdir: Ism.settings.rootPath+Path::SoftwaresDirectory+port.name)

                            until process.terminated?
                                Ism.playCalculationAnimation(text: text)
                                sleep(Time::Span.new(seconds: 0))
                            end

                            validVersion = !process.error?

                            if !validVersion
                                break
                            end
                        end
                    end

                    puts

                    if validVersion
                        Ism.portsSettings.setTargetVersion(targetVersion)
                        Ism.printProcessNotification(Default::SetText+targetVersion)
                    else
                        Ism.printErrorNotification(Default::SetTextError1+"#{targetVersion.colorize(:red)}"+Default::SetTextError2,nil)
                    end
                end
            end

        end
        
    end

end
