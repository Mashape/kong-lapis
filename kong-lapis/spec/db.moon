
import assert_env from require "kong-lapis.environment"

truncate_tables = (...) ->
  db = require "kong-lapis.db"

  assert_env "test", for: "truncate_tables"
  tables = for t in *{...}
    switch type(t)
      when "table"
        t\table_name!
      when "nil"
        error "nil passed to truncate tables, perhaps a bad reference?"
      else
        t

  -- truncate is slow, so delete is used instead
  -- db.truncate unpack tables
  for table in *tables
    db.delete table

drop_tables = (...) ->
  db = require "kong-lapis.db"

  assert_env "test", for: "drop_tables"

  names = for t in *{...}
    db.escape_identifier if type(t) == "table"
      t\table_name!
    else
      t

  return unless next names
  db.query "drop table if exists " ..  table.concat names, ", "

{ :truncate_tables, :drop_tables }