# README

### System
* Ruby version - `ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]``

* Rails version - `Rails 5.2.4.1`

### Installation

```
bundle install
rails db:migrate
```

### Run server

```
rails s
```

### Running tests locally

```
RAILS_ENV=test bundle exec rails db:migrate
bundle exec rspec
```

Note: specs are not executable on hackerrank, but Raimonds said that it is not necessary to have it green there
