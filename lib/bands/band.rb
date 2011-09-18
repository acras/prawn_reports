module PrawnReport

  class Band
    
    attr_accessor :height, :report
    
    def initialize(report, params = {})
      @report = report
    end
    
    def draw
      internal_draw
    end

    def internal_draw; end
      
    def self.height
      20
    end
    
  end
  
end
