Settings = {"RootPath" => "/",
            "ToolsPath" => "/tools",
            "SystemName" => "LFS",
            "TargetName" => "lfs",
            "Target" => "x86_64-#{Settings["TargetName"]}-linux-gnu",
            "MakeOptions" => "-j1",
            "BuildOptions" => "-march=native -O2 -pipe",
            "LC_ALL" => "POSIX"}