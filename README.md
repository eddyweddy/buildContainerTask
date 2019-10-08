# buildContainerTask

Uses Chef, Chef Kitchen and chef cookbook to create a docker nginx that contains a sample web app 

Tools used and why
* Test kitchen -- makes it easier to test, repeatable unit and integration tests
* Berks -- manages chef cookbooks used
* Ruby 2.6.3 -- recipes written in ruby
* bundler -- gem manager
* chef -- test kitchen uses chef
* Docker -- everything goes into a docker container


Assumes a working docker, chefdk and ruby install on your working platform, preferably a flavour of Linux.
To guarantee iptables on the container works, ensure iptables or ufw is enabled on the host.
Change the .ruby-version and .ruby-gemset files if v2.6.3 is not available or you don't want to use a separate gemset.
Use bundler to get dependant gems. A small change had to be done to the provided config.ru file
## Pre-requirements
Ensure you have a working ruby or install one.
I use RVM to manage my rubies eg :
```
curl -sSL https://get.rvm.io | bash -s stable --ruby
```
Source rvm extensions into your environment
```
source ~/.rvm/scripts/rvm
```
## To start
```
1) Run bundler
2) run kitchen converge
3) Docker container forwards port 80 to the host. You should be able to connect using any browser to view the app output
```

## To Test
### Unit tests
From command line run :
bundle exec rspec ./spec/unit/recipes/default_spec.rb
### Integration tests
After a successful 'kitchen converge', integration tests can be run using 'kitchen verify'