# <span class="ititle">Anise</span>

<i class="isummary">Dynamic Annotations for Ruby</i>

<a class="iresource" href="http://rubyworks.github.com/anise" name="home">Homepage</a> /
[Report Issue](http://github.com/rubyworks/anise/issues) /
[Mailing List](http://groups.google.com/group/rubyworks-mailinglist) /
[IRC Channel](http://chat.us.freenode.new/rubyworks) /
[Source Code](http://github.com/rubyworks/anise) : :
[![Build Status](https://secure.travis-ci.org/rubyworks/anise.png)](http://travis-ci.org/rubyworks/anise)

-----

<p class="idescription">
Anise is an Annotation System for the Ruby programming language.
Unlike most other annotations systems it is not a comment-based or
macro-based system that sits over-and-above the rest of the code.
Rather, Anise is a dynamic annotations system operating at runtime.
</p>

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

Mewthod annotations can be had via the `Annotative::Methods` module.

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

Any of these modules can be used in conjunction. Since both `Annotative::dMethods`
and `Annotative::Attributes` preclude `Annotations` all three can be used by simply
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


## Installation

### RubyGems

RubyGems.org hosts the <a class="iresource" href="http://rubygems.org/gems/anise" name="gem">gem</a> package.
To install via RubyGems simply open a console and type:

    gem install anise

### Setup.rb (not recommended)

To manually install you will need Setup.rb (see http://setup.rubyforge.org).
Then download the tarball package and do:

    $ tar -xvzf anise-0.2.0.tgz
    $ cd anise-0.2.0
    $ sudo setup.rb all


## Documentation

### Demonstrations

Fully tested demonstrations can be seen in the DEMO document.

### API Reference

The <a class="iresource" href="http://rubydoc.info/gems/anise/frames" name="home">API documentation</a> is available 
in YARD format via <a href="http://rubydoc.info">rubydoc.info</a>.


## Support

If you experience a problem, have a question or a feature request file a ticket with the 
<a class="iresource" href="http://github.com/rubyworks/anise/issues" name="bugs">issue tracker</a> on GitHub.

If you would like to discuss something about this project in more detail try contacting the author(s) via
the Rubyworks <a class="iresource" href="http://chat.us.freenode.net/rubyworks" name="chat">IRC channel</a>
or the <a class="iresource" href="http://groups.google.com/groups/rubyworks-mailinglist" name="mail">Mailing List</a>.


## Development

### Git Repository

The <a class="irepo" href="http://github.com/rubyworks/anise.git" name="upstream">upstream git repository</a> is 
hosted on <a class="iresource" href="http://github.com/rubyworks/anise" name="code">Github</a>.


### Development Requirements

Anise uses the following development tools.

<ul>
<li class="irequirement"><a href="http://rubyworks.github.com/qed" class="name">qed</a> (<span class="groups">test development</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/ae" class="name">ae</a> (<span class="groups">test development</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/citron" class="name">citron</a> (<span class="groups">test development</span>)</li>
<li class="irequirement"><a href="http://rubyworks.github.com/detroit" class="name">detroit</a> (<span class="groups">build development</span>)</li>
</ul>

### Test Instructions

Ainse has two test suites, one using [QED](http://rubyworks.github.com/qed) and
the other using [Citron](http://rubyworks.github.com/citron) which is built on
[RubyTest](http://rubyworks.github.com/rubytest).

To run the QED demonstrations simple run:

    $ qed

To run the Citron-based unit tests use:

    $ rubytest


## Authors

<ul>
<li class="iauthor vcard">
  <span class="nickname">Trans</span> &lt;<a href="mailto:transfire@gmail.com" class="email">transfire@gmail.com</a>&gt;</span>
</li>
</ul>


## Organizations

<ul>
<li class="iorg"><span class="name">Rubyworks</span> (<a class="website" href="http://rubyworks.github.com">http://rubyworks.github.com</a>)</li>
</ul>


## Copyrights

<div class="icopyright">
<p>Copyright (c) <span class="year">2008</span> <span class="holder">Rubyworks</span>. All rights reserved.</p>

<p>This program is distributed under the terms of the <a href="http://www.spdx.org/licenses/BSD-2-Clause" class="license">BSD-2-Clause</a> license.</p>
</div>

See LICNESE.txt file for details.

This project was created on <i class="icreated">2008-02-21</i>.


