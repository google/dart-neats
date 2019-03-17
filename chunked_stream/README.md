Chunked Stream Utilities
========================
Utilities for working with chunked streams, such as `Stream<List<int>>`.

**Disclaimer:** This is not an officially supported Google product.

A _chunked stream_ is a stream where the data arrives in chunks. The most
common example is a byte stream, which conventionally has the type
`Stream<List<int>>`. We say a byte stream in chunked because bytes arrives in
chunks, rather than individiually.

A byte stream could technically have the type `Stream<int>`, however, this would
be very inefficient, as each byte would be passed as an individual event.
Instead bytes arrives in chunks (`List<int>`) and the type of a byte stream
is `Stream<List<int>>`.

To make it easy to work with the chunk streams, such as `Stream<List<int>>`,
this package provides `ChunkedStreamIterator` which allows you to specify how
many elements you want, and buffer unconsumed elements, making it easy to work
with chunked streams one element at the time.

## Example

```dart
final reader = ChunkedStreamIterator(File('my-file.txt').openRead());
// While the reader has a next byte
while (true) {
  var data = await reader.read(1);  // read one byte
  if (data.length < 0) {
    print('End of file reached');
    break;
  }
  print('next byte: ${data[0]}');
}
```
