module ISM

    class FavouriteGroup

        def_clone

        include JSON::Serializable

        property name : String
        property softwares : Array(String)

        def initialize(@name = String.new, @softwares = Array(String).new)
        end

        def filePath : String
            return Ism.settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory+@name+".json"
        end

        def loadFavouriteGroupFile
            if !File.exists?(filePath)
                writeFavouriteGroupFile
            end

            information = FavouriteGroup.from_json(File.read(filePath))
            @name = information.name
            @softwares = information.softwares
        end

        def writeFavouriteGroupFile
            favouriteGroup = FavouriteGroup.new(@name,@softwares)

            file = File.open(filePath,"w")
            favouriteGroup.to_json(file)
            file.close
        end

    end

end
