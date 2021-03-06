V ?= @
LOCALHOST := '127.0.0.1'
PORT := '3000'
VERSION := '0.0.1'
LOCALSERVER := 'http://api.dev.local:3000'
RUBYSERVICE := $(shell pgrep ruby)
NGINXSERVICE := $(shell pgrep nginx)
UNICORNSERVICE := $(shell pgrep unicorn)
REDISBROWSERSERVICE := $(shell pgrep puma)
DEVELOPMENT := 'development'
PRODUCTION := 'production'
TEST := 'test'

default:
	$(V)echo Please use \'make help\' or \'make ..any_parameters..\'

help:
	$(V)clear
	$(V)echo "\n\n\t Manual Makefile to start of the project:\n\n make start - Start App Development Environment.\n make test  - Start App Test Environment.\n"

down:
	$(V)if [ "$(RUBYSERVICE)" ]; then killall ruby && echo "Running Ruby Service Killed"; else echo "No Running Ruby Service!"; fi
	$(V)if [ "$(NGINXSERVICE)" ]; then service nginx stop && echo "Running Nginx Service Killed"; else echo "No Running Nginx Service!"; fi
	$(V)if [ "$(REDISBROWSERSERVICE)" ]; then killall redis_browser && echo "Running Redis Browser Killed"; else echo "No Running Redis Browser!"; fi

ruby_drop:
	$(V)echo "\nChecking to see if RUBY process exists:\n"
	$(V)if [ "$(RUBYSERVICE)" ]; then killall ruby && echo "Running Ruby Service Killed"; else echo "No Running Ruby Service!"; fi

processes:
	$(V)ps aux | grep 'ruby' | awk '{print $2}' | xargs kill -9

bundle:
	$(V)rm -f Gemfile.lock
	$(V)bundle

clean:
	$(V)bundle exec rake tmp:clear
	$(V)bundle exec rake log:clear

redis_browser_up: redis_browser_down
	$(V)redis-browser --url redis://127.0.0.1:4567 -n 0

redis_browser_down:
	$(V)if [ "$(REDISBROWSERSERVICE)" ]; then killall redis_browser && echo "Running Redis Browser Killed"; else echo "No Running Redis Browser!"; fi

redis_up:
	$(V)sudo service redis_6379 start

redis_down:
	$(V)sudo service redis_6379 stop

db_create: clean
	$(V)rake db:create

db_migrate: clean
	$(V)rake db:migrate

db_drop: clean
	$(V)rake db:drop

db_reset: clean
	$(V)rake db:reset

db_seed: clean
	$(V)rake db:seed

db_reload: clean
	$(V)rake db:reload

db_empty:
	$(V)rake db:empty RAILS_ENV=test
	$(V)rake db:empty RAILS_ENV=development

db_dev:
	$(V)rake db:drop RAILS_ENV=development
	$(V)rake db:create RAILS_ENV=development
	$(V)rake db:migrate RAILS_ENV=development
	$(V)rake db:seed RAILS_ENV=development

db_test:
	$(V)rake db:drop RAILS_ENV=test
	$(V)rake db:create RAILS_ENV=test
	$(V)rake db:migrate RAILS_ENV=test
	$(V)rake db:seed RAILS_ENV=test

db_setup: clean db_dev

brakeman: clean
	$(V)brakeman -d

server: clean
	$(V)ruby -run -e httpd . -p 3000

test: clean
	$(V)rake test

spec: clean
	$(V)clear
	$(V)bundle exec rspec spec

cuc: clean
	$(V)bundle exec cucumber

start: down clean brakeman
	$(V)echo "\n\n\t  Start App $(DEVELOPMENT) Enviroment\n\n\t     $(LOCALSERVER)\n\n"
	$(V)bundle exec rails s -b api.dev.local

.PHONY: spec
