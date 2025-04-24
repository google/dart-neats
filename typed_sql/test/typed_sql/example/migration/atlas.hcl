env "typed_sql" {
  # File containing the database schema as SQL DLL statements
  src = "file://schema.sql"
  # Development database to use
  dev = "sqlite://dev?mode=memory"
  # Production database to modify when applying migrations
  url = "sqlite://database.db"
  migration {
    # Location where migration files will be stored
    dir    = "file://migrations"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}

lint {
  latest = 1
  non_linear {
    error = true
  }
  data_depend {
    error = true
  }
}
