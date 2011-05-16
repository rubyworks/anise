--- !ruby/object:Gem::Specification 
name: anise
version: !ruby/object:Gem::Version 
  hash: 11
  prerelease: false
  segments: 
  - 0
  - 5
  - 0
  version: 0.5.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-05-16 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: qed
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: redline
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id002
description: Anise is an Annotation System for the Ruby programming language. Unlike most other annotations systems it is not a comment-based or macro-based system that sits over-and-above the rest of the code. Rather, Anise is a dynamic annotations system operating at runtime.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- lib/anise/annotation.rb
- lib/anise/annotator.rb
- lib/anise/attribute.rb
- lib/anise/module.rb
- lib/anise.rb
- lib/anise.yml
- qed/01_annotations.qed
- qed/02_annotation_added.rdoc
- qed/03_attributes.rdoc
- qed/04_annotator.rdoc
- qed/applique/ae.rb
- qed/toplevel/01_annotations.qed
- qed/toplevel/03_attributes.rdoc
- test/suite.rb
- test/test_anise.rb
- test/test_anise_toplevel.rb
- test/test_annotations.rb
- test/test_annotations_module.rb
- test/test_annotations_toplevel.rb
- test/test_annotator.rb
- test/test_annotator_toplevel.rb
- test/test_attribute.rb
- test/test_attribute_toplevel.rb
- HISTORY.rdoc
- README.rdoc
- COPYING.rdoc
- APACHE2.txt
has_rdoc: true
homepage: http://rubyworks.github.com/anise
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- Anise API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: anise
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Dynamic Annotation System
test_files: []

