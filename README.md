# LinkShort-cli
The Commandline Tool for my LinkShort API.

## Example

```bash
./LinkShort-cli -c https://www.youtube.com/watch?v=dQw4w9WgXcQ
```
```bash
Short: 17a76043
Link: https://ls.johannespour.de/17a76043
```

## Flags

* `-h` or `--help`
<br>Show all flags available

* `-c LINK` or `--create=LINK`
<br>Create a shortcut for the link

* `-s` or `--save`
<br>Save the shortcut object

* `-l SHORTCUT` or `--load=SHORTCUT`
<br>Load a certain shortcut object

* `-?` or `--show`
<br>Print info about the shortcut object