#!/bin/sh

set -e

# manually execute hipster:update
# RAILS_ENV=production bundle exec rake hipster:update
git checkout master
git pull
./bin/bundle --deployment --without development test
RAILS_ENV=production ./bin/rake db:migrate

git checkout nnev-custom
git rebase master

RAILS_ENV=production bundle exec rake assets:precompile
sudo systemctl restart hipsterpizza.service


