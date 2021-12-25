require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super("./Softwares/Binutils-Pass2/2.37/Information.json")
    end
    
    def prepare
        super
        Dir.mkdir("build")
        Dir.cd("build")
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

end