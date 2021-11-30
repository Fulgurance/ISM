class Binutils < Software

    def initialize
        super
        @name = "Binutils"
        @architectures = ["x86_64"]
        @description = "The GNU collection of binary tools"
        @website = "https://www.gnu.org/software/binutils/"
        @downloadLinks = ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"]
        @signatureLinks = ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz.sig"]

        option1 = ISM::SoftwareOption.new
        option1.name = "Pass1"
        option1.description = "Build the first pass to make a system from scratch"

        option2 = ISM::SoftwareOption.new
        option2.name = "Pass2"
        option2.description = "Build the second pass to make a system from scratch"

        @options = [option1, option2]
    end

    def download
        super
        `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz`
        `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig`
    end
    
    def check
        super
        `gpg binutils-2.37.tar.xz.sig`
    end
    
    def extract
        super
        `tar -xf binutils-2.37.tar.xz`
    end
    
    def prepare
        super
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        super
        if @options[0].active == true
            `../configure   --prefix=#{ism.settings.toolsPath}
                            --with-sysroot=#{ism.settings.rootPath}
                            --target=#{ism.settings.target}
                            --disable-nls
                            --disable-werror`
        elsif @options[1] == true
            `../configure   --prefix=/usr
                            --build=$(../config.guess)
                            --host=#{ism.settings.target}
                            --disable-nls
                            --enable-shared
                            --disable-werror
                            --enable-64-bit-bfd`
        else
            `../configure   --prefix=/usr
                            --enable-gold
                            --enable-ld=default
                            --enable-plugins
                            --enable-shared
                            --disable-werror
                            --enable-64-bit-bfd
                            --with-system-zlib`
        end
    end
    
    def build
        super
        if @options[0] || @options[1] == true
            `make`
        else
            `make tooldir=/usr`
        end
    end
    
    def install
        super
        if @options[0] == true
            `make -j1 install`
        elsif @options[1] == true
            `make DESTDIR=#{ism.settings.rootPath} install -j1`
            `install -vm755 libctf/.libs/libctf.so.0.0.0 #{ism.settings.rootPath}/usr/lib`
        else
            `make tooldir=/usr install -j1`
            `rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a`
        end
    end
    
    def uninstall
        super
    end
    
    def enableOption(option)
        super
        if option == option1.name
            @options[0] = true
            @options[1] = false
        elsif option == option2.name
            @options[1] = true
            @options[0] = false
        else
            @options.each_with_index do |data, index|
                if data.name = option
                    @options[index] = true
                    break
                end
            end
        end
    end
    
    def disableOption(option)
        super
        @options.each_with_index do |data, index|
            if data.name = option
                @options[index] = false
                break
            end
        end
    end

end