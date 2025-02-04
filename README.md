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

| Package | Description | Version |
|---|---|---|
| [acyclic_steps](acyclic_steps/) | An explicit acyclic step dependency framework with concurrent evaluation and dependency injection. | [![pub package](https://img.shields.io/pub/v/acyclic_steps.svg)](https://pub.dev/packages/acyclic_steps) |
| [canonical_json](canonical_json/) | Encoder and decoder for a canonical JSON format, useful when cryptographically hashing or signing JSON objects. | [![pub package](https://img.shields.io/pub/v/canonical_json.svg)](https://pub.dev/packages/canonical_json) |
| [chunked_stream](chunked_stream/) | Utilities for working with chunked streams, such as byte streams which is often given as a stream of byte chunks with type `Stream<List<int>>`. | [![pub package](https://img.shields.io/pub/v/chunked_stream.svg)](https://pub.dev/packages/chunked_stream) |
| [dartdoc_test](dartdoc_test/) | Utilities for testing code snippets embedded in documentation comments. | [![pub package](https://img.shields.io/pub/v/dartdoc_test.svg)](https://pub.dev/packages/dartdoc_test) |
| [http_methods](http_methods/) | List of all HTTP methods registered with IANA as list of strings, and metadata such as whether a method idempotent. | [![pub package](https://img.shields.io/pub/v/http_methods.svg)](https://pub.dev/packages/http_methods) |
| [neat_cache](neat_cache/) | A neat cache abstraction for wrapping in-memory or redis caches. | [![pub package](https://img.shields.io/pub/v/neat_cache.svg)](https://pub.dev/packages/neat_cache) |
| [neat_periodic_task](neat_periodic_task/) | Auxiliary classes for reliably running a periodic task in a long-running process such as web-server. | [![pub package](https://img.shields.io/pub/v/neat_periodic_task.svg)](https://pub.dev/packages/neat_periodic_task) |
| [pem](pem/) | PEM encoding/decoding of textual keys following RFC 7468, supporting both lax/strict-mode, and certificates chains of concatenated PEM blocks. | [![pub package](https://img.shields.io/pub/v/pem.svg)](https://pub.dev/packages/pem) |
| [retry](retry/) | Utility for wrapping an asynchronous function in automatic retry logic with exponential back-off, useful when making requests over network. | [![pub package](https://img.shields.io/pub/v/retry.svg)](https://pub.dev/packages/retry) |
| [safe_url_check](safe_url_check/) | Check if an untrusted URL is broken, without allowing connections to a private IP address. | [![pub package](https://img.shields.io/pub/v/safe_url_check.svg)](https://pub.dev/packages/safe_url_check) |
| [sanitize_html](sanitize_html/) | Function for sanitizing HTML to prevent XSS by restrict elements and attributes to a safe subset of allowed values. | [![pub package](https://img.shields.io/pub/v/sanitize_html.svg)](https://pub.dev/packages/sanitize_html) |
| [slugid](slugid/) | A URL-safe base64 encoding for UUIDv4 stripped of padding. Useful when embedding short random UUIDs in URLs. | [![pub package](https://img.shields.io/pub/v/slugid.svg)](https://pub.dev/packages/slugid) |
| [vendor](vendor/) | Utility for vendoring packages into a project and rewriting import/export statements. | [![pub package](https://img.shields.io/pub/v/vendor.svg)](https://pub.dev/packages/vendor) |

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
