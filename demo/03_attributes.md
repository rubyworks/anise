# Annotated Attributes

Create a class that uses the `AnnotatedAttributes` module.

    class X
      extend Anise::AnnotatedAttributes

      attr :a, :count => 1
    end

Then we can see tht the attribute method `:a` has an annotation entry.

    X.ann(:a, :count) #=> 1

