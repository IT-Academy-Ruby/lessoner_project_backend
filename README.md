# Lessoner

An app for tutorial lessons site.

Used stack: Ruby on Rails, Postgresql, JQuery, CSS Bootstrap.

## Local development
### Prerequisites. Required software
You need to have installed in your system:
* RVM
* Ruby 3.1.2
* Postgres 14.5
* NodeJS

#### RVM installation
Install RVM from https://rvm.io/

#### Ruby installation
To install ruby run a command

```
rvm install "ruby-3.1.2"
```

Then select installed version of ruby 

```
rvm use 3.1.2
```

#### Postgres installation
Visit https://www.postgresql.org/download/ and download Postgres 14.5
Run `rails db:setup` to initialize the databases

#### NodeJS installation
Visit https://nodejs.org/ . Download and install the latest version.

### Project setup
Navigate the project folder and run

```
bundle install
```

Start the postgresql service. For instance, in Linux:

```
sudo service postgresql start
```

Initialize project database settings:

```
rails db:setup
```

### Run server

To run server: 

```
rails server
```

### Run Rubocop linter

```
rubocop --require rubocop-rails
```

### Updating swagger

Link to the swagger: `/api-docs`, e.g. `http://127.0.0.1:3000/api-docs/index.html`

Spec files for generating swagger are located in the `/spec/requests` folder. To add new one choose a controller (e.g. `categories`) and run:

```
rails generate rspec:swagger categories
```
it will create `/spec/requests/categories.spec.rb` file. Edit it according to the API to be used. See [documentation of rswag gem](https://github.com/rswag/rswag) for details.

Data types can be also pick up [here](https://swagger.io/docs/specification/data-models/data-types/)

For updating API docs run (*it is not necessary to restart rails server*)

```
rails rswag
```
