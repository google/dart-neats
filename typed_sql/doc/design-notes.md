# Design notes
This document aims to record some of the design decisions and opinions we've
made along the way. Such that we can recall the rationale and remain consistent
in the future. This document does not aim to be a canonical record of all
design decisions.

## Overall goals
 * Type-safety
 * Null-safety
 * Minimize runtime errors, unless users are explicitly doing casts.

## Equality operators
SQL uses 3 valued-logic, which means that `NULL = anything` evaluates to `NULL`.
This also means that `NULL = NULL` evaluates to `NULL`. And `NOT NULL` evaluates
to `NULL`.

This can be quite surprising when writing Dart where `==` has very different
semantics.

SQL does provide an `IS NOT DISTINCT FROM` comparison operator which behaves
like Dart. However, in certain scenarios it is not as efficient, nor necessarily
desired (when joining tables, you rarely want to join rows on `NULL`).

To give users power and protect them, we expose the two fundamental operators as:
 * `a.equalsUnlessNull(b)` meaning `a = b`, and,
 * `a.isNotDistinctFrom(b)` meaning `a IS NOT DISTINCT FROM b`.

This way, if users want the SQL semantics from `=` that can easily pick that.
But they have to type a longer than that should prompt them to read
documentation and be aware of the caveats.

Because `=` is typically, what users want to use (for performance), we expose
a `.equals` extension method that return `Expr<bool?>` and requires that at-least
one of the operands is non-nullable. This way, users may still do `NULL = value`
and get `NULL`, but they won't get the case where `NULL = NULL` evaluates
to `NULL`. If users really want that, they can use `.equalsUnlessNull`.

To further protect users we don't expose `.not()` on `Expr<bool?>`, because it
would be surprising that `NOT NULL` evaluates to `NULL`. In particular, if a
user were to do `a.equals(b).not()`. Similarly, we implement `.notEquals` only
when both sides are non-nullable.

For users the out is to use `.isTrue()` on `Expr<bool?>`, or use
`.isNotDistinctFrom`. Depending on what semantics they want.

In either case, we've taken the oppinion that the fundamental SQL equality
operators that follow 3 valued-logic should be suffixed `<...>UnlessNull`,
and that short-hands should only be offered when `NULL` is equivalent to `FALSE`.

Thus, if we want to introduce `<>` or `NOT` more generally, it should be as
`.notEqualsUnlessNull` and `.notUnlessNull()`.
