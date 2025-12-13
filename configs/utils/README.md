# Utils

Utility shortcuts and productivity functions.

## Files

- `shortcuts.zsh` - Directory shortcuts & utility functions

## Directory Shortcuts

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Up 1 level |
| `...` | `cd ../..` | Up 2 levels |
| `....` | `cd ../../..` | Up 3 levels |
| `.....` | `cd ../../../..` | Up 4 levels |

## Functions

### `mkcd <directory>`
Create directory and cd into it.

```zsh
mkcd my-new-project
# Creates and enters my-new-project/
```

### `backup <file>`
Create timestamped backup of a file.

```zsh
backup config.json
# Creates config.json.bak.20241213_143052
```

### `extract <archive>`
Universal archive extractor. Supports:
- `.tar.gz`, `.tar.bz2`, `.tar.xz`
- `.zip`, `.rar`, `.7z`
- `.gz`, `.bz2`

```zsh
extract archive.tar.gz
```

### `ports`
Show listening ports.

```zsh
ports
# Lists all processes listening on ports
```

### `myip`
Show public IP address.

```zsh
myip
# 203.0.113.42
```

### `localip`
Show local IP address.

```zsh
localip
# 192.168.1.100
```

### `weather [city]`
Show weather (optional city).

```zsh
weather
# Weather for current location

weather Tokyo
# Weather for Tokyo
```
