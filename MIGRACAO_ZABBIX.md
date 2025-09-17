# Procedimento: Migração do Zabbix
Migração do Zabbix 6.0 (Bare Metal) para Zabbix 7.0 (Docker Compose)

<br>

**Autor:** Giovana Pontes Merguizo <br>
**Data:** 17 de setembro de 2025 <br>
**Versão:** 1.0 <br>

## Objetivo
Este documento detalha o processo de migração de uma instância existente do Zabbix 6.0, instalada em um ambiente bare metal com banco de dados PostgreSQL, para uma nova stack de monitoramento baseada em Docker Compose, utilizando Zabbix 7.0, Grafana e PostgreSQL.

## Visão Geral da Arquitetura
**Ambiente de Origem:**
- Servidor: Bare Metal / VM
- Zabbix Server: 6.0 LTS
- Banco de Dados: PostgreSQL 16
- Componentes Adicionais: Zabbix Agent, Zabbix Web

**Ambiente de Destino:**
- Plataforma: Docker e Docker Compose
- Zabbix Server: 7.0
- Banco de Dados: PostgreSQL 16.9
- Componentes Adicionais: Zabbix Agent, Zabbix Web, Grafana

## Pré-requisitos
- Acesso SSH com privilégios `sudo` ao servidor de origem (bare metal).
- Acesso ao servidor de destino com Docker e Docker Compose instalados e funcionando.
- O arquivo docker-compose.yml finalizado e presente no servidor de destino.
- Espaço em disco suficiente em ambos os servidores para o arquivo de backup do banco de dados.

## Estratégia de Migração
A migração será realizada seguindo a estratégia de Backup e Restauração do Banco de Dados. O novo contêiner do Zabbix Server 7.0 é projetado para detectar um banco de dados de uma versão mais antiga (6.0) e executar o processo de atualização do schema automaticamente na primeira inicialização.

## Passo a Passo
### Fase 1: Backup do Ambiente de Origem (Bare Metal)
- Parar o serviços antigos:
```bash
sudo systemctl stop zabbix-server
sudo systemctl stop zabbix-agent
sudo systemctl stop nginx
```
- Executar o Backup do Banco de Dados:
```bash
# Substitua <user> pelo usuário correto do seu banco de dados
pg_dump -h localhost -U <user> -Fc -f zabbix_backup_6.0.dump zabbix
mkdir ~/zabbix_config_backup
cp /etc/zabbix/zabbix_server.conf ~/zabbix_config_backup/
cp -r /usr/lib/zabbix/alertscripts/ ~/zabbix_config_backup/
```
_Obs.: O arquivo zabbix_backup_6.0.dump será criado no diretório atual._

### Fase 2: Preparação do Ambiente de Destino (Docker)
- Ter o .env para as credenciais
Ex.:
```bash
POSTGRES_USER=zabbix
POSTGRES_PASSWORD=password
POSTGRES_DB=zabbix
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
```

- Criar o docker compose
```yaml
vim docker-compose.yml
```

- Iniciar Apenas o Contêiner do Banco de Dados:
```bash
docker compose up -d postgres
```

- Verificar o contêiner (Opcional):
```bash
docker logs -f zabbix-postgres
```

### Fase 3: Restauração e Upgrade
- Copiar o Backup para o Contêiner:
```bash
docker cp zabbix_backup_6.0.dump zabbix-postgres:/tmp/zabbix_backup.dump
```

- Restaurar o Banco de Dados:
```bash
docker exec -it zabbix-postgres pg_restore --clean --if-exists -U zabbix -d zabbix /tmp/zabbix_backup.dump
```

- Iniciar a Stack Completa: Agora, suba todos os serviços.
```bash
docker compose up -d
```

- Verificar o contêiner (Opcional):
```bash
docker logs -f zabbix-server
```

