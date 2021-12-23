require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils-Pass2/2.37/Information.json")
    end

    def download
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"],output: :inherit)
        #Process.run("wget",args: ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig"],output: :inherit)
    end
    
    def check
        #Process.run("gpg",args: ["binutils-2.37.tar.xz.sig"],output: :inherit)
    end
    
    def extract
        Process.run("tar",args: ["-xf", "binutils-2.37.tar.xz"],output: :inherit)
    end
    
    def prepare
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def patch
    end

    def configure
        Process.run("../configure",args: [  "--prefix=/usr", 
                                            "--build=$(../config.guess)",
                                            "--host=#{Ism.settings.target}",
                                            "--disable-nls",
                                            "--disable-werror",
                                            "--enable-64-bit-bfd"],output: :inherit)
    end
    
    def build
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        Process.run("make",args: [  "DESTDIR=#{Ism.settings.rootPath}",
                                    "install",
                                    "-j1"],output: :inherit)
        Process.run("install",args: ["-vm755",
                                    "libctf/.libs/libctf.so.0.0.0",
                                    "#{Ism.settings.rootPath}/usr/lib"],output: :inherit)
    end
    
    def uninstall
    end

end