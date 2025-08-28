module ISM

    module Default

        module Option

            module PortSynchronize

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
            
        end

    end

end
