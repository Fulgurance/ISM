require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/Linux-API-Headers/5.13.12/Information.json",
                "linux-5.13.12")
    end
    
    def configure
        super
        Process.run("make",args: [Ism.settings.makeOptions, "mrproper"],output: :inherit)
    end
    
    def build
        super
        Process.run("make",args: [Ism.settings.makeOptions, "headers"],output: :inherit)
    end
    
    def install
        super
        Process.run("find",args: ["usr/include","-name", "'.*'", "-delete"],output: :inherit)
        Process.run("rm",args: ["usr/include/Makefile"],output: :inherit)
        Process.run("cp",args: ["-rv","usr/include", "#{Ism.settings.rootPath}"],output: :inherit)
    end

end