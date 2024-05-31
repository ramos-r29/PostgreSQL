<h1>Criação e inicialização de um cluster no PostgreSQL</h1>

<h2>Versão do S.O. utilizada : Debian 12.5</h2>
<h2>Versão do PostgreSQL utilizada: PostgreSQL 16.3</h2>


**1 - Criar um diretório onde os dados serão armazenados:**

`sudo mkdir -p /usr/local/pgsql/data`


**2 - Dar permissão ao diretório para usuário postgres:**

`sudo chown -R postgres:postgres /usr/local/pgsql`

 
**3 - Encontrar o executável initidb:**

`find / -name initidb`

**4 - Trocar para usuário postgres:**

`sudo su postgres`


**5 - Iniciar o cluster:**

`/usr/lib/postgresql/16/bin/initdb -D /usr/local/pgsql/data`


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/initdb.png" alt="Saida do comando initidb">

**6 - Verificar se o serviço postgresql esta em execução:**

`service postgresql status`


**7 - Caso o serviço esteja em execução é necessário dar um stop, caso não esteja em execução seguir para o passo seguinte:**

`sudo stop service postgresql`


**8 - Iniciar o servidor:**

`/usr/local/pgsql$ /usr/lib/postgresql/16/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start`


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/pg_ctl.png" alt="Saida do comando pg_ctrl">


<h6>Pronto !!! O cluster esta criado e o servidor PostgreSQL em funcionamento.</h6>

**Fonte:**
<p>https://www.postgresql.org/docs/current/app-initdb.html</p>
<p>https://www.postgresql.org/docs/current/app-pg-ctl.html</p>

