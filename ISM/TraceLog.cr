module ISM

    module TraceLog

        def self.logDirectoryPath
            return "#{Ism.settings.rootPath}#{Path::LogsDirectory}"
        end

        def self.makeLogDirectory

            Ism.createSystemDirectory(logDirectoryPath)

            rescue exception
                ISM::Error.show(className: "Tracelog",
                                functionName: "makeLogDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.record(accessor : String,
                        function : String,
                        message : String)

            recordingTime = Time.local

            day = recordingTime.day
            month = recordingTime.month
            year = recordingTime.year
            hour = recordingTime.hour
            minute = recordingTime.minute
            second = recordingTime.second

            date = "------------------(#{day}/#{month}/#{year} #{hour}:#{minute}:#{second})------------------"

            record = "\n#{date}\n#{accessor}::#{function}:\n#{message}\n"

            makeLogDirectory

            File.write("#{logDirectoryPath}#{Filename::TraceLog}", record, mode: "a")

            rescue exception
                ISM::Error.show(className: "Tracelog",
                                functionName: "record",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
