module ISM

    module Option

        class PortSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortSynchronize::ShortText,
                        ISM::Default::Option::PortSynchronize::LongText,
                        ISM::Default::Option::PortSynchronize::Description)
            end

            def start
                oldPortList = Array(String).new

                Ism.ports.each do |port|
                    if Dir.exists?(port.directoryPath) && !Dir.glob("#{port.directoryPath}/*").empty?
                        oldPortList.push(port.name)
                    end
                end

                puts
                print ISM::Default::Option::PortSynchronize::SynchronizationTitle

                Ism.synchronizePorts

                newPortList = Array(String).new

                Dir.glob("#{Ism.settings.rootPath+ISM::Default::Path::PortsDirectory}/*").each do |port|
                    name = port.sub(Ism.settings.rootPath+ISM::Default::Path::PortsDirectory,"")[0..-6]

                    newPortList.push(name)
                end

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

                print "#{ISM::Default::Option::PortSynchronize::SynchronizationDoneText.colorize(:green)}\n"
                puts "#{ISM::Default::Option::PortSynchronize::SynchronizedText.colorize(:green)}"

                puts

                puts "#{ISM::Default::Option::PortSynchronize::NewPortsText.colorize(:green)} #{newPortNumber > 0 ? "#{"+".colorize(:red)}" : ""}#{newPortNumber > 0 ? newPortNumber.colorize(:red) : newPortNumber}"
                puts "#{ISM::Default::Option::PortSynchronize::DeletedPortsText.colorize(:green)} #{deletedPortNumber > 0 ? "#{"-".colorize(:blue)}" : ""}#{deletedPortNumber > 0 ? deletedPortNumber.colorize(:blue) : deletedPortNumber}"
                puts "#{ISM::Default::Option::PortSynchronize::TotalSynchronizedPortsText.colorize(:green)} #{Ism.ports.size}"
                puts "#{ISM::Default::Option::PortSynchronize::TotalAvailableSoftwaresText.colorize(:green)} #{Ism.softwares.size}"
            end

        end
        
    end

end
