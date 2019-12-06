#!/bin/bash
cd /usr/src/app

bundle exec rake db:create db:migrate
bundle exec pumactl -F config/puma.rb start
