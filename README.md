# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Environment setup instructions
    System should require rails server , sidekiq, redis, postgres, all these should run parallely. Follow the below Instruction to make everything setup and run 

* System dependencies
    Ubuntu OS

* Install Ruby 3.3.1 using rbenv
    sudo apt update
    sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    rbenv install 3.3.1
    rbenv global 3.3.1

    Reference: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-22-04

* Install Rails 7.1.3.4
    echo "gem: --no-document" > ~/.gemrc
    gem install bundler
    gem install rails -v 7.1.3.4

* Install psql (PostgreSQL) 16.1
    sudo apt install postgresql postgresql-contrib

    ReferenceL: https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart

    Refer /user-genius/config/database.yml file for necessary credential

* Install Redis server v=7.2.5
    sudo apt install redis-server
    sudo systemctl enable redis-server.service
    sudo systemctl start redis-server

* Configuration and execution
    do 'bundle install' from the app root folder
    rails db:create
    rails db:migrate
    rails server

    * start redis:
    sudo systemctl start redis-server

    * start sidekiq:
    bundle exec sidekiq

* How to run the test suite
    do 'rspec' from the app root folder

* credential to access the sidekiq UI
    username: admin
    password: admin