import logging

_log = logging.getLogger('textextn')

# Extension Methods
def preprocess_commands(ctx):
    return ()

def service_commands(ctx):
    return {}

def service_environment(ctx):
    return {'LD_LIBRARY_PATH': ['some/new/path', 'some/other/path']}

def compile(install):
    return 0
