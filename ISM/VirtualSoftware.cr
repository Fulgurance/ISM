module ISM

    class VirtualSoftware < ISM::Software

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
        end

        def install : Tuple(UInt128,UInt128,UInt128,UInt128)
            Ism.addInstalledSoftware(@information)
            return UInt128.new(0),UInt128.new(0),UInt128.new(0),UInt128.new(0)
        end

        def clean
        end

    end

end
