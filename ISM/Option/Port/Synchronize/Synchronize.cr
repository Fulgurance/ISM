module ISM

    module Option

        class Port

            class Synchronize < ISM::CommandLineOption

                module Default

                    ShortText = "-sy"
                    LongText = "synchronize"
                    Description = "Synchronize the port database"
                    SynchronizationTitle = "#{CommandLine::Default::Name.upcase} start to synchronizing: "
                    SynchronizationDoneText = "Done !"
                    SynchronizedText = "The database is synchronized"
                    NewPortsText = "New added ports:"
                    DeletedPortsText = "Deleted ports:"
                    TotalSynchronizedPortsText = "Synchronized ports:"
                    TotalAvailableSoftwaresText = "Available softwares:"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    oldPortList = Array(String).new

                    Ism.ports.each do |port|
                        if Dir.exists?(port.directoryPath) && !Dir.glob("#{port.directoryPath}/*").empty?
                            oldPortList.push(port.name)
                        end
                    end

                    puts
                    print Default::SynchronizationTitle

                    Ism.synchronizePorts

                    newPortList = Array(String).new

                    Dir.glob("#{Ism.settings.rootPath+Path::PortsDirectory}/*").each do |port|
                        name = port.sub(Ism.settings.rootPath+Path::PortsDirectory,"")[0..-6]

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

                    print "#{Default::SynchronizationDoneText.colorize(:green)}\n"
                    puts "#{Default::SynchronizedText.colorize(:green)}"

                    puts

                    puts "#{Default::NewPortsText.colorize(:green)} #{newPortNumber > 0 ? "#{"+".colorize(:red)}" : ""}#{newPortNumber > 0 ? newPortNumber.colorize(:red) : newPortNumber}"
                    puts "#{Default::DeletedPortsText.colorize(:green)} #{deletedPortNumber > 0 ? "#{"-".colorize(:blue)}" : ""}#{deletedPortNumber > 0 ? deletedPortNumber.colorize(:blue) : deletedPortNumber}"
                    puts "#{Default::TotalSynchronizedPortsText.colorize(:green)} #{Ism.ports.size}"
                    puts "#{Default::TotalAvailableSoftwaresText.colorize(:green)} #{Ism.softwares.size}"
                end

            end

        end

    end

end
