SoftwareInformation = { 
"Name" => "Binutils",
"Description" => "The GNU collection of binary tools",
"Website" => "https://www.gnu.org/software/binutils/",
"DownloadLinks" => ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"],
"SignatureLinks" => ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz.sig"],
"Options" => {  "Pass1" => {"Description" => "Build the first pass to make a system from scratch",
                            "Enabled" => false},
                "Pass2" => {"Description" => "Build the second pass to make a system from scratch",
                            "Enabled" => false},
            },
"Download" => download,
"Check" => check,
"Extract" => extract,
"Prepare" => prepare,
"Configure" => configure,
"Build" => build,
"Install" => install,
"Uninstall" => uninstall
                        }

def download
    `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz`
    `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig`
end

def check
    `gpg binutils-2.37.tar.xz.sig`
end

def extract
    `tar -xf binutils-2.37.tar.xz`
end

def prepare
    Dir.mkdir("build")
    Dir.cd("build")
end

def configure
    if SoftwareInformation["Options"]["Pass1"]["Enabled"] == true
        `../configure   --prefix=
                        --with-sysroot=
                        --target=
                        --disable-nls
                        --disable-werror`
    elsif SoftwareInformation["Options"]["Pass2"]["Enabled"] == true
        `../configure   --prefix=
                        --build=
                        --host=
                        --disable-nls
                        --enable-shared
                        --disable-werror
                        --enable-64-bit-bfd`
    else
        `../configure   --prefix=/usr
                        --enable-gold
                        --enable-ld=default
                        --enable-plugins
                        --enable-shared
                        --disable-werror
                        --enable-64-bit-bfd
                        --with-system-zlib`
    end
end

def build
    if SoftwareInformation["Options"]["Pass1"]["Enabled"] == true || SoftwareInformation["Options"]["Pass2"]["Enabled"] == true
        `make`
    else
        `make tooldir=/usr`
    end
end

def install
    if SoftwareInformation["Options"]["Pass1"]["Enabled"] == true
        `make -j1 install`
    elsif SoftwareInformation["Options"]["Pass2"]["Enabled"] == true
        `make DESTDIR= install -j1`
        `install -vm755 libctf/.libs/libctf.so.0.0.0 $LFS/usr/lib`
    else
        `make tooldir=/usr install -j1`
        `rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a`
    end
end

def uninstall

end