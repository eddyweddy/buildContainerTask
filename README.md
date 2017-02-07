# buildContainerTask

Write a cookbook to create a web app that utilizes these tools 

* Test kitchen -- makes it easier to test
* Berks -- manages chef cookbooks used
* Ruby 2.3.1 -- recipes written in ruby
* bundler -- gem manager
* chef -- test kitchen uses chef
* Docker -- everything goes into a docker container


Assumes a working docker, chefdk and ruby install on your working platform.
Change the .ruby-version and .ruby-gemset files if v2.3.1 is not available or you don't want to use a separate gemset.
Use bundler to get dependant gems. A small change had to be done to the provided config.ru file

## To start
```
1) Run bundler
2) run kitchen converge
3) Docker container forwards port 80 to the host. You should be able to connect using any browser to view the app output
```

## To Test

### Integration tests
After a successful 'kitchen converge', integration tests can be run using 'kitchen verify'