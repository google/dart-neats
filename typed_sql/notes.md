
NOTE:
 - No joins yet,
 - No support for subqueries yet!

## TODO:
 + Transactions should use an explicit object, not zones, that's too weird.
 + Refine the adaptor interface
 + Implement dialect for sqlite
 + Write code generation logic
 + Remove .select() for now!
 + Build better interface for .update (accepting expressions)
 - Move to `Query<Expr<User>>`
   - Attempt to allow nested queries with .offset/.where/.offset
 - Add support for `nullable` types
 - Tweak .insert / .update to use Expression<T>
   - Add convinient .create(String email) which takes literal values!
   - Add convinient .updateValues(String email: ...) TODO: Better name!
 - Ensure we can support nullable database fields!
 - Add support of prepared statements (maybe don't call them prepared)
 - Add support for views
 - Support for generation for migration scripts!
 - Add support for dynamic/raw statements (if this makes sense at all)
 - Write tests
 - Add subquery support in .where
 - Consider if QuerySingle<T> can instead be Expression<T>
   - Use .fetch(userId: true, email: false) instead of .select(...)
   - Repurpose .select((u) => u.email) as projection to Query<String>
   - Add support for subqueries and CTEs (with statements) in .where, .update,
     and .select((u, row) => row.add(u.userId).add(u.email))
     More exploration is necessary here, can we make it
     Query<(Expression<User>, ...)>, we'd probably need to tweak .fetch()
 - Consider renmaing Schema/Model to Schema/Row
 - Explore feasibility of JOIN
 - Explore feasibility of aggregate queries
 - Explore feasibility of subqueries in .update
 - Implement dialect for postgres
 - Write generic DatabaseAdaptor tests relying on SqlDialect!
 - Add a .explain() whenever we have a .fetch()
   (consider, if we can use db.explain.users.update...)

## Thoughts on near full SQL expressiveness

SubQuery
    Query extends SubQuery
Expr
    ExprQuery extends Expr

PROBLEM: (found a fix!)
  If Query is a SubQuery, what happens when I do Query.union(Query) -> Query
  But I'm not allowed to do Query.union(SubQuery), or I am, but then union of
  two Query objects is always a SubQuery ?
  It's the same issue for Expr and ExprQuery with .and / .or, etc.
  A possible solution is to say:
    Query<T>.union<S extends SubQuery<T>>(S other) -> S
    SubQuery<T>.union(SubQuery<T> other) -> SubQuery<T>
    Expr<bool>.and(Expr<bool> other) -> Expr<bool>)
    ExprQuery<bool>.and<T extends Expr<bool>>(T other) -> T
  These sorts of hacks might make Join much harder, but we have an intermediate
  step to fix types with there.
  The real problem happens if we have a method accepting 2 Expr or Query objects
  but if that happens, it's probably best to do like .join and make an
  intermediate object so that we can do the type matching with more extensions.


Consider names like:
  QueryExpr     (not the best name, but it's a query that can be used in an expression)
    SubQuery    (Fantastic name!)
    Query       (Fantastic name!)
  Expr
    BoundExpr   (would love a better name)
      // Alternative names: Expr, SubExpr, 
    UnboundExpr (would love a better name)
      // Alternative names: Value, QuerySingle, StaticExpr, 
Note: QueryExpr and Expr are only accept as arguments, there are no extensions on them!


We need the following types:
 * Query<T>
   - Represents a query for a list of Ts.
   - Can be used in .in(Query<T> subquery)
   - We can debate if we need Query as common base-class, or if we could simply
     have Query and SubQuery as two separate classes. In the case of .in(Query)
     we certainly could use .contains(Expression<T>) instead, but it's less
     SQL-like, and there could be other cases where the commonality matters!
     Example: In BoundQuery.join we can accept both bound- and unbound queries!
   - Possibly we can't give the base-class a better name! So we can use
     Query for UnboundQuery and SubQuery for BoundQuery.
 * BoundQuery<T> extends Query<T>
   - Cannot be .fetch()
   - All extension return BoundQuery/BoundExpression objects, example:
     * .count() -> BoundExpression<int>
     * .where() -> BoundQuery<T>
     * .select<T>((BoundExpression<T> e) => (e.email, e.userId)) -> BoundQuery<(Expression<String>, Expression<int>)>
       // Notice that while you can abuse .select to create Query<whatever>
       // You can't pass Query<whereever> to anything, nor will it have a .fetch
       // method, because .fetch is always an extension method!
 * UnboundQuery<T> extends Query<T>
   - Has a .fetch()
 * Expression<T>
 * BoundExpression<T> extends Expression<T>
   - Cannot be .fetch()
   - All extensison return BoundExpression<T>, example:
     * BoundExpression<String>.endsWith('@google.com') -> BoundExpression<bool>
 * UnboundExpression<T> extends Expression<T>
   - Has a .fetch()
   - All extensison return UnboundExpression<T>
 * Join<S, T>
   - UnboundQuery<S>.join(UnboundQuery<T> query) -> Join<S, T>
   - Only has extension methods:
     - .on((Expression<S> a, Expression<T> b) => a.equals(b)))
     - .using(email: true) // When a relation exists
     - .all
   - This allow us to type: q1.join(q2).all
   - We need to make extension like:
     extension Join2with3 on Join<(Expression<A>, Expression<B>), (Expression<C>, Expression<D>, Expression<E>)> {
        UnboundQuery<(Expression<A>, Expression<B>, Expression<C>, Expression<D>, Expression<E>)> get all => ...
     }
   - This way we need lots of extensions, but we get to flatten the type structure!
 * BoundJoin<S, T>
   - BoundQuery<S>.join(Query<T> query) -> BoundJoin<S, T>

