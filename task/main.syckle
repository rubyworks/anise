---
gem:
  service: Gem
  active : true

dnote:
  service  : DNote
  loadpath : ~
  labels   : ~
  output   : ~
  format   : ~
  active   : true

stats:
  service  : Stats
  title    : ~
  loadpath : ~
  exclude  : ~
  output   : ~
  active   : true

rdoc:
  service : rdoc
  format  : newfish  #hanna
  exclude : [VERSION]
  output  : site/docs/api

ridoc:
  service: RIDoc
  include: ~
  exclude: ~
  output : .ri
  active : true

qedoc:
  service: custom
  cycle: site
  document: |
    puts `qedoc -o site/docs/qed -t "Anise Demonstrandum" qed`

testrb:
  service  : testrb
  tests    : ~
  exclude  : ~
  loadpath : ~
  requires : ~
  live     : false   
  active   : false

grancher:
  service: Grancher
  active: true
  #sitemap:
  #  - site
  #  - [doc/rdoc, rdoc]
  #  - [doc/qedoc, qedoc]

gemcutter:
  active: true

email:
  service : Email
  file    : ~
  subject : ~
  mailto  : ruby-talk@ruby-lang.org
  active  : true

#  from    : transfire@gmail.com
#  server  : <%= ENV['EMAIL_SERVER'] %>
#  port    : <%= ENV['EMAIL_PORT'] %>
#  account : <%= ENV['EMAIL_ACCOUNT'] %>
#  domain  : <%= ENV['EMAIL_DOMAIN'] %>
#  login   : <%= ENV['EMAIL_LOGIN'] %>
#  secure  : <%= ENV['EMAIL_SECURE'] %>

#  from    : admin@tigerops.org
#  server  : mail.tigerops.org
#  port    : 25
#  domain  : tigerops.org
#  account : admin@tigerops.org
#  secure  : false
#  login   : login

#vclog:
#  service  : VClog
#  format   : html   # xml, txt
#  layout   : rel    # gnu
#  typed    : false
#  output   : ~
#  active   : false

#rubyforge:
#  service  : Rubyforge
#  unixname : anise
#  groupid  : 7160
#  active   : false

