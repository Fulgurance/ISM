require "colorize"
require "json"
require "../../../ISM/Default/SoftwareOption"
require "../../../ISM/SoftwareOption"
require "../../../ISM/Default/SoftwareDependency"
require "../../../ISM/SoftwareDependency"
require "../../../ISM/Default/SoftwareInformation"
require "../../../ISM/SoftwareInformation"
require "../../../ISM/Default/Software"
require "../../../ISM/Software"

class Target < ISM::Software

    def initialize
        super
        @information.loadInformationFile("./Softwares/Gcc-Pass1/11.2.0/Information.json")
    end

    def download
        `wget https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz`
        `wget https://www.mpfr.org/mpfr-4.1.0/mpfr-4.1.0.tar.xz`
        `wget https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz`
        `wget https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz`
    end
    
    def check
    end
    
    def extract
        `tar -xf ../mpfr-4.1.0.tar.xz`
        `mv -v mpfr-4.1.0 mpfr`
        `tar -xf ../gmp-6.2.1.tar.xz`
        `mv -v gmp-6.2.1 gmp`
        `tar -xf ../mpc-1.2.1.tar.gz`
        `mv -v mpc-1.2.1 mpc`
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
        Dir.mkdir("build")
        Dir.cd("build")
    end
    
    def configure
        `../configure   --prefix=#{Ism.settings.toolsPath}
                        --with-sysroot=#{Ism.settings.rootPath}
                        --target=#{Ism.settings.target}
                        --disable-nls
                        --disable-werror`

        `../configure   --target=#{Ism.settings.target}                             
                        --prefix=#{Ism.settings.toolsPath}                           
                        --with-glibc-version=2.11                      
                        --with-sysroot=#{Ism.settings.rootPath}                           
                        --with-newlib                                  
                        --without-headers                              
                        --enable-initfini-array                        
                        --disable-nls                                  
                        --disable-shared                               
                        --disable-multilib                             
                        --disable-decimal-float                        
                        --disable-threads                              
                        --disable-libatomic                            
                        --disable-libgomp                              
                        --disable-libquadmath                          
                        --disable-libssp                               
                        --disable-libvtv                               
                        --disable-libstdcxx                            
                        --enable-languages=c,c++`
    end
    
    def build
        `make #{Ism.settings.makeOptions}`
    end
    
    def install
        `make #{Ism.settings.makeOptions} install`
        Dir.cd("build")
        `cat gcc/limitx.h gcc/glimits.h gcc/limity.h >
        \`dirname $(#{Ism.settings.target} -print-libgcc-file-name)\`/install-tools/include/limits.h`
    end
    
    def uninstall
    end

end