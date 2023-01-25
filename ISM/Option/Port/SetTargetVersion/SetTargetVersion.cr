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
                        setStartingTime = Time.monotonic
                        frameIndex = 0

                        print ISM::Default::Option::PortSetTargetVersion::SetTitle
                        text = ISM::Default::Option::PortSetTargetVersion::SetWaitingText

                        Ism.ports.each do |port|
                            process = Process.new("git",args: ["switch","--detach",targetVersion],
                                                        chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                            until process.terminated?
                                calculationStartingTime, frameIndex = Ism.playCalculationAnimation(setStartingTime, frameIndex, text)
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
                        puts    "#{"* ".colorize(:green)}" +
                                ISM::Default::Option::PortSetTargetVersion::SetText +
                                targetVersion
                    else
                        puts    "#{"* ".colorize(:red)}" +
                                ISM::Default::Option::PortSetTargetVersion::SetTextError1 +
                                "#{targetVersion.colorize(:red)}" +
                                ISM::Default::Option::PortSetTargetVersion::SetTextError2
                    end
                end
            end

        end
        
    end

end