We also need as usual:
 * Table<T>
 * View<T>
 * User extends Model representing single rows


QuerySingle<T> needs to be a


## Thoughts on ORMs

What I want:
 * Syntax and logic that is close to SQL.
   - Things like `findOne` or `findMany` don't really map to SQL.
 * Type-safety, at-least through the code base.
   - Avoid untyped properties, like `row['email'] as String`.
   - Avoid untyped arguments, like `.equals('email', 'user@example.com')`.
   - Database interactions are almost always spread throughout the code base,
     this is fine, but we don't want untyped strings outside `model.dart`.
   - Escape hatches / advanced SQL queries will almost always involve some
     potential for type mismatches. But if these are always defined in
     `model.dart` then unsafe things are easier to review when changing tables.
 * Discoverability through auto-completion.

## Thoughts on advanced queries

Instead of supporting joins and complex selects natively, maybe it's better to
support views and prepared statments.

### Views
These can be easily supported as follows:
```dart
@DefineView(PrimaryDatabase, view: 'user_likes', sql: '''
SELECT userId, COUNT(packageName) AS likes FROM users JOIN likes ON userId GROUP BY userId
''')
sealed class UserLikes extends View {
  int get userId;
  int get likes;
}
```

This works with existing query expression logic. And since delete/update/insert
are extensions on `Model` or `Table` they won't be usable on `Query<View>` or
`Query<UserLikes>`.

For complex joins and queries, views is probably a pretty good option.
The view becomes and extension on `PrimaryDatabase` just like the tables.
It's easy to discover, and combined with `.where` they are very flexible.
For example, the view above could be used to find number of likes a particular
user has made.

### Prepared statements

A prepared statement is input types, output types and SQL statement.
This could be made as follows:

```dart
sealed class PrimaryDatabase extends Database {
  PrimaryDatabase(super.connectionPool, super.dialect);

  // When generating code, we automatically generate an implementation of this
  // prepared statment as an implementation of this abstract method.
  @PreparedStatement(''''
    SELECT userId, COUNT(packageName) AS likes
      FROM users
      JOIN likes on userId
      GROUP BY userId
      WHERE userId = :userId AND packageName = :packageName
  ''')
  Future<({
    String packageName,
    int userId,
    int likes,
  })> userLikesPackage(int userId, String packageName);
}
```

Unlike, views, prepared statments are not as flexible in terms of what you can
do with them afterwards. Because all you really can do is called them and get
back the results.
Where as with views you can filter them, or select a subset of the properties.

However, prepared statments are a lot more powerful and less restricted in what
they can do SQL-wise. This allows prepared statements to serve as an
escape-hatch for complex SQL queries. Prepared statments can basically be used
to do any transaction that you can express effectively with the ORM.

Notice: It's really nice that all prepared statements must exist

