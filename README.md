# Anise

*Dynamic Annotations for Ruby*

[![Gem Version](https://badge.fury.io/rb/anise.png)](http://badge.fury.io/rb/anise)
[![Build Status](https://secure.travis-ci.org/rubyworks/anise.png)](http://travis-ci.org/rubyworks/anise) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)

[Homepage](http://rubyworks.github.com/anise) /
[API](http://rubydoc.info/gems/anise) /
[Report Issue](http://github.com/rubyworks/anise/issues) /
[Source Code](http://github.com/rubyworks/anise)

Anise is an Annotation System for the Ruby programming language.
Unlike most other annotations systems it is not a comment-based or
macro-based system that sits over-and-above the rest of the code.
Rather, Anise is a dynamic annotations system operating at runtime.

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

RubyGems.org hosts the [gem](http://rubygems.org/gems/anise) package.
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

The [API documentation](http://rubydoc.info/gems/anise/frames) is available 
in YARD format via [rubydoc.info](a href="http://rubydoc.info").


## Support

If you experience a problem, have a question or a feature request file a ticket
with the [issue tracker](http://github.com/rubyworks/anise/issues) on GitHub.

If you would like to discuss something about this project in more detail try
contacting the author(s) via the Rubyworks [IRC channel](http://chat.us.freenode.net/rubyworks)
or the [Mailing List](http://groups.google.com/groups/rubyworks-mailinglist).


## Development

### Contributing

If you would like to contribute code or documentation to the Anise project, fork
the upstream repository and create a branch for you changes. When your changes are
ready for review (and no, they do not have to 100% perfect if you still have some
issues you need help working out) then submit a pull request.

It you need to personally discuss some ideas or issues you can try to get up with
us via the mailing list or the IRC channel.

* [IRC Channel](irc://irc.freenode.net/rubyworks) /
* [Mailing List](http://googlegroups.com/group/rubyworks-mailinglist)

### Git Repository

The [upstream git repository](http://github.com/rubyworks/anise.git) is 
hosted on [GitHub](http://github.com/rubyworks/anise).

### Development Requirements

Anise uses the following development tools.

* [qed](http://rubyworks.github.com/qed) (test development)
* [ae](http://rubyworks.github.com/ae) (test development)
* [citron](http://rubyworks.github.com/citron) (test development)
* [rubytest-cli](http://rubyworks.github.com/rubytest-cli) (test development)
* [detroit](http://rubyworks.github.com/detroit) (build development)
* [ergo](http://rubyworks.github.com/ergo) (build development)

### Test Instructions

Ainse has two test suites, one using [QED](http://rubyworks.github.com/qed) and
the other using [Citron](http://rubyworks.github.com/citron) which is built on
[RubyTest](http://rubyworks.github.com/rubytest).

To run the QED demonstrations simple run:

    $ qed

To run the Citron-based unit tests use:

    $ rubytest


## Authors

* Trans &lt;[transfire@gmail.com](mailto:transfire@gmail.com)&gt;


## Organizations

* [Rubyworks](http://rubyworks.github.com)


## Copyrights

Copyright (c) 2008 Rubyworks. All rights reserved.

This program is distributed under the terms of the
[BSD-2-Clause](http://www.spdx.org/licenses/BSD-2-Clause) license.

See LICNESE.txt file for details.

This project was created on *2008-02-21*.
