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

                    synchronization = port.synchronize

                    until synchronization.terminated?
                        synchronizationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(synchronizationStartingTime, frameIndex, reverseAnimation, text)
                        sleep 0
                    end

                end

                Ism.cleanCalculationAnimation(frameIndex)
                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts ISM::Default::Option::SoftwareSynchronize::SynchronizedText
                    
            end

        end
        
    end

end
