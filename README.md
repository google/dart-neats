Dart Neats [![Github Actions](https://github.com/google/dart-neats/actions/workflows/dart.yml/badge.svg)](https://github.com/google/dart-neats/actions/workflows/dart.yml)
==========
_A collection of a small neat packages for dart._

**Disclaimer:** This is not an officially supported Google product.

This repository is meant as a playground where small _neat_ packages are
cultivated. If package grows too large and complex and needs a dedicated issue
tracker it should be moved to a dedicated repository.

Each folder in this repository contains a _neat_ `pub` package. This project
aims to use a separate package whenever it makes sense to have an independent
major version. This often means splitting functionality into separate packages,
which can be reused independently.

## Repository Management
The root `pubspec.yaml` is only intended to lock the development dependencies
for repository management. When adding new packages or changing `mono_repo.yaml`
or `mono_pkg.yaml` in a package, make sure to run the following commands to
update travis configuration.

 * `pub get`
 * `pub run mono_repo travis`

## Contributing
We love patches and contributions, please refer to [CONTRIBUTING.md][1] for
technicalities on [CLA][2] and community guidelines. As this project aims to
build _neat_ packages using other _neat_ packages we might also accept proposals
for new neat packages, though it's often easier to publish independently.

## License
Unless stated otherwise contents in this repository is licensed under
Apache License 2.0, see [LICENSE](LICENSE).

[1]: CONTRIBUTING.md
[2]: https://cla.developers.google.com/
