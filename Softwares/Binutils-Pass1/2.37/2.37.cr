require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils-Pass1/2.37/Information.json")
    end

    def download
        Ism.notifyOfDownload(@information)
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"],output: :inherit)
        #Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig"],output: :inherit)
    end
    
    def check
        Ism.notifyOfCheck(@information)
        #Process.run("gpg",args: ["binutils-2.37.tar.xz.sig"],output: :inherit)
    end
    
    def extract
        Ism.notifyOfExtract(@information)
        Process.run("tar",args: ["-xf", "binutils-2.37.tar.xz"],output: :inherit)
    end
    
    def patch
        Ism.notifyOfPatch(@information)
    end

    def prepare
        Ism.notifyOfPrepare(@information)
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        Ism.notifyOfConfigure(@information)
        Process.run("../configure",args: [  "--prefix=#{Ism.settings.toolsPath}", 
                                            "--with-sysroot=#{Ism.settings.rootPath}",
                                            "--target=#{Ism.settings.target}",
                                            "--disable-nls",
                                            "--disable-werror"],output: :inherit)
    end
    
    def build
        Ism.notifyOfBuild(@information)
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        Ism.notifyOfInstall(@information)
        Process.run("make",args: ["-j1","install"],output: :inherit)
        `make -j1 install`
    end
    
    def uninstall
    end

end