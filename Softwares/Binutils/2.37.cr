SoftwareInformation = { "Name" => "Binutils",
                        "Description" => "The GNU collection of binary tools",
                        "Website" => "https://www.gnu.org/software/binutils/",
                        "DownloadLinks" => ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"],
                        "SignatureLinks" => ["https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz.sig"],
                        "Options" => {  "Pass1" => {"Description" => "Build the first pass to make a system from scratch",
                                                    "Enabled" => false},
                                        "Pass2" => {"Description" => "Build the second pass to make a system from scratch",
                                                    "Enabled" => false},
                                    }
                        }

def download
    `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz`
    `wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.sig`
end

def checkSignature
    `gpg binutils-2.37.tar.xz.sig`
end

def extract
    `tar -xf binutils-2.37.tar.xz`
end

def configure
    if SoftwareInformation["Options"]["Pass1"]["Enabled"] == true
        `mkdir -v build && cd build`
        `../configure   --prefix=
                        --with-sysroot=
                        --target=
                        --disable-nls
                        --disable-werror`
    elsif SoftwareInformation["Options"]["Pass2"]["Enabled"] == true

    else
                
    end
end

def build
    `make`
end

def install
    `make -j1 install`
end

def uninstall

end