.PHONY: build clean
build: vendor
vendor: composer.phar composer.json composer.lock
	php composer.phar install
composer.phar: composer-setup.php
	php composer-setup.php --version=1.0.0
composer-setup.php:
	# if you are installing composer somewhere other than travis, better to
	# follow the instructions on https://getcomposer.org/download/ since they
	# check the hash and delete composer-setup.php
	wget https://getcomposer.org/installer -O composer-setup.php
clean:
	rm -f composer.phar
	rm -f composer-setup.php
	rm -rf vendor
