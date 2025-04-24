-- Create "accounts" table
CREATE TABLE `accounts` (
  `accountId` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `accountNumber` text NOT NULL
);
-- Create index "accounts_accountNumber" to table: "accounts"
CREATE UNIQUE INDEX `accounts_accountNumber` ON `accounts` (`accountNumber`);
