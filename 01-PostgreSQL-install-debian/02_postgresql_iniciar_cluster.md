1 - Criar diretorio onde os dados serão armazenados:

sudo mkdir -p /usr/local/pgsql/data


2 - Dar permissão ao diretorio para usuario postgres

sudo chown -R postgres:postgres /usr/local/pgsql

 
3 - encontrar o executavel initidb

find / -name initidb

4 - troque para usuario postgres

sudo su postgres


4 - iniciar o cluster

/usr/lib/postgresql/16/bin/initdb -D /usr/local/pgsql/data


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/initdb.png" alt="Saida do comando initidb">

5 - Verifique se o serviço postgresql esta em execução

service postgresql status


6 - Caso o serviço esteja em execução é necessario dar um stop, caso não esteja em execução sig para o passo seguinte

sudo stop service postgresql


7 - Start do servidor 

/usr/local/pgsql$ /usr/lib/postgresql/16/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start


<img src="https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/imagens/pg_ctl.png" alt="Saida do comando pg_ctrl">


