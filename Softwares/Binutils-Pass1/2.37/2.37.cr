require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils-Pass1/2.37/Information.json")
    end

    def download
        super
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"],output: :inherit)
        #Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig"],output: :inherit)
    end
    
    def check
        super
        #Process.run("gpg",args: ["binutils-2.37.tar.xz.sig"],output: :inherit)
    end
    
    def extract
        super
        Process.run("tar",args: ["-xf", "binutils-2.37.tar.xz"],output: :inherit)
    end
    
    def patch
        super
    end

    def prepare
        super
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        super
        Process.run("../configure",args: [  "--prefix=#{Ism.settings.toolsPath}", 
                                            "--with-sysroot=#{Ism.settings.rootPath}",
                                            "--target=#{Ism.settings.target}",
                                            "--disable-nls",
                                            "--disable-werror"],output: :inherit)
    end
    
    def build
        super
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        super
        Process.run("make",args: ["-j1","install"],output: :inherit)
        `make -j1 install`
    end
    
    def uninstall
        super
    end

end