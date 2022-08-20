#### Local development
You need to have installed in your system:
* Ruby 3.1.2
* Postgres 14.5

##### Ruby installation
To install ruby run a command `rvm install "ruby-3.1.2"`

Then select installed version of ruby `rvm use 3.1.2`

Run `bundle install`
##### Postgres installation
Visit https://www.postgresql.org/download/ and download Postgres 14.5
Run `rails db:setup` to initialize the databases

##### Run server
To run server use `rails server`
