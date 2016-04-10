import sys

# really just a find replace script to avoid working out the quotation marks and
# slashes in sed but also does a couple of checks

def usage():
    return "usage: python swsdl.py <wsdl string with quotes> <wsdl variable name>"

def bad_args_string(explanation):
    return usage() + "\n" + "got: %s (%s)" % ("  ".join(sys.argv), explanation)

def has_quotes(string):
    for quote in ["'", '"']:
        if string[0] == quote and string[-1] == quote:
            return True
    return False



assert len(sys.argv) == 3, bad_args_string("wrong number of args")
assert sys.argv[1], bad_args_string("original url string is blank")
assert sys.argv[2], bad_args_string("wsdl variable name is blank")
assert "http" in sys.argv[1], "original url doesn't look like url"
assert has_quotes(sys.argv[1]), "original url needs quotes, not sure which kind"

def filter_line(line):
    return line.replace(sys.argv[1], sys.argv[2])



for line in sys.stdin: # don't use fileinput.input(): will think arg is input
    if line != filter_line(line):
        print "# the following line has been modified for testing"
    sys.stdout.write(filter_line(line))
