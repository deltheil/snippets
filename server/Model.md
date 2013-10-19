The Data Model to be followed by SNIPPETS
=========================================

In total there are three collections for 
the name space:

## rds:types

              {
    > key   = <4 digit auto-incrmented number as string>
              }

              {
    > value = name : <group name>
              cmds : [list of commands that constitute group]
              }


## rds:cmds
              
              {
    > key   = <command name in smaller case and whitespace replaced by dash>
              }

              {
              name    : <command name in upper case>
    > value = summary : <command summary text>
              cli     : [list of examples for preloading to client console]
              }


## rds:cmds_html
              
              {
    > key   = <command name in smaller case and whitespace replaced by dash>
              }

              {
    > value = <data as HTML to be rendered by client>
              }

