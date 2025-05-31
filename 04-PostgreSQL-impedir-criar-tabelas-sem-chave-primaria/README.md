# 🔐 Enforce Primary Key in PostgreSQL

Este arquivo contém uma função e um gatilho (`event trigger`) para PostgreSQL que impede a criação de tabelas sem **chave primária**.

---

## 📌 Por que toda tabela deve ter uma chave primária?

Garantir que todas as tabelas tenham uma **chave primária** é uma das práticas mais fundamentais de design de banco de dados relacional. Aqui estão os principais motivos:

### ✅ 1. Integridade dos Dados
A chave primária assegura que cada linha em uma tabela seja **única e identificável**. Ela evita duplicações e permite definir **relacionamentos** corretos entre tabelas (chaves estrangeiras).

### 🚀 2. Desempenho
PostgreSQL cria automaticamente um **índice** para a chave primária, melhorando significativamente a performance de buscas, junções (joins) e filtros.

### 🔄 3. Replicação Lógica
Na replicação lógica do PostgreSQL, operações `UPDATE` e `DELETE` exigem que cada linha possa ser identificada unicamente. **Sem chave primária ou índice exclusivo**, essas operações **falham durante a replicação**.

> **Sem chave primária = sem replicação lógica confiável.**

---

## 🛡️ Impedindo a criação de tabelas sem chave primária

Abaixo está a função que verifica, ao final de um comando DDL `CREATE TABLE`, se a nova tabela possui chave primária. Se não houver, a criação é **bloqueada** com uma exceção.

### Função

```sql
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

