= TOPLEVEL Annotated Attributes

Including `AnnotatedAttributes` at the toplevel, i.e. Object, will make
annotated attributes univerally available.

  class ::Object
    extend Anise::Annotative::Attributes
  end

Create a class that uses it.

  class X
    attr :a, :count=>1
  end

  X.ann(:a, :count) #=> 1

Alternatively the `Annotative::Attributes` module could be included into
the `Module` class.

