# <span class="ititle">Anise</span>

<b class="isummary">A Dynamic Annotation System for Ruby</b>

[Hompage](http://rubyworks.github.com/anise) /
[Report Issue](http://github.com/rubyworks/anise/issues) /
[Source Code](http://github.com/rubyworks/anise) /
[Mailing List](http://groups.google.com/group/rubyworks-mailinglist) /
[IRC Channel](http://chat.us.freenode.new/rubyworks)

[![Build Status](https://secure.travis-ci.org/rubyworks/anise.png)](http://travis-ci.org/rubyworks/anise)


## INTRODUCTION

<p class="idescription">
Anise is an Annotation System for the Ruby programming language.
Unlike most other annotations systems it is not a comment-based or
macro-based system that sits over-and-above the rest of the code.
Rather, Anise is a dynamic annotations system operating at runtime.
</p>


## DOCUMENTATION

### Installation

To install with RubyGems simply open a console and type:

    gem install anise

To manually install you will need Setup.rb (see http://setup.rubyforge.org).
Then download the tarball package and do:

    $ tar -xvzf anise-0.2.0.tgz
    $ cd anise-0.2.0
    $ sudo setup.rb all

### Requirements

<ul>
<li class="irequirement"><a href="http://rubyworks.github.com/qed" class="name">qed</a> (<span class="groups">test</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/ae" class="name">ae</a> (<span class="groups">test</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/citron" class="name">citron</a> (<span class="groups">test</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/detroit" class="name">detroit</a> (<span class="groups">build</span>)</li>
</ul>

### Getting Started

The following example briefly demonstrates all three major features. To use
any of them first require the `anise` library.

     require 'anise'

General annotations are provided by the `Anise::Annotations` module.

    class X
      extend Anise::Annotations

      ann :grape, :class=>String
    end

    X.ann(:grape, :class)  #=> String

Annotated attributes can be easily added to a class via the `Annotative::Attributes`
module.

    class X
      extend Anise::Annotative::Attributes

      attr :baz, Integer, :max => 10
    end

    X.ann(:baz)  #=> {:class=>Integer, :max=>10}

Mewthod annotations can be had via the `AnnotatedMethods` module.

    class X
      extend Anise::Annotative::Methods

      def self.doc(string)
        method_annotation(:doc=>string)
      end

      doc "This is an entry."

      def bar
        # ...
      end
    end

    X.ann(:bar)  #=> {:doc=>"This is an entry."}

Any of these modules can be used in conjunction. Since both `AnnotatedMethods`
and `AnnotatedAttributes` preclude `Annotations` all three can be used by simply
using the later two.

     class X
       extend Anise::Annotative::Attributes
       extend Anise::Annotative::Methods

       ...
     end

Note also that the `Anise` module is clean and contains only modules and classes
with detailed names starting the "Annotat-", so it is prefectly convenient for
inclusion in the toplevel namespace or your own applications namespace.

    module MyApp
      include Anise

      class Foo
        extend Annotative::Attributes

        ...
      end
    end


## RESOURCES

<ul>
<li><a class="iresource" href="http://rubyworks.github.com/anise" name="home">Website</a></li>
<li><a class="iresource" href="http://rubygems.org/gems/anise" name="gem">Gem Page</a></li>
<li><a class="iresource" href="http://github.com/rubyworks/anise" name="code">Source Code</a> (GitHub)</li>
<li><a class="iresource" href="http://github.com/rubyworks/anise/issues" name="bugs">Issue Tracker</a> (GitHub)</li>
<li><a class="iresource" href="http://chat.us.freenode.net/rubyworks" name="chat">IRC Channel</a></li>
<li><a class="iresource" href="http://groups.google.com/groups/rubyworks-mailinglist" name="mail">Mailing List</a></li>
<li><a class="irepository" href="http://github.com/rubyworks/anise.git" name="upstream">Master Repository</a></li>
</ul>


## DEVELOPMENT

### Test Instructions

Ainse has two test suites, one using [QED](http://rubyworks.github.com/qed) and
the other using [Citron](http://rubyworks.github.com/citron) which is built on
[RubyTest](http://rubyworks.github.com/rubytest).

To run the QED demonstrations simple run:

    $ qed

To run the Citron-based unit tests use:

    $ rubytest


## AUTHORS

<ul>
<li class="iauthor vcard">
  <span class="nickname">trans</span>&lt;<a href="mailto:transfire@gmail.com" class="email">transfire@gmail.com</a>&gt;</span>
</li>
</ul>


### ORGANIZATIONS

<ul>
<li class="iorganization"><span class="name">Rubyworks</span> (<a class="website" href="http://rubyworks.github.com">http://rubyworks.github.com</a>)</li>
</ul>


## COPYRIGHTS

<div class="icopyright">
<p>Copyright (c) <span class="year">2008</span> <span class="holder">Rubyworks</span>. All rights reserved.</p>

<p>This program is distributed under the terms of the <a href="http://www.spdx.org/licenses/BSD-2-Clause" class="license">BSD-2-Clause</a> license.</p>
</div>

This project was created on <p class="icreated">2008-02-21</p>.

See LICNESE.txt file for details.

