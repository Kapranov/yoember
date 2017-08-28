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

nginx: ruby_drop
	$(V)if [ "$(RUBYSERVICE)" ]; then killall ruby && echo "Running Ruby Service Killed"; else echo "No Running Ruby Service!"; fi
	$(V)if [ "$(NGINXSERVICE)" ]; then service nginx stop && echo "Running Nginx Service Killed"; else echo "No Running Nginx Service!"; fi
	$(V)if [ "$(UNICORNSERVICE)" ]; then ps aux | grep 'unicorn' | awk '{print $2}' | xargs kill -9 && echo "Running Unicorn Service Killed"; else echo "No Running Unicorn Service!"; fi

bundle:
	$(V)bundle clean --force
	$(V)rm -f Gemfile.lock
	$(V)bundle

clean: bundle
	$(V)clear
	$(V)bundle exec rake tmp:clear
	$(V)bundle exec rake log:clear

redis_browser_up: redis_browser_down
	$(V)redis-browser --url redis://127.0.0.1:6379 -n 1
	#$(V)redis-browser --config config/redis_browser.yml

redis_browser_down:
	$(V)if [ "$(REDISBROWSERSERVICE)" ]; then killall redis_browser && echo "Running Redis Browser Killed"; else echo "No Running Redis Browser!"; fi

db_up:
	$(V)sudo service redis_6379 start

db_down:
	$(V)sudo service redis_6379 stop

db_drop:
	$(V)rake db:drop

db_reset:
	$(V)rake db:reset

db_seed:
	$(V)rake db:seed

db_reload:
	$(V)rake db:reload

brakeman:
	$(V)brakeman -d

server:
	$(V)ruby -run -e httpd . -p 3000

test: clean
	$(V)rake test

start: down nginx clean brakeman
	$(V)echo "\n\n\t  Start App $(DEVELOPMENT) Enviroment\n\n\t     $(LOCALSERVER)\n\n"
	$(V)bundle exec rails s -b api.dev.local
