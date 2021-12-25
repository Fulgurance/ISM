require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/Binutils/2.37/Information.json",
                "binutils-2.37",
                "tar.xz",
                "binutils-2.37")
    end

    def prepare
        super
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        super
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
        super
        Process.run("make",args: ["tooldir=/usr", "#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        super
        Process.run("make",args: [  "tooldir=/usr", 
                                    "#{Ism.settings.makeOptions}",
                                    "install",
                                    "-j1"],output: :inherit)
        Process.run("rm",args: [  "-fv", 
                                    "/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a"],output: :inherit)
    end

end