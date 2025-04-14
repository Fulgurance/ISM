module ISM

    module Option

        class PortClose < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortClose::ShortText,
                        ISM::Default::Option::PortClose::LongText,
                        ISM::Default::Option::PortClose::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else

                    if ISM::Port.exists(ARGV[2])
                        ISM::Core::Notification.processNotification(ISM::Default::Option::PortClose::CloseText+ARGV[2])
                        ISM::Port.delete(ARGV[2])
                    else
                        ISM::Core::Notification.errorNotification(ISM::Default::Option::PortClose::NoMatchFoundText1+ARGV[2]+ISM::Default::Option::PortClose::NoMatchFoundText2,nil)
                    end

                end
            end

        end
        
    end

end
