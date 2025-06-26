module ISM

    module Option

        class KeyringAdd < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::KeyringAdd::ShortText,
                        ISM::Default::Option::KeyringAdd::LongText,
                        ISM::Default::Option::KeyringAdd::Description)
            end

            def start
                if ARGV.size == 3
                    showHelp
                else

                    filePath = ARGV[4]

                    if !File.exists?(filePath)

                    elsif filePath[-5..-1] != ".json"

                    else

                    end

                end

            end

        end
        
    end

end
