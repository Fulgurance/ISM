require "colorize"
require "json"
require "../../../ISM/Default/SoftwareOption"
require "../../../ISM/SoftwareOption"
require "../../../ISM/Default/SoftwareDependency"
require "../../../ISM/SoftwareDependency"
require "../../../ISM/Default/SoftwareInformation"
require "../../../ISM/SoftwareInformation"
require "../../../ISM/Default/Software"
require "../../../ISM/Software"

class Target < ISM::Software

    def initialize
        super
        information = Information.from_json(File.read("Information.json"))

        @information.name = information.name
        @information.architectures = information.architectures
        @information.description = information.description
        @information.website = information.website
        @information.downloadLinks = information.downloadLinks
        @information.signatureLinks = information.signatureLinks
        @information.shasumLinks = information.shasumLinks

        information.dependencies.each do |data|
            dependency = ISM::SoftwareDependency.new
            dependency.name = data.name
            dependency.version = data.version
            data.options.each do |entry|
                option = ISM::SoftwareOption.new
                option.name = entry.name
                option.description = entry.description
                option.active = entry.active
                dependency.options.push(option)
            end
            @information.dependencies.push(dependency)
        end
        
        information.options.each do |data|
            option = ISM::SoftwareOption.new
            option.name = data.name
            option.description = data.description
            @information.options.push(option)
        end
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
        if @information.options[0].active == true
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
        if @information.options[0] || @information.options[1]
            `make`
        else
            `make tooldir=/usr`
        end
    end
    
    def install
        super
        if @information.options[0] == true
            `make -j1 install`
        elsif @information.options[1] == true
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
            @information.options[0] = true
            @information.options[1] = false
        elsif option == option2.name
            @information.options[1] = true
            @information.options[0] = false
        else
            @information.options.each_with_index do |data, index|
                if data.name = option
                    @information.options[index] = true
                    break
                end
            end
        end
    end
    
    def disableOption(option)
        super
        @information.options.each_with_index do |data, index|
            if data.name = option
                @information.options[index] = false
                break
            end
        end
    end

end

target = Target.new