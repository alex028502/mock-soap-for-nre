MOCK_SERVER_PORT=8888

.PHONY: build test example mock-server clean bundle-install
build: example bundle-install mock-server
test: build
	MOCK_SERVER_PORT=$(MOCK_SERVER_PORT) cucumber
example:
	$(MAKE) -C example
mock-server:
	$(MAKE) -C mock-server
bundle-install:
	bundle install
clean:
	$(MAKE) clean -C example
	$(MAKE) clean -C mock-server
