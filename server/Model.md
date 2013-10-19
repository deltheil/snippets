The Data Model to be followed by SNIPPETS
=========================================

In total there are three collections for
the name space:

## rds:types

              {
    > key   = <2 digit auto-incrmented number as string>
              }

              {
    > value = name : <group name>
              cmds : [list of commands that constitute group]
              }

### Example

        > winch.get(namespace = "rds:types", key = "03")
        {
         "name": "Hashes",
         "cmds": [
          "hdel",
          "hget",
          "hlen",
          ...
         ]
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

### Example

        > winch.get(namespace = "rds:cmds", key = "hget")
        {
         "name": "HGET",
         "summary": "Get the value of a hash field"
         "cli": [
          "HSET myhash field1 \"foo\"",
          "HGET myhash field1",
          "HGET myhash field2"
         ]
        }

## rds:cmds_html

              {
    > key   = <command name in smaller case and whitespace replaced by dash>
              }

              {
    > value = <data as HTML to be rendered by client>
              }

### Example

        > winch.get(namespace = "rds:cmds_html", key = "hget")
        <header><h1>HGET</h1><h2>key field</h2></header>...
