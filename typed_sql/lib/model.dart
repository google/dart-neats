// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:typed_sql/typed_sql.dart';

part 'model.g.dart';

abstract final class PrimaryDatabase extends Schema {
  Table<User> get users;

  Table<Like> get likes;

  Table<Package> get packages;

  //View<({int userId, int likes})> get userLikes;
}

@PrimaryKey(['userId'])
abstract final class User extends Model {
  int get userId;

  // TODO: We have no support for nullable fields, because .update(email: null)
  //       just means don't update `email`, and the `_User` model uses null as
  //       indicator that a value wasn't fetched in .select(email: false).
  //       The case with `_User` using null can be fixed, but how do we fix
  //       the distintion between .update(email: null) and explicitly setting
  //       the `email` property to `null`.
  //       We could do .update(email: Expression<String>), but it's a bit sad
  //       to have to write .update(email: Literal('user@example.com')).
  //       This would ofcourse be cool, because it would be possible to update
  //       to a value created in a subquery, with a few more tricks.
  //       That said, this seems pretty advanced, and probably something that's
  //       rarely needed in practice.
  //       Another option would be:
  //         .set(email: '...'), meaning update email to '...'
  //         .set(email: null), meaning don't change email
  //         .unset(email: true), meaning set email to NULL
  //       Or we could do:
  //         .update(email: '...' | null | NULL), but then the type of 'email'
  //         in the function would have to be dynamic. This is ugly.
  //       Or we could do just do: .update(email: Expression<String>), but then
  //       instead of focusing on subqueries, we'd have to focus on expression
  //       on the User row itself.
  //       .update((Expression<User> u, Values Function({Expression<String> email}) set) => ...)
  //       Examples:
  //       .update((u, set) => set(email: null)) // no change to email
  //       .update((u, set) => set(email: Literal('...')))
  //       // Then we can update based on existing values with:
  //       .update((u, set) => set(email: u.name.suffix('@example.com')))
  //       Perhaps this is the best option, it also leaves the door open for
  //       supporting subqueries in the future. And it allows us to make simple
  //       updates and increments or decrements a counter without transactions.
  @Unique()
  String get email;
}

@PrimaryKey(['name'])
abstract final class Package extends Model {
  String get name;
}

@PrimaryKey(['userId', 'packageName'])
abstract final class Like extends Model {
  @References(User, 'userId')
  int get userId;

  @References(Package, 'name')
  String get packageName;
}
