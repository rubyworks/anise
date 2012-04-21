# Annotative Attributes

Create a class that uses the `Annotative::Attributes` mixin.

    class X
      extend Anise::Annotative::Attributes

      attr :a, :count => 1
    end

Then we can see tht the attribute method `:a` has an annotation entry.

    X.ann(:a, :count) #=> 1

