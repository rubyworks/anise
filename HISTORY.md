# RELEASE HISTORY

## 0.7.0 / 2012-03-26

This release has some major API changes. Most significantly a number
of modules have been renamed. The `Method` module has been renamed to
`Annotative::Methods`. Likewise the `Attribute` module has been ranamed
to `Annotative::Attributes`, and so on. These have been renamed so that
including `Anise` in the toplevel will not cause conflicts with any
other modules or classes an application or library might be using.
In addition these modules now must use `extend` rather then `include`
to be mixed into a class or module, since they conatin only class methods.

Changes:

* Rename Annotations module to Annotations::Store.
* Rename Annotation module to Annotations.
* Rename Method module to Annotative::Methods.
* Rename Attribute module to Annotative::Attributes.
* Add #method_annotation for use in custom class method.
* Discourage #method_annotator in favor of #method_annotation.


## 0.6.0 / 2011-05-16

This release fixes an bug in which append_features cant be called b/c
it is a private method. This release also renames `ClassMethods`
modules to `Aid`.

Changes:

* Fixed private method call to #append_features.
* Rename ClassMethods to Aid.


## 0.5.0 / 2011-04-30

The primary changes in this release are behind the scenes implementation
improvements. The most significant of which is the simplification of
the #append_features code. In addition, annotators have been enhanced
to assign a single argument if one, and an array of arguments if there
are more than one. They can also override the callback altogether.

Changes:

* Simplified #append_features code.
* Use ClassMethod submodules.
* Annotators differentiate one vs. multiple arguments.
* Annotators can override method_added callback.


## 0.4.0 / 2009-05-28

This version adds a callback method called #annotation_added
--a striaght-forward callback method patterned after Ruby's 
other built-in callback methods. The callback should be enough
to allow for the creation of "active" annotations.

Changes:

* Added annotation_added callback.


## 0.2.1 / 2008-10-31

Project reorganization release --mostly some file names have changed.

Changes:

* Renamed some lib files.


## 0.2.0 / 2008-10-28

By making Annotations a module, it can not be used in only the clases
it is needed.

Changes:

* Annotations is a module rather than a core extenstion to Module.


## 0.1.1 / 2008-10-17

Ahoy, mate! This is the first release of Anise.

Changes:

* initial release

