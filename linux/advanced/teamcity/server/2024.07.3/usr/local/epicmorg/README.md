# About
Hello. This folder contains sub-folders with custom tools such as `gosu`, `dumb-init` and etc.

Some child images could install to this folder custom compilled products. Example: `nginx`, `php`, etc.

All directories that contains binaryes (`<bin\sbin>`) will be added to `$PATH`.

# Structure
pattern: `/usr/local/epicmorg/<program-name>/<version>/<..some data and files..>`

example:
```
/usr/local/epicmorg/
|-- 7z
|   `-- 7z2409
|       |-- History.txt
|       |-- License.txt
|       |-- MANUAL
|       |-- bin
|       `-- readme.txt
|-- dumb-init
|   `-- 1.2.5
|       `-- bin
|-- gosu
|   `-- 1.17
|       `-- bin
|-- lazycli
|   `-- 0.1.15
|       `-- bin
|-- lazydocker
|   `-- 0.23.3
|       |-- LICENSE
|       |-- README.md
|       `-- bin
|-- lazygit
|   `-- 0.42.0
|       |-- LICENSE
|       |-- README.md
|       `-- bin
|-- lazynpm
|   `-- 0.1.4
|       |-- LICENSE
|       |-- README.md
|       `-- bin
`-- p4
    `-- r23.2
        `-- bin
```
