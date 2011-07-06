require 'anise/variable'

Test.case Anise::Variable do

  concern "general" do

    cX = Class.new do
      include Anise::Variable

      @doc     = "See what I mean?"
      @returns = NilClass
  
      def see
        puts "Yes, I see!"
      end
    end

    test do
      cX.ann(:see, :@doc) == "See what I mean?"
    end

  end

end
