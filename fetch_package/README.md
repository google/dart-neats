# fetch_package

A utility for easily downloading and extracting a package archive from pub.dev
or other repository.

Useful for reviewing the source-code of a pub package or for easily running
examples.

## Usage

This package is intended for global installation. Run this to install the latest version:

```
> dart pub global activate fetch_package # Only on first run
```

If you want to inspect the source code of the latest version of this package:

```
> dart pub global run fetch_package fetch_package
```

To inspect the source of a specific version:

```
> dart pub global run fetch_package fetch_package 0.1.0
```

You can also download the archive of the package:

```
> dart pub global run fetch_package fetch_package --archive
```