# Proposal for package shape format

Idea:
 * Use lists of stuff, let the index in the list act as an ID number. Then we
   can just reference the ID number when we reference the thing.
 * Include:
   * Identifier names
   * Library URIs
   * propogated exports
   * defined stuff
 * Exclude:
   * Return types and argument types (maybe we add this later?)

Undecided: (added in draft 2)
   * Imports
   * "extends" and "mixin"
   * "implements"

## Draft 1

```js
{
  "verison": 1,
  "package": "foo",
  "version": "1.0.0",
  "identifiers": [
    "Foo",        // 0
    "sayHello",   // 1
    "Bar",        // 2
  ],
  "libraries": [
    // library 0:
    {
      "uri": "package:foo/foo.dart",
      // Propogated exports, with this we can easily compute the set of exported
      // members.
      "exports": [
        {
          "library": 1, // library 1 is "package:foo/src/bar.dart"
          "show": [
            2,          // identifier 2 is "Bar"
          ],
        },
        {
          "library": 2, // library 2 is "package:bar/bar.dart"
          "hide": [
            0,          // identifier 0 is "Foo"
          ],
        }
      ],
      // Top-level things defined in the library
      // Not everything exported, this can be easily computed by using the
      // "exports" maps.
      "members": [
        {
          "name": 0     // identifier 0 is "Foo"
          "kind": "class",
          "members": [
            {
              "name": 1, // identifier 1 is "sayHello"
              "kind": "method",
              "params": [
                {
                  "name": ...,
                  "kind": "positional" | "named",
                  "required": true | false,
                },
                ...
              ],
            },
            ...
          ],
        },
      ],
    },
    // library 1:
    {
      "uri": "package:foo/src/bar.dart",
      "exports": [
        {
          "id": 0, // library 0 is "package:foo/foo.dart"
          "hide": [
            0,     // identifier 0 is "Foo"
          ],
        },
      ],
    },
    // library 2:
    {
      // TODO: Is this a good way to do external libraries?
      "uri": "package:bar/bar.dart",
      // We know nothing about external libraries, so there no data here.
      // We have an entry in "libraries" such that they have an identifier.
    },
  ],
}
```


## Draft 2

```js
{
  "verison": 1,
  "package": "foo",
  "version": "1.0.0",
  "identifiers": [
    "Foo",        // 0
    "sayHello",   // 1
    "Bar",        // 2
    "Object",     // 3
  ],
  "libraries": [
    // library 0:
    {
      "uri": "package:foo/foo.dart",
      // Propogated exports, with this we can easily compute the set of exported
      // members.
      "exports": [
        {
          "library": 1, // library 1 is "package:foo/src/bar.dart"
          "show": [
            2,          // identifier 2 is "Bar"
          ],
        },
        {
          "library": 2, // library 2 is "package:bar/bar.dart"
          "hide": [
            0,          // identifier 0 is "Foo"
          ],
        }
      ],
      // Import namespaces
      // Namespace 0 is always the default namespace, the one without any prefix.
      // Additional namespaces happens if there is imports like:
      //   import "package:bar/bar.dart" as bar;
      // Then everything that says: bar.SomeName
      // becomes [n, i]
      // , where n refers to the namespace,
      // ,   and i refers to the identifier.
      "namespaces": [
        {
          "imports": [
            {
              "library": 1,
              "show": [
                2,
              ],
            },
            {
              // Unless explicitely imported as "import 'dart:core' show/hide/as
              // then the default namespace ALWAYS imports 'dart:core'.
              // We could opt, to not include it here. But it would make our
              // structure more consistent (well, it's an oppinion)
              "library", 3, // library 3 is 'dart:core'
              "hide": [],   // show everyting
            },
            {
              "library", 4, // library 4 is 'dart:io'
              "hide": [],   // show everyting
            },
            ....
          ],
        },
        {
          "imports": [
            {
              "library": 2, // library 2 is "package:bar/bar.dart"
              "hide": [],
            },
          ],
        },
      ],
      // Top-level things defined in the library
      // Not everything exported, this can be easily computed by using the
      // "exports" maps.
      // We only include public library members, i.e. `class _Foo` is not here.
      "members": [
        {
          "name": 0     // identifier 0 is "Foo"
          "kind": "class",
          // Classes/mixins that are "implemented" or "extended" seen from
          // outside the class, it doesn't really matter whether the thing is
          // extended or implemented (or, if `mixin` is used).
          // We also can't resolve which type it is, just what namespace it
          // comes from.
          "implements": [
            [1, 2], // 1 refers to namespace 1, "package:bar/bar.dart"
                    // 2 refers to identifier 2, "Bar"
            [0, 3], // 0 refers to default namespace, 3 refers to Object
                    // All classes implements Object from dart:core
                    // We could opt to not include this information.
            // Note: `class _Foo` will never appear here, because it's private!
          ],
          "members": [
            // Members defined in the class.
            // If `class X extends/implements/mixin _Y`, where `_Y` is a private
            // class defined in this library, then we'll also include public
            // members from `_Y`, since `_Y` won't be part of the shape.
            // Other members inherited can be resolved using "implements".
            {
              "name": 1, // identifier 1 is "sayHello"
              "kind": "method",
              "params": [
                {
                  "name": ...,
                  "kind": "positional" | "named",
                  "required": true | false,
                },
                ...
              ],
            },
            ...
          ],
        },
      ],
    },
    // library 1:
    {
      "uri": "package:foo/src/bar.dart",
      "exports": [
        {
          "id": 0, // library 0 is "package:foo/foo.dart"
          "hide": [
            0,     // identifier 0 is "Foo"
          ],
        },
      ],
    },
    // library 2:
    {
      // TODO: Is this a good way to do external libraries?
      "uri": "package:bar/bar.dart",
      // We know nothing about external libraries, so there no data here.
      // We have an entry in "libraries" such that they have an identifier.
    },
    // library 3:
    {
      "uri": "dart:core",
    }
    // library 4:
    {
      "uri": "dart:io",
    }
  ],
}
```
