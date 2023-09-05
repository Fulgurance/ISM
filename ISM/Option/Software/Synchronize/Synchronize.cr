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
                print ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle

                Ism.synchronizePorts

                print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts ISM::Default::Option::SoftwareSynchronize::SynchronizedText
                    
            end

        end
        
    end

end
