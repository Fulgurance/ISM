module ISM

    module Option

        class PortSetTargetVersion < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortSetTargetVersion::ShortText,
                        ISM::Default::Option::PortSetTargetVersion::LongText,
                        ISM::Default::Option::PortSetTargetVersion::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    targetVersion = ARGV[2+Ism.debugLevel]
                    validVersion = false

                    if !Ism.ports.empty?
                        print ISM::Default::Option::PortSetTargetVersion::SetTitle
                        text = ISM::Default::Option::PortSetTargetVersion::SetWaitingText

                        Ism.ports.each do |port|
                            process = Process.new(  "git switch --detach #{targetVersion}",
                                                    shell: true,
                                                    chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                            until process.terminated?
                                Ism.playCalculationAnimation(text: text)
                                sleep 0
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
                        Ism.printProcessNotification(ISM::Default::Option::PortSetTargetVersion::SetText+targetVersion)
                    else
                        Ism.printErrorNotification(ISM::Default::Option::PortSetTargetVersion::SetTextError1+"#{targetVersion.colorize(:red)}"+ISM::Default::Option::PortSetTargetVersion::SetTextError2,nil)
                    end
                end
            end

        end
        
    end

end
