# vim: filetype=python
#

# useful modules to have pre-imported
import os
import sys

def try_rlcompleter_ng():
    try:
        import rlcompleter_ng
        rlcompleter_ng.setup()
        return True
    except ImportError:
        return False

def try_rlcompleter2():
    try:
        import rlcompleter2
        rlcompleter2.setup()
        return True
    except ImportError:
        return False

def try_rlcompleter():
    import readline
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    return True

def setup_readline():
    import readline
    assert try_rlcompleter_ng() or try_rlcompleter2() or try_rlcompleter()

    histfile = os.path.join(os.environ["HOME"], ".pyhist")
    try:
        getattr(readline, "clear_history", lambda : None)()
        readline.read_history_file(histfile)
    except IOError:
        pass
    import atexit
    atexit.register(readline.write_history_file, histfile)

if __name__ == '__main__':
    setup_readline()
