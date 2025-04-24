# Download atlas community edition:
# curl -L https://release.ariga.io/atlas/atlas-community-linux-amd64-latest > atlas && chmod +x atlas
#
# Lint the migration files
# ./tool/atlas migrate lint --env dev
#
# Validate hashes of migration files:
# ./tool/atlas migrate validate --env dev
#
# Create new migration file:
# ./tool/atlas migrate diff <migration-name> --env dev
#
# Note: We have to use ./atlas migrate diff <migration-name> --env dev in CI
#       and check that no new migration files are produced.

env "dev" {
  src = "file://.dart_tool/schema.sql"
  dev = "sqlite://dev?mode=memory"
  migration {
    dir    = "file://migrations"
    # Using golang-migrate format genetates *.up.sql and *.down.sql files!
    format = "golang-migrate"
  }
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}

lint {
  # Only run lint against the latest migration.
  # TODO: Leverage git.base/git.dir to lint against migrations not deployed!
  latest = 1

  non_linear {
    error = true
  }
  data_depend {
    error = true
  }
}
