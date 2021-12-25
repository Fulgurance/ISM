require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/Libstdc++-Pass1/11.2.0/Information.json",
                "gcc-11.2.0")
    end
    
    def prepare
        super
        Dir.mkdir("build")
        Dir.cd("build")
    end

    def configure
        super
        Process.run("../libstdc++-v3/configure",args: [ "--host=#{Ism.settings.target}", 
                                                        "-build=$(../config.guess)",
                                                        "-prefix=/usr",
                                                        "--disable-multilib",
                                                        "--disable-nls",
                                                        "--disable-libstdcxx-pch",
                                                        "--with-gxx-include-dir=/tools/#{Ism.settings.target}/include/c++/11.2.0"],output: :inherit)
    end
    
    def build
        super
        Process.run("make",args: [Ism.settings.makeOptions],output: :inherit)
    end
    
    def install
        super
        Process.run("make",args: [Ism.settings.makeOptions,"DESTDIR=#{Ism.settings.rootPath}","install"],output: :inherit)
    end

end