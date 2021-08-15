Settings = {"RootPath" => "/",
            "ToolsPath" => "/tools",
            "SystemName" => "LFS",
            "TargetName" => "lfs",
            "Architecture" => "x86_64",
            "Target" => "#{Settings["Architecture"]}-#{Settings["TargetName"]}-linux-gnu",
            "MakeOptions" => "-j1",
            "BuildOptions" => "-march=native -O2 -pipe"}