--- 
spec_version: 1.0.0
replaces: []

loadpath: 
- lib
name: anise
repositories: {}

conflicts: []

engine_check: []

title: Anise
contact: trans <transfire@gmail.com>
resources: 
  code: http://github.com/rubyworks/anise
  mail: http://groups.google.com/group/rubyworks-mailinglist
  home: http://rubyworks.github.com/anise
maintainers: []

requires: 
- group: 
  - test
  name: qed
  version: 0+
- group: 
  - build
  name: syckle
  version: 0+
manifest: MANIFEST
version: 0.5.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2008 Thomas Sawyer
authors: 
- Thomas Sawyer
organization: Rubyworks
description: Anise is an Annotation System for the Ruby programming language. Unlike most other annotations systems it is not a comment-based or macro-based system that sits over-and-above the rest of the code. Rather, Anise is a dynamic annotations system operating at runtime.
summary: Dynamic Annotation System
created: "2008-02-21"
