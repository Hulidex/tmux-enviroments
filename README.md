# TMUX ENVIRONMENTS
## Jolu Izquierdo (alias Hulidex)
---

# Overview
---

Configure environments for tmux by creating an 'env' file, where you can specify a hierarchy of
sessions, windows and panes. For more information about tmux, reference to this
[guide](https://github.com/tmux/tmux/wiki)

# Installation
---

I didn't make the whole code on bash for nothing, one of the aim of use it, is to ensure that
is compatible with every linux distribution with a bash shell without the needed to install
any package or library.

first clone the repository into a folder (I recommend to clone it to a hidden folder):

```bash
  $ git clone https://github.com/Hulidex/tmux-environments.git .tmux-environments
```

To run the script, just execute the script passing as first argument
the path to your .tmux.env file:

```bash
  $ cd .tmux-environments
  $ ./tmux.sh path_to_tmux_env_file
```

if you want to automate the process edit your `.bashrc` file (I use vim editor, use
one of your choice)
Obviously this steps are optional and can be done in different ways...

```bash
  $ vim ~/.bashrc
```

  1. Create two variables to store the path where the script reside and the path
     to your .tmux.env file

```bash
  TMUX_ENV_SH="$HOME/.tmux-environments"
  TMUX_ENV_FILE="PATH_TO_TMUX_ENV_FILE"
```

  2. Make an alias to execute the script with the given file
```bash
  alias kicktmux="cd $TMUX_ENV_SH && ./tmux.sh $TMUX_ENV_FILE && cd -"
```

To update, enter into the folder and type this command:

```bash
  $ git pull
```

# Syntax
---

## General syntax

When writing a file to specify a tmux environment you must have this rules in mind:
* Doesn't matter the extension used for the file
* Is obligatory to give a name to **windows** and **panes**
* If a **path** is specified as an option of a sentence it must be an **ABSOLUTE** path
* Commentaries follow the `bash` script convention (Use character '#' at the beginning of the line)
* Inline commentaries are not permitted.
* You can use tabs or spaces at the beginning of a sentence to organize in a better way the structure of your file
* Sentences are defined by using a keyword and then their options separated with the character ':'


## Sentences

> The general syntax is like `keyword:option1:option2:option3:...:optionN`

> Optional options are described surrounded by '{' ... '}'

Common options:
* `name` : Name of the session/window (Ex: 'rails')
* path : Absolute path, where the session/window/pane will reside. (Ex: '/home/user/projects')
* command: Any expression (or command) that you can run on your terminal (Ex: 'echo "hellow world!" | grep -o "world"')

### Session

```bash
  s:name
```
Use the keyword **s** to define a **session**, the option **name** is obligatory


### Window

```bash
  w:name:{path}:{command}
```
Use the keyword **w** to define a **window**, the option **name** is obligatory
Windows are created within a session in tmux, so they **must belong to a session**

### Pane

```bash
  p[vh]:{path}:{command}
```

Use the keyword **p** to define a **pane**, you must specify the suffix 'v' or 'h'
Panes are created within a window in tmux, so they **must belong to a window**
* Use `pv` if you want a **vertical** pane
* Use `ph` if you want a **horizontal** pane

## Examples

.tmux.env example files can be found in the directory **examples**

