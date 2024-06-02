<h1>Instalação do PostgreSQL</h1>
<h2>Versão do S.O. utilizada: Debian 12.5</h2>
<h2>Versão do PostgreSQL utilizada: 16.3</h2>

<br>

**1 - Instale o Curl e os Certificados CA**

```shell
sudo apt-get install curl ca-certificates
```

Este comando instala o Curl, uma ferramenta para transferir dados de ou para um servidor, e os certificados CA necessários para garantir uma comunicação segura.

<br>

**2 - Configurar o Repositório PostgreSQL**


```shell
sudo install -d /usr/share/postgresql-common/pgdg

```


```shell
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

```

```shell
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

```

Esses comandos criam um diretório para os arquivos relacionados ao PostgreSQL e baixam a chave de assinatura necessária para verificar a autenticidade dos pacotes do repositório do PostgreSQL. Em seguida, eles configuram o repositório oficial do PostgreSQL no sistema.

<br>

**3 - Atualizar a lista de pacotes**


```shell
sudo apt-get update

```

Este comando atualiza a lista de pacotes disponíveis nos repositórios configurados no sistema.

<br>

**4 - Instalar o PostgreSQL**


```shell
sudo apt-get -y install postgresql

```

<h6>Pronto o PostgreSQL esta instalado, agora você pode seguir com criação de um cluster e inicialização do servidor, o link a baixo pode lhe ajudar com isso: </h6>

https://github.com/ramos-r29/PostgreSQL/blob/main/01-PostgreSQL-install-debian/02_postgresql_iniciar_cluster.md

<br>

**Fonte:**

https://www.postgresql.org/download/linux/debian/

