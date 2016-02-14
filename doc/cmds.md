## Commands

### path

__gl_path is the dir paths for commands. It works similar to PATH environment variable. First dir's are checked first for commands

inner commands are distinguished through the prefix `-`

*. `-is-` prefix for boolean commands
*. `-get-` prefix for information commands

### Completion

Every command handles its completion. If `__complete__` returns 1 or does not exist, the default file name completion is used. If it returns 0, the output is used. For no completion just return 0.
