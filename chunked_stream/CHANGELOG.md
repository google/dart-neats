## v1.3.0-nullsafety.0

- Migated to null safety

## v1.2.0

- Changed `ChunkedStreamIterator` implementation to fix bugs related to
  stream pausing and resuming.

## v1.1.0

- Added `asChunkedStream(N, input)` for wrapping a `Stream<T>` as a
  chunked stream `Stream<List<T>>`, which is useful when batch processing
  chunks of a stream.

## v1.0.1

- Fixed lints reported by pana.

## v1.0.0

- Initial release.
