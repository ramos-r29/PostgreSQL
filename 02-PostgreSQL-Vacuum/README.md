# Versão do S.O. utilizada: Debian 12.5
# Versão do PostgreSQL utilizada: 16.3

<br>
<br>

# Processo VACUUM no PostgreSQL

O comando `VACUUM` no PostgreSQL é usado para recuperar o espaço de armazenamento que foi ocupado por tuplas que foram excluídas ou atualizadas. Isso é necessário porque, no PostgreSQL, quando uma tupla é excluída ou atualizada, os dados antigos não são removidos imediatamente. Em vez disso, eles são mantidos para permitir que transações em andamento continuem a ver os dados conforme eram no momento em que a transação começou. Isso é conhecido como "MVCC" (Controle de Concorrência MultiVersão).

As duas operações de `VACUUM` mais comunmente utilizadas são:

## VACUUM

O comando `VACUUM` limpa os dados que não são mais necessários por nenhuma transação. O espaço recuperado é disponibilizado para reutilização por novas linhas de dados dentro da mesma tabela.

Exemplo de uso:

```sql
VACUUM nome_da_tabela;
```

## VACUUM FULL

O comando `VACUUM FULL` vai um passo além do VACUUM regular. Além de limpar os dados antigos, ele também compacta a tabela para liberar espaço não utilizado no sistema de arquivos. Isso pode ser útil se uma tabela tiver diminuído significativamente de tamanho, mas tenha em mente que VACUUM FULL bloqueia a tabela durante sua execução.

Exemplo de uso:
```sql
VACUUM FUL nome_da_tabela;
```

O link do script em shell abaixo auxilia a automalizar as execuções do `VACUUM` em tabelas com alto numero de tuplas mortas.

https://github.com/ramos-r29/PostgreSQL/blob/main/02-PostgreSQL-Vacuum/PostgreSQL_vacuum.sh

Com auxilio do `crontab` pode se realizar o agendado da execução desta tarefa conforme necessidade, abaixo um exemplo no crontab:

```shell
0 2 1 * * /caminho/para/script/PostgreSQL_vacuum.sh
```


No exemplo o script de `VACUUM` será executado todo dia 1 de cada mês as 2h.


**Fonte:**

https://www.postgresql.org/docs/current/sql-vacuum.html

