require 'pg'

def execute(sql)
  conn = PG::Connection.open(:dbname => 'zoo2')
  query_result = conn.exec(sql).values
  conn.close

  query_result
end
