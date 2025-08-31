module ISM

    module Option

        class Port

            class Close < ISM::CommandLineOption

                module Default

                    ShortText = "-c"
                    LongText = "close"
                    Description = "Close the specified port"
                    CloseText = "Closing port "
                    NoMatchFoundText1 = "The port "
                    NoMatchFoundText2 = " is not open"

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
                        if ISM::Port.exists(ARGV[2])
                            Ism.printProcessNotification(Default::CloseText+ARGV[2])
                            ISM::Port.delete(ARGV[2])
                        else
                            Ism.printErrorNotification(Default::NoMatchFoundText1+ARGV[2]+Default::NoMatchFoundText2,nil)
                        end
                    end
                end

            end

        end
        
    end

end
