# An experiment with fast and simple analysis

Shape analysis:
 * Extract top-level names in a package version.
 * Do so for all package versions
 * Combine into a summary of what version we know the top-level name to be
   introduced.

Custom lint:
 * If top-level name is used, check that shape can't prove that it was not
   available in the lower-bound version constraint.

Note:
This is dumb, simple, but maybe it can catch many simple cases.
