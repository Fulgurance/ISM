module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                synchronizationStartingTime = Time.monotonic
                frameIndex = 0
                reverseAnimation = false
                
                print ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle
                text = ISM::Default::Option::SoftwareSynchronize::SynchronizationWaitingText

                Ism.ports.each do |port|

                    process = Process.new("git",args: ["pull","origin",Ism.portsSettings.targetVersion],
                                                chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                    until process.terminated?
                        calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(synchronizationStartingTime, frameIndex, reverseAnimation, text)
                        sleep 0
                    end

                end

                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts "The database is synchronized"
                    
            end

        end
        
    end

end
