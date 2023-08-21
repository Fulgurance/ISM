module ISM

  class ConditionalKernelDependency
    
    include JSON::Serializable

    property name : String
    property conditions : String

    def initialize(@name = String.new,@conditions = String.new)
    end

    def loadInformationFile(loadInformationFilePath : String)
        begin
            information = ConditionalKernelDependency.from_json(File.read(loadInformationFilePath))
        rescue error : JSON::ParseException
            puts    "#{ISM::Default::ConditionalKernelDependency::FileLoadProcessSyntaxErrorText1 +
                    loadInformationFilePath +
                    ISM::Default::ConditionalKernelDependency::FileLoadProcessSyntaxErrorText2 +
                    error.line_number.to_s}".colorize(:yellow)
            return
        end

        @name = information.name
        @conditions = information.conditions
    end

    def writeInformationFile(writeInformationFilePath : String)
        path = writeInformationFilePath.chomp(writeInformationFilePath[writeInformationFilePath.rindex("/")..-1])

        if !Dir.exists?(path)
            Dir.mkdir_p(path)
        end

        information = KernelOption.new(@name,@conditions)

        file = File.open(writeInformationFilePath,"w")
        information.to_json(file)
        file.close
    end

  end

end
