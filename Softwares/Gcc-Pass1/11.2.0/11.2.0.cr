require "../../SoftwaresLibrairies"

class Target < ISM::Software

    def initialize
        super(  "./Softwares/Gcc-Pass1/11.2.0/Information.json",
                "gcc-11.2.0",
                "tar.xz",
                "gcc-11.2.0")
    end
    
    def download
        super
        Process.run("curl",args: ["-O","https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz"],output: :inherit)
        Process.run("curl",args: ["-O","https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"],output: :inherit)
        Process.run("curl",args: ["-O","https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz"],output: :inherit)
    end

    def prepare
        super
        Dir.cd(Ism.settings.sourcesPath+@information.versionName)

        FileUtils.mv("mpfr-4.1.0.tar.xz", @mainSourceDirectoryName)
        FileUtils.mv("gmp-6.2.1.tar.xz", @mainSourceDirectoryName)
        FileUtils.mv("mpc-1.2.1.tar.gz", @mainSourceDirectoryName)

        Dir.cd(@mainSourceDirectoryName)

        Process.run("tar",args: ["-xf", "mpfr-4.1.0.tar.xz"],output: :inherit)
        Process.run("tar",args: ["-xf", "gmp-6.2.1.tar.xz"],output: :inherit)
        Process.run("tar",args: ["-xf", "mpc-1.2.1.tar.gz"],output: :inherit)

        FileUtils.mv("mpfr-4.1.0", "mpfr")
        FileUtils.mv("gmp-6.2.1", "gmp")
        FileUtils.mv("mpc-1.2.1", "mpc")
        FileUtils.mv("mpfr", @mainSourceDirectoryName)
        FileUtils.mv("mpfr", @mainSourceDirectoryName)
        FileUtils.mv("mpfr", @mainSourceDirectoryName)

        `case $(uname -m) in
            x86_64)
              sed -e '/m64=/s/lib64/lib/' \
                  -i.orig gcc/config/i386/t-linux64
           ;;
        esac`

        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        super
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
        super
        Process.run("make",args: ["#{Ism.settings.makeOptions}"],output: :inherit)
    end
    
    def install
        super
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

end