# Processo VACUUM no PostgreSQL

O comando `VACUUM` no PostgreSQL é usado para recuperar o espaço de armazenamento que foi ocupado por linhas que foram excluídas ou atualizadas. Isso é necessário porque, no PostgreSQL, quando uma linha é excluída ou atualizada, os dados antigos não são removidos imediatamente. Em vez disso, eles são mantidos para permitir que transações em andamento continuem a ver os dados conforme eram no momento em que a transação começou. Isso é conhecido como "MVCC" (Controle de Concorrência MultiVersão).

Existem dois tipos principais de operações `VACUUM`:

## VACUUM

O comando `VACUUM` limpa os dados que não são mais necessários por nenhuma transação. O espaço recuperado é disponibilizado para reutilização por novas linhas de dados dentro da mesma tabela.

Exemplo de uso:

```sql
VACUUM nome_da_tabela;

