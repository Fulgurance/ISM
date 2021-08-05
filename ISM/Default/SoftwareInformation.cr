module ISM

    module Default

        module SoftwareInformation
  
            Name = ""
            Description = ""
            Website = ""
            DownloadLinks = Array(String).new
            SignatureLinks = Array(String).new
            ShasumLinks = Array(String).new
            Dependencies = Array(ISM::SoftwareDependency).new
            Options = Array(ISM::SoftwareOption).new
        
        end

    end
  
end
