module ISM

    class FavouriteGroup

        def_clone

        include JSON::Serializable

        property name : String
        property softwares : Array(String)

        def initialize(@name = ISM::Default::FavouriteGroup::Name, @softwares = Array(String).new)
        end

        def self.filePath(name = ISM::Default::FavouriteGroup::Name) : String
            return Ism.settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory+name+".json"
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json
            file.close
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close
        end

    end

end
