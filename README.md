# Automatizando instalações

## 📌 Requisitos
- Ambiente Linux (testado em Ubuntu/Debian)

## 🐋 Install Docker
- Baixar o script em algum diretório `install-docker.sh`
- Navegar até o diretório
- Atualizar a permissão: `chmod 755 install-docker.sh`
- Rodar o script (como superusuário): `./install-docker.sh`

## 🛠️ Docker compose
O docker compose contémm as configurações necessárias para a implementação do zabbix rodando em docker.
- Configuração: PostgresDB, Nginx, Zabbix 7.0
- Rodando:
```bash
docker compose up -d 
# ou
docker-compose up -d
```

Caso dê erro no grafana:
- Verificar os logs
```bash
docker logs grafana
```
- Se for o erro for: `Permission denied`, atualize a permissão do diretório:
```bash
docker compose down -v
sudo chown -R 472:472 ./grafana_data
docker compose up -d
```

## 📝 Referências
- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)