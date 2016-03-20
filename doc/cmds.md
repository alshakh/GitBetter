# Commands

## Completion

commands starting with `_` is hidden from completion unless it's written to complete.

If `>>` is the tab, `a>>` will be completed for example to `amend` and it will not produce `_arguments` because it starts with `_`. But, `_>>` will be completed to `_arguments`.

Furthermore, there are levels of hidden commands. commands which starts with two `_` it will not appear untill inputing two `_` and so on.

## Custom command

## path

`__gl_path` is the dir paths for commands. It works similar to PATH environment variable. First dir's are checked first for commands

### Adding to path

To make sure that gb commands are not overrided by user's commands with the same name, new paths should be added to the end of `__gl_path`

### __run__

gb provides the boolean `SHOUTING`. for commands to indicate `!` at the end of command. It means that the command should be stronger.

exit code of `__run__` is the same as `gb command`.

### __complete__

Every command handles its completion in the function `__complete__`. gb provides `CURRENT_TERM` for the current word to be completed. You have to call `compgen` to filter wrong completions.

`$@` will be the args after command name. For example `gb command foo bar ba>>` will call `__complete__ foo bar` and `CURRENT_TERM` will be `ba`. `CURRENT_TERM` will be empty when appropriate.

#### return value

If `__complete__` returns 1 or does not exist, the default file name completion is used. If it returns 0, the output is used. For no completion just return 0

