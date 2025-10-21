module ISM

    module TraceLog

        def self.record(accessor : String,
                        function : String,
                        message : String)
            logDirectoryPath = "#{Ism.settings.rootPath}#{Path::LogsDirectory}"

            Ism.createSystemDirectory(logDirectoryPath)

            recordingTime = Time.local

            day = recordingTime.day
            month = recordingTime.month
            year = recordingTime.year
            hour = recordingTime.hour
            minute = recordingTime.minute
            second = recordingTime.second

            date = "------------------(#{day}/#{month}/#{year} #{hour}:#{minute}:#{second})------------------"

            record = "\n#{date}\n#{accessor}::#{function}:\n#{message}\n"

            File.write("#{logDirectoryPath}#{Filename::TraceLog}", record, mode: "a")

            rescue exception
                ISM::Error.show(className: "TraceLog",
                                functionName: "record",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
