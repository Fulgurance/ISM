require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils-Pass2/2.37/Information.json")
    end

    def download
        `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz`
        `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig`
    end
    
    def check
        `gpg binutils-2.37.tar.xz.sig`
    end
    
    def extract
        `tar -xf binutils-2.37.tar.xz`
    end
    
    def prepare
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def patch
    end

    def configure
        `../configure   --prefix=/usr \
                        --build=$(../config.guess) \
                        --host=#{Ism.settings.target} \
                        --disable-nls \
                        --enable-shared \
                        --disable-werror \
                        --enable-64-bit-bfd`
    end
    
    def build
        `make #{Ism.settings.makeOptions}`
    end
    
    def install
        `make DESTDIR=#{Ism.settings.rootPath} install -j1`
        `install -vm755 libctf/.libs/libctf.so.0.0.0 #{Ism.settings.rootPath}/usr/lib`
    end
    
    def uninstall
    end

end