--- !ruby/object:Gem::Specification 
name: anise
version: !ruby/object:Gem::Version 
  hash: 15
  prerelease: false
  segments: 
  - 0
  - 4
  - 0
  version: 0.4.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2010-12-06 00:00:00 -05:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: syckle
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
  name: qed
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
description: |-
  Anise is a runtime-baded annotations systems for the Ruby
    programming lanaguage.
email: transfire@gmail.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- lib/anise/annotation.rb
- lib/anise/annotator.rb
- lib/anise/attribute.rb
- lib/anise.rb
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
- TODO
- README.rdoc
has_rdoc: true
homepage: ""
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- Anise API
- --main
- README.rdoc
require_paths: []

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
summary: Dynamic Annotations System
test_files: 
- test/test_anise.rb
- test/test_anise_toplevel.rb
- test/test_annotations.rb
- test/test_annotations_module.rb
- test/test_annotations_toplevel.rb
- test/test_annotator.rb
- test/test_annotator_toplevel.rb
- test/test_attribute.rb
- test/test_attribute_toplevel.rb
