Scripts used to keep the Winch datastore in sync with the corresponding
Redis documentation resources.

## Requirements

```shell
gem install redcarpet
gem install batch
```

## Steps

### 1. Convert data

This converts Redis doc into local data files:

```shell
./convert.rb
```

The local directory layout is as follow:

```
data
├── cmds
│   ├── append.json
│   ├── ...
├── docs
│   ├── append.html
│   ├── ...
└── groups
    ├── 001.json
    ├── ...
```

### 2. Index data into Winch

TODO
