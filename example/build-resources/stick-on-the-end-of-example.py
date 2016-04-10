# if this is the top of the file, this is not a complete python program .it is added on to the end of a file with make
import textwrap #which is why this import is not at the top
for message in board.nrcc_messages:
    print textwrap.fill(message, width=80, break_long_words=False)
