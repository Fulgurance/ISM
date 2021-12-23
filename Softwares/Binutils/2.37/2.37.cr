require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Binutils/2.37/Information.json")
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
    
    def patch
    end

    def prepare
        Dir.cd("binutils-2.37")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        Process.run("../configure",args: [  "--prefix=/usr", 
                                            "--enable-gold",
                                            "--enable-ld=default",
                                            "--enable-plugins",
                                            "--enable-shared",
                                            "--disable-werror",
                                            "--enable-64-bit-bfd",
                                            "--with-system-zlib"],output: :inherit)
    end
    
    def build
        Process.run("make",args: ["tooldir=/usr", "#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        Process.run("make",args: [  "tooldir=/usr", 
                                    "#{Ism.settings.makeOptions}",
                                    "install",
                                    "-j1"],output: :inherit)
        Process.run("rm",args: [  "-fv", 
                                    "/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a"],output: :inherit)
    end
    
    def uninstall
    end

end