module ISM

    struct TaskBuildingProcessError

            getter file :           String
            getter line :           Int32
            getter column :         Int32
            getter size :           Int32
            getter message :        String

            include JSON::Serializable
    end

end
