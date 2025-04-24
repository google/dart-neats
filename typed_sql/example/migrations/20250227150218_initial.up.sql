-- create "users" table
CREATE TABLE `users` (
  `userId` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `name` text NOT NULL,
  `email` text NOT NULL
);
-- create index "users_email" to table: "users"
CREATE UNIQUE INDEX `users_email` ON `users` (`email`);
-- create "packages" table
CREATE TABLE `packages` (
  `packageName` text NOT NULL,
  `likes` integer NOT NULL DEFAULT 0,
  `ownerId` integer NOT NULL,
  `publisher` text NULL,
  PRIMARY KEY (`packageName`),
  CONSTRAINT `0` FOREIGN KEY (`ownerId`) REFERENCES `users` (`userId`) ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create "likes" table
CREATE TABLE `likes` (
  `userId` integer NOT NULL,
  `packageName` text NOT NULL,
  PRIMARY KEY (`userId`, `packageName`)
);