#### Further prepared statement prototypes
```dart

@PreparedStatement(PrimaryDatabase, sql: '''
  SELECT userId, COUNT(packageName) AS likes
    FROM users
    JOIN likes on userId
    GROUP BY userId
    WHERE userId = :userId AND packageName = :packageName
''')
typedef UserLikesPackage = ({
  String packageName,
  int userId,
  int likes,
})
    Function(
  int userId,
  String packageName,
);

@PreparedStatement(PrimaryDatabase, sql: '''
  SELECT userId, COUNT(packageName) AS likes
    FROM users
    JOIN likes on userId
    GROUP BY userId
    WHERE userId = :userId AND packageName = :packageName
''')
typedef UserLikesPackage = ({
  String packageName,
  int userId,
  int likes,
});

/*

final userLikesPackage = PreparedStatement<({int userId, String packageName})>()
  .param<int>('userId')
   .param<String>('packageName')
   .define((userId, packageName) => '''
    SELECT userId, COUNT(packageName) AS likes FROM users JOIN likes on userId GROUP BY userId
    WHERE userId = $userId AND packageName = $packageName
  ''')

@PreparedStatement(PrimaryDatabase, sql: '''
  ...
''', params: ['userId', 'packageName'])
typedef UserLikesPackage = ({
  String packageName,
  int userId,
  int likes,
});



Future<({
  String packageName,
  int userId,
  int likes,
})> userLikesPackage(int userId, String packageName);
```

## Thoughts on join

pros/cons for: `db.users.join(db.likes) -> Query<(User, Like)>`
 + It makes logical sense and maps nicely to SQL.
 + You could do `.on(email: true)` or `.where(...)`, which also makes sense.
 - It's very rarely what you'd want to do, in practice you almost always want
   `Query<(User, List<Like>)>`, which doesn't fit nicely with this.

pros/cons for: `db.user.joinLeft(db.likes) -> Query<(User, List<Like>)>`
 - `joinLeft` is hard to understand.
 - Can be become difficult if we expand with more joins.
 + Maps reasonably to SQL.
 + This is often what we'd want to do.

TL;DR: Maybe, we shouldn't support joins at all, or anytime soon.
       It'll often be preferable to just use multiple queries.
       That's much easier to control in Dart too.

## Idea for join (probably not good)
```dart
    dynamic magic;
    final q = magic as Query<(User, List<Like>)>;
    final q = db.users // Query<User>
        .where((u) => u.email.endsWith.literal('@google.com')) // Query<User>
        .join(db.likes) // Query<(User, Like)>
        .where((u, l) => u.userId.equals(l.userId)) // Query<(User, Like)>
        .groupLeft // Query<(User, List<Like>)>
        .fetch(); // Stream<(User, List<Like>)>
    await for (final (u, likes) in q.fetch()) {
      print(u);
      print(likes.length);
    }
    // Notice: .join(db.likes) could also use a subquery, like:
    //         .join(db.likes.where((l) => l.package.startsWith('_').not()))
    //
    // Notice: Instead of the .where((u, l) => ...), we could probably make
    //         extensions on Query<(User, Like)> that take the form:
    //         .on(userId: true)
    //         By creating `.on({bool userId})` as an extension on
    //         Query<(User, Like)>.
    //         Possibly, we'd make .join() return a JoinQuery<(User, Like)>
    //         such that .on(userId: true) is an extension on that.
    //         And you can't do: `.join(..).where(..).on(userId: true)`
    //         Because I'm pretty sure that the .on() has to come before
    //         .where / .limit / .offset, etc.
    //
    // Notice: .groupLeft is not entirely figured out, it doesn't mean GROUP BY
    //         from SQL, but it's close.
    //         It could also be that we should express it with:
    //           .joinLeft() -> Query<(User, List<Like>)>
    //
```

## Another fun idea for how express the model:

```dart
sealed class PrimaryDatabase extends Database {
  PrimaryDatabase(super.connectionPool, super.dialect);

  @Sql('''
  CREATE TABLE users (
    userId INTEGER PRIMARY KEY,
    email TEXT NOT NULL UNIQUE
  )
  ''')
  Table<({int userId, String email})> get users;

  @Sql('''
  CREATE VIEW user_likes (
    SELECT userId, COUNT(likes.packageName) as likes
    FROM users JOIN likes ON userId
    GROUP BY userId
  )
  ''')
  View<({int userId, int likes})> get userLikes;

  @Sql(''''
    SELECT userId, COUNT(packageName) AS likes
      FROM users
      JOIN likes on userId
      GROUP BY userId
      WHERE userId = :userId AND packageName = :packageName
  ''')
  Future<({
    String packageName,
    int userId,
    int likes,
  })> userLikesPackage(int userId, String packageName);
}
```
