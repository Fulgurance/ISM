require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils/2.37/Information.json")
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
    
    def patch
    end

    def prepare
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        `../configure   --prefix=/usr \
                        --enable-gold \
                        --enable-ld=default \
                        --enable-plugins \
                        --enable-shared \
                        --disable-werror \
                        --enable-64-bit-bfd \
                        --with-system-zlib`
    end
    
    def build
        `make tooldir=/usr`
    end
    
    def install
        `make tooldir=/usr install -j1`
        `rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a`
    end
    
    def uninstall
    end

end