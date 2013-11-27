Scripts used to keep the Winch datastore in sync with the corresponding
Redis documentation resources.

## Requirements

You need the
[Winch Ruby client](https://winch.io/documentation/api/tutorial/#ruby-client)
properly installed. In addition you also need:

```shell
gem install redcarpet
gem install batch
```

## Steps

### 1. Update submodules

**Goal**: keep the local Redis docs in sync with the official repo.

```shell
git submodule update --remote
```

> The `--remote` option is available as of Git 1.8.2. It fetches and ensures that the latest commit from the branch is used. See [this](http://www.vogella.com/articles/Git/article.html#submodules_trackbranch)
for more details.

### 2. Convert data

**Goal**: convert the Redis docs into local data files that fit with our data model.

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

### 3. Index data into Winch

**Goal**: transfer local data files to the Winch datastore.

```
WNC_CRED="user@mail.com:pAsSwoRd" ./index.rb snippets
```

> Note: this is quite basic (and inefficient). It will be improved in a near
future. Also: it does not care about removing stuff (which should never happen).
