module ISM

    class NeededKernelOption

        module Default

            FileLoadProcessSyntaxErrorText1 = "Syntax errors detected during file load process "
            FileLoadProcessSyntaxErrorText2 = " at line number "

        end

        include JSON::Serializable

        property name : String
        property state : String
        property value : String


        def initialize( @name = String.new,
                        @state = String.new,
                        @value = String.new)
        end

        def self.loadConfiguration(path : String)
            begin
                return from_json(File.read(path))
            rescue error : JSON::ParseException
                puts    "#{ISM::Default::NeededKernelOption::FileLoadProcessSyntaxErrorText1 +
                        path +
                        ISM::Default::NeededKernelOption::FileLoadProcessSyntaxErrorText2 +
                        error.line_number.to_s}".colorize(:yellow)
                return self.new
            end

            rescue exception
                ISM::Error.show(className: "NeededKernelOption",
                                functionName: "loadConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def writeConfiguration(path : String)
            finalPath = path.chomp(path[path.rindex("/")..-1])

            if !Dir.exists?(finalPath)
                Dir.mkdir_p(finalPath)
            end

            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "NeededKernelOption",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
