module ISM

  class KernelOption
    
    include JSON::Serializable

    property name : String
    property tristate : Bool
    property dependencies : Array(String)
    property singleChoiceDependencies : Array(Array(String))
    property blockers : Array(String)

    def initialize( @name = String.new,
                    @tristate = false,
                    @dependencies = Array(String).new,
                    @singleChoiceDependencies = Array(Array(String)).new,
                    @blockers = Array(String).new)
    end

    def self.loadConfiguration(path : String)
        begin
            from_json(File.read(path))
        rescue error : JSON::ParseException
            puts    "#{ISM::Default::KernelOption::FileLoadProcessSyntaxErrorText1 +
                    path +
                    ISM::Default::KernelOption::FileLoadProcessSyntaxErrorText2 +
                    error.line_number.to_s}".colorize(:yellow)
            return
        end
    end

    def loadConfiguration(path : String)
        return self.loadConfiguration(path)
    end

    def writeConfiguration(path : String)
        finalPath = path.chomp(path[path.rindex("/")..-1])

        if !Dir.exists?(finalPath)
            Dir.mkdir_p(finalPath)
        end

        file = File.open(path,"w")
        information.to_json(file)
        file.close
    end

  end

end
