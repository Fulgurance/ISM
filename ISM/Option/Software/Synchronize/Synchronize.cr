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

                #Pour chaque dépot, utiliser les branches selon la stabilité voulue (stable, testing ...etc)
                Ism.ports.each do |port|
                    currentTime = Time.monotonic

                    if (currentTime - synchronizationStartingTime).milliseconds > 40
                        if frameIndex >= text.size
                            reverseAnimation = true
                        end

                        if frameIndex < 1
                            reverseAnimation = false
                        end

                        if reverseAnimation
                            print "\033[1D"
                            print " "
                            print "\033[1D"
                            frameIndex -= 1
                        end

                        if !reverseAnimation
                            print "#{text[frameIndex].colorize(:green)}"
                            frameIndex += 1
                        end

                        synchronizationStartingTime = Time.monotonic
                    end

                    Process.run("git",  args: ["pull","origin","master"],
                                        chdir: ISM::Default::Path::SoftwaresDirectory+port.name)
                end

                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts "The database is synchronized"
                    
            end

        end
        
    end

end
