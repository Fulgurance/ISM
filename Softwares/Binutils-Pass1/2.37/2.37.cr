require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super("./Softwares/Binutils-Pass1/2.37/Information.json")
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

end