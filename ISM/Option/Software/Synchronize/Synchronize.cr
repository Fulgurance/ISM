module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description)
            end

            def start
                if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                    Ism.printNeedSuperUserAccessNotification
                else
                    oldPortList = Ism.ports.map { |entry| entry.name}

                    puts ISM::Default::Option::SoftwareSynchronize::SynchronizationTitle

                    Ism.synchronizePorts

                    newPortList = Ism.ports.map { |entry| entry.name}

                    newPortNumber = 0
                    deletedPortNumber = 0

                    oldPortList.each do |entry|
                        if !newPortList.includes?(entry)
                            deletedPortNumber += 1
                        end
                    end

                    newPortList.each do |entry|
                        if !oldPortList.includes?(entry)
                            newPortNumber += 1
                        end
                    end

                    print "#{ISM::Default::Option::SoftwareSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                    puts "#{ISM::Default::Option::SoftwareSynchronize::SynchronizedText.colorize(:green)}"

                    puts

                    puts "#{ISM::Default::Option::SoftwareSynchronize::NewPortsText.colorize(:green)} #{newPortNumber > 0 ? "#{"+".colorize(:red)}" : ""}#{newPortNumber > 0 ? newPortNumber.colorize(:red) : newPortNumber}"
                    puts "#{ISM::Default::Option::SoftwareSynchronize::DeletedPortsText.colorize(:green)} #{deletedPortNumber > 0 ? "#{"-".colorize(:blue)}" : ""}#{deletedPortNumber > 0 ? deletedPortNumber.colorize(:blue) : deletedPortNumber}"
                    puts "#{ISM::Default::Option::SoftwareSynchronize::TotalSynchronizedPortsText.colorize(:green)} #{Ism.ports.size}"
                    puts "#{ISM::Default::Option::SoftwareSynchronize::TotalAvailableSoftwaresText.colorize(:green)} #{Ism.softwares.size}"
                end
            end

        end
        
    end

end
