CREATE OR REPLACE FUNCTION copia_tabela(p_old_schema TEXT, p_old_table TEXT , p_new_schema TEXT, p_data BOOL)
RETURNS void  
LANGUAGE plpgsql
AS $$
DECLARE
    p_idx TEXT ;
    p_new_tb TEXT ;
    p_old_tb TEXT ;
    p_query_fk TEXT ;
BEGIN
    p_new_tb := p_new_schema||'.'||p_old_table ;
    p_old_tb := p_old_schema||'.'||p_old_table ;
    EXECUTE 'CREATE SCHEMA IF NOT EXISTS '||p_new_schema ;
    EXECUTE 'DROP TABLE IF EXISTS '||p_new_tb;
    -- CRIAR TABELA E IMPORTAR DADOS
    IF p_data = TRUE
    THEN
        EXECUTE 'CREATE TABLE IF NOT EXISTS '||p_new_tb||' AS (SELECT * FROM '||p_old_tb||')' ;
    ELSE
        EXECUTE 'CREATE TABLE IF NOT EXISTS '||p_new_tb||' AS (SELECT * FROM '||p_old_tb||') WITH NO DATA' ;
    END IF ;
    -- COPIA PK DA TABELA ORIGINAL
    EXECUTE (
                SELECT
                    'ALTER TABLE '||p_new_tb||' ADD PRIMARY KEY ('||string_agg(DISTINCT b.column_name, ', ')||')'
                FROM
                    information_schema.table_constraints AS a
                        LEFT JOIN information_schema.constraint_column_usage AS b
                            ON a.constraint_name = b.constraint_name
                WHERE
                    a.constraint_type = 'PRIMARY KEY'
                    AND a.table_schema = p_old_schema
                    AND a.table_name = p_old_table						  
            ) ;
    -- COPIA FKs DA TABELA ORIGINAL
    FOR p_query_fk IN (
                    SELECT DISTINCT
                        'ALTER TABLE '||p_new_tb||' ADD CONSTRAINT '||b.constraint_name||' FOREIGN KEY ('||string_agg(b.column_name, ', ')||') REFERENCES '||b.table_schema||'.'||b.table_name||' ('||string_agg(b.column_name, ', ')||')'
                    FROM information_schema.table_constraints AS a
                            LEFT JOIN information_schema.constraint_column_usage AS b
                                ON a.constraint_name = b.constraint_name
                    WHERE
                        a.constraint_type = 'FOREIGN KEY'
                        AND a.table_schema = p_old_schema
                        AND a.table_name = p_old_table
                    GROUP BY
                        b.constraint_name
                        , b.table_schema
                        , b.table_name
                )
    LOOP
        EXECUTE p_query_fk ;
    END LOOP ;
    -- COPIA INDEX DA TABELA ORIGINAL
    FOR p_idx IN  (
                    SELECT DISTINCT
                        substring(indexdef FROM 1 FOR  position(' ON ' IN indexdef) + 3)||p_new_schema||substring(indexdef FROM position('.' IN indexdef) FOR length(indexdef) - (POSITION('.' IN indexdef) - 2)) 
                    FROM
                        pg_catalog.pg_indexes
                    WHERE
                        tablename = p_old_table
                        AND schemaname = p_old_schema
                        AND indexdef !~ 'UNIQUE'
                )
    LOOP
        EXECUTE p_idx;
    END LOOP ;
END ;
$$ ;
