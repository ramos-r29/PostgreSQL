<h1>Function para copiar tabela entre schemas levando index e constraints</h1>
<h2>Versão do S.O. utilizada: Debian 12.5</h2>
<h2>Versão do PostgreSQL utilizada: 16.3</h2>

<br>

Copiar uma tabela no `PostgreSQL` pode ser uma tarefa simples, isso pode ser feito com a sintaxe `CREATE AS` se for necessário copiar a tabela com dados pode ser utilizada a sintaxe desta forma:

```sql
CREATE TABLE new_schema.my_table_new AS (SELECT * FROM old_schema.my_table) ;
```

Caso queira realizar a copia apenas da esturura (DDL) sem os dados, pode ser utilizada a sintaxe desta forma:

```sql
CREATE TABLE new_schema.my_table_new AS (SELECT * FROM old_schema.my_table) WITH NO DATA ;
```

No entanto, em ambos os casos, os index e constrainsts não são copiados. Se for preciso copiar uma tabela entre schemas, incluindo index e constrainsts, pode ser usada a 
function  disponível no link abaixo. 

https://github.com/ramos-r29/PostgreSQL/blob/main/03-PostgreSQL-copiar-estruturas-de-tabelas/postgresql_function_copia_tabela.sql
 


