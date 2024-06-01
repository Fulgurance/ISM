module ISM
  class AvailableKernel
    property name : String
    property options : Array(ISM::KernelOption)

    def initialize(@name = String.new, @options = Array(ISM::KernelOption).new)
    end
  end
end
