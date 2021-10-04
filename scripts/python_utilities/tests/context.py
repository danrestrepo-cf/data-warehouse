# update system path so that unit tests in the /tests directory can import classes and functions from /src
# each test_*.py unit test file should import this context file before attempting any /src imports

import sys
import os

sys.path.append(os.path.dirname(os.path.realpath(__file__)) + "/../src")
