module ISM

    class TaskBuildingProcessError

            getter file :           String
            getter line :           Int32
            getter column :         Int32
            getter size :           Int32
            getter message :        String

            include JSON::Serializable

            def initialize( @file = String.new,
                            @line = 0,
                            @column = 0,
                            @size = 0,
                            @message = String.new)
            end
    end

end
