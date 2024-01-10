module ISM

    class SystemGroupSoftware < ISM::VirtualSoftware

        property name : String
        property id : Int32
        property isUserGroup : Bool

        def initialize
            super

            @name = String.new
            @id = Int32.new
            @isUserGroup = false
        end

        def initializeGroup(@name,@id)
        end

        def download
        end

        def check
        end

        def extract
        end

        def patch
        end

        def prepare
        end

        def configure
        end

        def build
        end

        def prepareInstallation
            super

            if @name == ""
                Ism.notifyOfSystemGroupGenerationError
                Ism.exitProgram
            end

            cleanWorkDirectoryPath

            updateGroupFile(@name,@id,@isUserGroup)
        end

        def install
            Ism.addInstalledSoftware(@information)
        end

        def clean
        end

    end

end
