module ISM

    class SystemCallRecord

        property exitCode :     Int32
        property command :      String
        property path :         String
        property environment :  Hash(String,String)

        def initialize( @exitCode =     Int32.new,
                        @command =      String.new,
                        @path =         String.new,
                        @environment =  Hash(String,String).new)
        end

        def formattedOutput
            code =          "#{ISM::Default::SystemCallRecord::FormattedOutputText1}#{@exitCode.to_s}\n"
            command =       "#{ISM::Default::SystemCallRecord::FormattedOutputText2}#{@command}"
            path =          "#{ISM::Default::SystemCallRecord::FormattedOutputText3}#{@path}"
            environment =   "#{ISM::Default::SystemCallRecord::FormattedOutputText4}#{(@environment.map { |key| key.join("=") }).join(" ")}"

            return "#{exitCode}#{command}#{path}#{environment}"
        end

    end

end
