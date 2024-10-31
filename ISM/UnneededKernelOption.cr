module ISM

    class UnneededKernelOption

        include JSON::Serializable

        property name : String

        def initialize( @name = String.new)
        end

        def self.loadConfiguration(path : String)
            begin
                return from_json(File.read(path))
            rescue error : JSON::ParseException
                puts    "#{ISM::Default::UnneededKernelOption::FileLoadProcessSyntaxErrorText1 +
                        path +
                        ISM::Default::UnneededKernelOption::FileLoadProcessSyntaxErrorText2 +
                        error.line_number.to_s}".colorize(:yellow)
                return self.new
            end
        end

        def writeConfiguration(path : String)
            finalPath = path.chomp(path[path.rindex("/")..-1])

            if !Dir.exists?(finalPath)
                Dir.mkdir_p(finalPath)
            end

            file = File.open(path,"w")
            to_json(file)
            file.close
        end

    end

end
