require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils-Pass2/2.37/Information.json")
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
    
    def prepare
        super
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def patch
        super
    end

    def configure
        super
        Process.run("../configure",args: [  "--prefix=/usr", 
                                            "--build=$(../config.guess)",
                                            "--host=#{Ism.settings.target}",
                                            "--disable-nls",
                                            "--disable-werror",
                                            "--enable-64-bit-bfd"],output: :inherit)
    end
    
    def build
        super
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        super
        Process.run("make",args: [  "DESTDIR=#{Ism.settings.rootPath}",
                                    "install",
                                    "-j1"],output: :inherit)
        Process.run("install",args: ["-vm755",
                                    "libctf/.libs/libctf.so.0.0.0",
                                    "#{Ism.settings.rootPath}/usr/lib"],output: :inherit)
    end
    
    def uninstall
        super
    end

end