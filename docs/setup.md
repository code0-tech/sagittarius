---
title: Setup
---

## Configuration

By default, Sagittarius loads `config/sagittarius.yml`. Set
`SAGITTARIUS_CONFIG_FILES` to a comma-separated list of configuration file
paths to load multiple files:

```shell
SAGITTARIUS_CONFIG_FILES=config/sagittarius.yml,/etc/sagittarius/config.yml,/run/secrets/sagittarius.yml
```

Files are deep merged from left to right. Values in later files take
precedence over earlier files and the built-in defaults.
