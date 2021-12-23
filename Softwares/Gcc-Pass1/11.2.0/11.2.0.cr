require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Gcc-Pass1/11.2.0/Information.json")
    end

    def download
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"],output: :inherit)
        Process.run("wget",args: ["https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz"],output: :inherit)
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"],output: :inherit)
        Process.run("wget",args: ["https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"],output: :inherit)
    end
    
    def check
    end
    
    def extract
        Process.run("tar",args: ["-xf", "../mpfr-4.1.0.tar.xz"],output: :inherit)
        Process.run("mv",args: ["-v", "mpfr-4.1.0", "mpfr"],output: :inherit)
        Process.run("tar",args: ["-xf", "../gmp-6.2.1.tar.xz"],output: :inherit)
        Process.run("mv",args: ["-v", "gmp-6.2.1", "gmp"],output: :inherit)
        Process.run("tar",args: ["-xf", "../mpc-1.2.1.tar.gz"],output: :inherit)
        Process.run("mv",args: ["-v", "mpc-1.2.1", "mpc"],output: :inherit)
    end
    
    def patch
    end

    def prepare
        `case $(uname -m) in
            x86_64)
              sed -e '/m64=/s/lib64/lib/' \
                  -i.orig gcc/config/i386/t-linux64
           ;;
        esac`
        Dir.cd("gcc-11.2.0")
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        Process.run("../configure",args: [  "--target=#{Ism.settings.target}", 
                                            "--prefix=#{Ism.settings.toolsPath}",
                                            "--with-glibc-version=2.11",
                                            "--with-sysroot=#{Ism.settings.rootPath}",
                                            "--with-newlib",
                                            "--without-headers",
                                            "--enable-initfini-array",
                                            "--disable-nls",
                                            "--disable-shared",
                                            "--disable-multilib",
                                            "--disable-decimal-float",
                                            "--disable-threads",
                                            "--disable-libatomic",
                                            "--disable-libgomp",
                                            "--disable-libquadmath",
                                            "--disable-libssp",
                                            "--disable-libvtv",
                                            "--disable-libstdcxx",
                                            "--enable-languages=c,c++"],output: :inherit)
    end
    
    def build
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        Process.run("make",args: ["#{Ism.settings.makeOptions}", "install"],output: :inherit)
        Dir.cd("..")
        Process.run("cat",args: [  "gcc/limitx.h", 
                                    "gcc/glimits.h",
                                    "gcc/limity.h",
                                    ">",
                                    "`dirname",
                                    "$(#{Ism.settings.target}-gcc",
                                    "-print-libgcc-file-name)`/install-tools/include/limits.h"],output: :inherit)
    end
    
    def uninstall
    end

end