This is an (incomplete) mock server for running end to end tests when using
the nre-darwin-py library.  It covers the exact cases that I needed for my tests
so you probably won't want to copy it for your tests, but you might want to look
at it for ideas.

It can be started by the end to end tests either by running the php dev server
or by running a test server in the same language as the tests and serving
index.php using CGI or by running the php dev server with a system command.
