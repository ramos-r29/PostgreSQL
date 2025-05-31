# 🔐 Enforce Primary Key in PostgreSQL

---
## Versão do S.O. utilizada: Debian 12.5
## Versão do PostgreSQL utilizada: 16.3
---

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

### Função - Function

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
```

### Gatinho - Event Trigger

```sql
CREATE EVENT TRIGGER tg_enforce_primary_key
  ON ddl_command_end
  EXECUTE FUNCTION public.fn_enforce_primary_key();
``` 

## 📚 Referências

- [PostgreSQL Logical Replication Restrictions](https://www.postgresql.org/docs/current/logical-replication-restrictions.html)  
  Explica as limitações da replicação lógica no PostgreSQL, incluindo a necessidade de uma chave primária ou índice exclusivo para identificar linhas de forma única durante `UPDATE` ou `DELETE`.

- [Por que toda tabela precisa de uma chave primária? – Vertabelo](https://www.vertabelo.com/blog/why-every-table-must-have-a-primary-key/)  
  Um artigo sobre a importância das chaves primárias na modelagem de dados e os riscos de omiti-las.

- [Documentação oficial do PostgreSQL sobre Event Triggers](https://www.postgresql.org/docs/current/event-triggers.html)  
  Referência oficial da funcionalidade de *event triggers*, usada para interceptar comandos DDL e executar lógica personalizada.



## 🧪 Testando

Tente criar uma tabela **sem chave primária**:

```sql
CREATE TABLE teste_sem_pk (
  nome TEXT
);
```


❌ **Erro esperado:**
```pgsql
ERROR: Creating tables without a primary key is not allowed!
```

Agora crie uma com chave primária:

```sql
CREATE TABLE teste_com_pk (
  id SERIAL PRIMARY KEY,
  nome TEXT
);
```
✅ **Resultado esperado**: tabela criada com sucesso.

## 🧩 Considerações

Esta função é ideal para ambientes que exigem rigor na modelagem de dados e replicação consistente. Seu uso é especialmente recomendado em:

- Ambientes com **replicação lógica** ativa
- Sistemas distribuídos ou com múltiplas réplicas
- Pipelines de **CI/CD** que realizam deploys de estruturas de banco
- Equipes que seguem **boas práticas de modelagem relacional**
- Projetos onde a rastreabilidade e integridade dos dados são cruciais

🔒 Impedir a criação de tabelas sem chave primária é uma forma simples e eficaz de garantir qualidade e segurança no schema do banco.



