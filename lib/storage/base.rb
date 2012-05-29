module Storage
  class Base
    attr_accessor :params

    def initialize(params)
      @params = params
    end
  end
end
