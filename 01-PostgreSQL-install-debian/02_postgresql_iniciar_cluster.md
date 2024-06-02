<h1>Criação e inicialização de um cluster no PostgreSQL</h1>

<h2>Versão do S.O. utilizada : Debian 12.5</h2>
<h2>Versão do PostgreSQL utilizada: PostgreSQL 16.3</h2>

<br>

**1 - Criar um diretório onde os dados serão armazenados:**

```shell
sudo mkdir -p /usr/local/pgsql/data
```

<br>

**2 - Dar permissão ao diretório para usuário postgres:**

```shell
sudo chown -R postgres:postgres /usr/local/pgsql
```

<br>
 
**3 - Encontrar o executável initdb:**

```shell
find / -name initdb
```

<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/find.png" alt="Saida do comando find">

<br>

**4 - Trocar para usuário postgres:**

```shell
sudo su postgres
```

<br>

**5 - Iniciar o cluster:**

```shell
/usr/lib/postgresql/16/bin/initdb -D /usr/local/pgsql/data
```


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/initdb.png" alt="Saida do comando initidb">


<br>

**6 - Verificar se o serviço postgresql esta em execução:**

```shell
service postgresql status
```

<br>

**7 - Caso o serviço esteja em execução é necessário dar um stop, caso não esteja em execução seguir para o passo seguinte:**

```shell
sudo stop service postgresql
```

<br>

**8 - Iniciar o servidor:**

```shell
/usr/local/pgsql$ /usr/lib/postgresql/16/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start
```


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/pg_ctl.png" alt="Saida do comando pg_ctrl">

É recomendo alterar a senha a senha do usuario postgres, isso pode ser feito pelo client `pslq` com o seguinte comando:

```sql
ALTER USER postgres WITH ENCRYPTED PASSWORD 'nova_senha';
```

<h6>Pronto !!! O cluster esta criado e o servidor PostgreSQL em funcionamento.</h6>

<br>

**Fonte:**
<p>https://www.postgresql.org/docs/current/app-initdb.html</p>
<p>https://www.postgresql.org/docs/current/app-pg-ctl.html</p>

