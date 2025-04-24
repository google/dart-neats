CREATE TABLE accounts (
  accountId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  accountNumber TEXT NOT NULL,
  balance REAL NOT NULL DEFAULT 0.0,
  UNIQUE (accountNumber)
);

