Slugid - Compressed UUIDv4
==========================

A slugid is a [URL-safe base64](https://tools.ietf.org/html/rfc4648#section-5)
encoded [UUID version 4](https://tools.ietf.org/html/rfc4122#section-4.4)
stripped of `==` padding bringing the total size to 22 characters.

**Disclaimer:** This is not an officially supported Google product.

**Examples** of slugids:
 * `U_sWAEJnR4epXu-TK0FCYA`
 * `-8prq-8rTGqKl2W9SSfyDQ`
 * `ti8C-AKGQsq3rDjSuXe94w`
 * `Fum-zBhASyO50rg3mtQcD`

There are two variants of slugids:
 * The `Slugid.v4()` variant, which is a random UUID v4.
 * The `Slugid.nice()` variant, which is a random UUID v4 selected such that
   the slugid encoding doesn't start with `-`.

The _nice_ variant is nicer to use in commandline utilities, but it comes at a
slight cost in entropy. For more details refer to the
[original implementation](https://github.com/taskcluster/slugid) in javascript.

## See also
 * [Slugid for Javascript](https://github.com/taskcluster/slugid) ([npm](https://www.npmjs.com/package/slugid)).
 * [Slugid for Python](https://github.com/taskcluster/slugid.py) ([pypi](https://pypi.org/project/slugid/)).
 * [Slugid for golang](https://github.com/taskcluster/slugid-go).
