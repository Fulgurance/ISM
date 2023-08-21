module ISM

  class KernelOption
    
    include JSON::Serializable

    property name : String
    property tristate : Bool
    property dependencies : Array(String)
    property singleChoiceDependencies : Array(Array(String))
    property conditionalKernelDependencies : Array(ISM::ConditionalKernelDependency)
    property specialDependencies : Array(String)
    property blockers : Array(String)

    def initialize( @name = String.new,
                    @tristate = false,
                    @dependencies = Array(String).new,
                    @singleChoiceDependencies = Array(Array(String)).new,
                    @conditionalKernelDependencies = Array(ISM::ConditionalKernelDependency).new,
                    @specialDependencies = Array(String).new,
                    @blockers = Array(String).new)
    end

    def loadInformationFile(loadInformationFilePath : String)
        begin
            information = KernelOption.from_json(File.read(loadInformationFilePath))
        rescue error : JSON::ParseException
            puts    "#{ISM::Default::KernelOption::FileLoadProcessSyntaxErrorText1 +
                    loadInformationFilePath +
                    ISM::Default::KernelOption::FileLoadProcessSyntaxErrorText2 +
                    error.line_number.to_s}".colorize(:yellow)
            return
        end

        @name = information.name
        @tristate = information.tristate
        @dependencies = information.dependencies
        @singleChoiceDependencies = information.singleChoiceDependencies
        @conditionalKernelDependencies = information.conditionalKernelDependencies
        @specialDependencies = information.specialDependencies
        @blockers = information.blockers
    end

    def writeInformationFile(writeInformationFilePath : String)
        path = writeInformationFilePath.chomp(writeInformationFilePath[writeInformationFilePath.rindex("/")..-1])

        if !Dir.exists?(path)
            Dir.mkdir_p(path)
        end

        information = KernelOption.new( @name,
                                        @tristate,
                                        @dependencies,
                                        @singleChoiceDependencies,
                                        @conditionalKernelDependencies,
                                        @specialDependencies,
                                        @blockers)

        file = File.open(writeInformationFilePath,"w")
        information.to_json(file)
        file.close
    end

  end

end
