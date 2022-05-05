# Vendoring packages in Dart

Tool for vendoring packages into a Dart project, and rewriting import/export
statements.

**Disclaimer:** This is not an officially supported Google product.

The pub package eco-system powering Dart and Flutter only supports a single
version of each package. This has many benefits, such as:
 * Avoids confusing type errors saying that an object of type `Foo` is not
   type `Foo`; which will happen if two versions of the same library providing
   `Foo` are used in the same codebase.
 * Discourages a bloated dependency trees, because these easily cause
   resolution conflicts.
 * Discourages use of outdated package versions, because these won't work in
   conjunction with other packages that require the newest version.

However, while it is almost always preferable to use well maintained
dependencies that themselves have up-to-date dependencies. It can on occasion be
necessary to keep using an unmaintained package or outdated package version.
Often this happens if there is no alternative package that is well maintained,
or maybe the changes necessary to upgrade are large and requires major
refactoring that you're not willing to undertake at this point.

Regardless, of the reasons, when using outdated packages in combination with
packages that are kept up-to-date it's easy to run into a version resolution
conflict because of mutual dependencies, and the single package version
limitation. If the changes between two versions of a package is minor, these
resolution conflicts can often be overruled using `dependency_overrides`.
This won't solve incompatibilities, but it can make the version solver ignore
them. Just because two version numbers are incompatible doesn't mean the code in
the package has breaking changes, or that those breaking changes affect your
usecase.

If two versions of a dependency is truly desired then `dependency_overrides`
won't solve the problem. In practice the only solution available is to either
fork the package, or copy/paste (vendor) the package into your project. This is
what `package:vendor` can help do: vendor a package into your project.

In short, `package:vendor` helps to manage _vendored packages_, that is
manage packages that are copied into your source tree.

To set up vendoring create a
`vendor.yaml` file in the project root that specifies which package should be downloaded into
`lib/src/third_party/<name>/` for a given name, and how import/export
declarations in Dart files should be rewritten.

```yaml
# vendor.yaml
import_rewrites:
  # Map of rewrites that should be applied to lib/, bin/ and test/ in project.
  # Example:
  #   import "package:<package>/..."
  # is rewritten to:
  #   import "package:myapp/src/third_party/<name>/lib/..."
  # where 'myapp' is the root project name.
  <package>: <name>
vendored_dependencies:
  # Specification of which packages to be vendor into:
  #   lib/src/third_party/<name>/
  <name>:
    package: <package>
    version: <version>
    import_rewrites:
      # Rewrites to be applied inside: lib/src/third_party/<name>/
      <package>: <name>
    include:
    # Glob patterns for which files to include from the package.
    # For syntax documentation see: https://pub.dev/packages/glob
    #
    # If not specified `include` will default to the following list:
    - pubspec.yaml # always renamed vendored-pubspec.yaml
    - README.md
    - LICENSE
    - CHANGELOG.md
    - lib/**
    - analysis_options.yaml
```

After creating a `vendor.yaml` file you'll need a `dev_dependency` on
`package:vendor` (`dart pub add --dev vendor`), then running `dart run vendor`
will print changes to be made, prompt for confirmation and apply changes.

A file to track state of vendored packages is created in
`lib/src/third_party/vendor-state.yaml`. This file should be checked into
version control. This allows changes to `vendor.yaml` to be applied without
removing all that has already been vendored, and allows import-rewrites to be
both added and removed. This means that if necessary patching the contents of
vendored packages is not unreasonable.

