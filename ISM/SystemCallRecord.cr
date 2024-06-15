module ISM

    class SystemCallRecord

        property command :      String
        property path :         String
        property environment :  Hash(String,String)

        def initialize( @command =      String.new,
                        @path =         String.new,
                        @environment =  Hash(String,String).new)
        end

        def formattedOutput
            command =       "#{ISM::Default::SystemCallRecord::FormattedOutputText1}#{@command}"
            path =          "#{ISM::Default::SystemCallRecord::FormattedOutputText2}#{@path}"
            environment =   "#{ISM::Default::SystemCallRecord::FormattedOutputText3}#{(@environment.map { |key| key.join("=") }).join(" ")}"

            return "#{command}#{path}#{environment}"
        end

    end

end
