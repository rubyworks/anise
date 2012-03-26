= TOPLEVEL Annotations

Extending Object with `Annotations` should make them available to all classes.

  class ::Object
    extend Anise::Annotations
  end

Given a example class X we can apply annotations to it using the #ann method. 

  class X
    ann :x1, :a=>1
    ann :x1, :b=>2
  end

We can then use #ann to lookup the set annotations.

   X.ann(:x1,:a).should == 1

The #ann method is a public interface, so we can define annotation externally as well.

   X.ann :x1, :a => 2
   X.ann(:x1, :a).should == 2

Alternatively the `Annotations` module could be included into the `Module` class.

