# Mock NRE SOAP

I needed a mock SOAP server to provide a small subset of the functionality of
the LDB SOAP web service in order to end-to-end test another python project that
uses [nre-darwin-py](https://pypi.python.org/pypi/nre-darwin-py/0.1.0).

One thing led to another and I ended up messing around with:
* Zend Framework / PHP (for SOAP)
* Cucumber / ruby (for tests)
* docker (for continuous integration)

#### The repo includes

* the [mock soap server](mock-server/) itself.
* a test [command line client](example/) that is generated from
nre-darwin-py's sample client, that connects to the mock server.
* [cucumber tests](features/) both for the mock api itself and for the sample
client connected to the mock api

## Bits of code you might find interesting
or that I might need in the future

* [mock webservice ](mock-server) including [a class to give an xsd:sequence
and arbitrary array name](mock-server/ArrayOfTypeSequence.php), and
[a way to make a Zend Framework Soap service work on a server that can't handle
simultaneous requests](mock-server/index.php)
* [makefile](dockermake) that builds the docker image, and builds the
.dockerignore file from the .gitignore file using a [script that translates the
paths](./translate-gitignore-to-dockerignore.sh) and compares the ruby, python,
php, and bundler versions your computer with those on the docker image.
* a [sample python client](example/) that is [generated](example/makefile) from
the sample client in nre-darwin-py, allowing us to inject a different wsdl.
* [run php test server from ruby](config/services.rb)
* [translate .gitignore files into .dockerignore](deployment/translate-ignore.sh)
(more or less)

## running it (via the cucumber tests)

Cucumber tests both test the mock library directly, and test a command line
program written with the library.

### run without docker

```bash
# make sure you have php, python, ruby, and bundler installed globally and
make test MOCK_SERVER_PORT=9999 #or leave out the port if you are happy with default
# if you are lucky, it will work with the versions you have installed
```

### run with docker

```bash
# make sure you have docker installed so that it doesn't require sudo and
make -fdockermake test
```

### compare the two

```bash
make -fdockermake compare
```

## or just try the sample client without cucumber

terminal 1:

```bash
cd mock-server
make
php -S localhost:8888 #change the port if you like
```

terminal 2:
```bash
cd example
make
#use the same port as above
TEST_WSDL=http://localhost:8888/?wsdl DARWIN_WEBSERVICE_API_KEY=FAKE-API-KEY virtualenv/bin/python test-example.py
#and then enter KGX
```

#### and to see the sample client work with the real webservice

It is very similar to the example in nre-darwin-py, but shows the board messages
at the bottom.  You must have an api key. (see https://pypi.python.org/pypi/nre-darwin-py)

```bash
cd example
make example.py
DARWIN_WEBSERVICE_API_KEY=<your api key> virtualenv/bin/python example.py
#and then enter any station code you like
```

will give you a diff of the php, python, ruby, and bundler versions running
locally and on the docker image to help figure out why it is working one way
but not the other.
