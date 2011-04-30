module Anise

  #$annotations[self][:foo][:doc] = "foo is cool"

  ann(ref, name=nil)
    if name
      $annotations[self][ref][name]
    else
      $annotations[self][ref]
    end
  end

end
