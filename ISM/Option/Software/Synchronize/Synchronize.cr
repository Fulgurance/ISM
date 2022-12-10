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
                
                print ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle
                text = ISM::Default::Option::SoftwareSynchronize::SynchronizationWaitingText

                #Pour chaque dépot, utiliser les branches selon la stabilité voulue (stable, testing ...etc)
                Ism.ports.each do |port|

                    calculationStartingTime, frameIndex = Ism.playCalculationAnimation(synchronizationStartingTime, frameIndex, text)

                    Process.run("git",  args: ["pull","origin","master"],
                                        chdir: ISM::Default::Path::SoftwaresDirectory+port.name)
                end

                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts "The database is synchronized"
                    
            end

        end
        
    end

end
