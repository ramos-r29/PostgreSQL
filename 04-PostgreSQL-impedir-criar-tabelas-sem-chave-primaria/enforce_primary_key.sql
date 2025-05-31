--Criando a função

CREATE OR REPLACE FUNCTION public.fn_enforce_primary_key()
RETURNS event_trigger
LANGUAGE plpgsql
AS $function$
DECLARE
  has_primary_key BOOLEAN;
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag = 'CREATE TABLE'
  ) THEN
    RETURN;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM pg_constraint c
    JOIN pg_event_trigger_ddl_commands() e
      ON e.objid = c.conrelid
    WHERE c.contype = 'p'
  )
  INTO has_primary_key;

  IF NOT has_primary_key THEN
    RAISE EXCEPTION 'Creating tables without a primary key is not allowed!';
  END IF;
END;
$function$;


--Criando o Event Trigger
CREATE EVENT TRIGGER tg_enforce_primary_key
  ON ddl_command_end
  EXECUTE FUNCTION public.fn_enforce_primary_key();


--Teste com erro
CREATE TABLE teste_sem_pk (
  nome TEXT
);

--ERROR: Creating tables without a primary key is not allowed!


--Teste sem erro
CREATE TABLE teste_com_pk (
  id SERIAL PRIMARY KEY,
  nome TEXT
);


