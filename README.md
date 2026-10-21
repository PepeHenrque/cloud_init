# Ambiente Cloud-Init com Vagrant

Este projeto cria uma máquina virtual Ubuntu 22.04 LTS com Cloud-Init,
instala Docker e Nginx, configura o usuário `meu-usuario` e publica uma
página HTML personalizada.

## Requisitos

- Vagrant instalado.
- Oracle VirtualBox instalado e funcionando.
- PowerShell no Windows.
- Uma chave SSH Ed25519 no host. A chave privada deve permanecer em
  `%USERPROFILE%\.ssh\id_ed25519` e nunca deve ser adicionada ao repositório.

O arquivo `user-data` contém somente a chave pública correspondente:
`%USERPROFILE%\.ssh\id_ed25519.pub`.

## Arquivos

- `Vagrantfile`: define a VM Ubuntu, a rede privada e o encaminhamento da
  porta 80 para a porta 8080 do host.
- `cloud-init_setup.sh`: instala o Cloud-Init e prepara a fonte NoCloud.
- `user-data`: configura o usuário, os pacotes, a página web e os serviços.

## Configuração realizada

O `user-data`:

1. Atualiza o índice de pacotes com `package_update: true`.
2. Cria `meu-usuario` com shell Bash, grupo `sudo`, `sudo` sem senha e acesso
   por chave SSH.
3. Instala `docker.io` e `nginx`.
4. Cria `/var/www/html/index.html` usando `write_files`.
5. Executa, em `runcmd`, os comandos:

   ```text
   systemctl enable --now nginx
   systemctl enable --now docker
   usermod -aG docker meu-usuario
   ```

6. Registra uma mensagem final com `final_message`.

## Execução

Abra o PowerShell na pasta do projeto:

```powershell
cd "C:\Users\Pedro\Desktop\atividade clous\Cloud-Init-FAP"
vagrant up
```

O `Vagrantfile` encaminha a porta guest `80` para a porta `8080` do host.
Com `auto_correct: true`, o Vagrant escolherá outra porta se a 8080 estiver
ocupada. A porta efetiva pode ser consultada com:

```powershell
vagrant port
```

Como o script prepara o `user-data` durante o provisionamento, reinicie a VM
para que o Cloud-Init leia a fonte NoCloud:

```powershell
vagrant reload
```

## Verificações dentro da VM

O acesso SSH padrão do Vagrant usa a porta encaminhada automaticamente. Para
usar o usuário criado e a chave do Windows:

```powershell
ssh -i "$HOME\.ssh\id_ed25519" -p 2222 meu-usuario@127.0.0.1
```

Dentro da VM, execute:

```bash
cloud-init status --long
id meu-usuario
groups meu-usuario
sudo -n whoami
systemctl is-enabled nginx
systemctl is-active nginx
systemctl is-enabled docker
systemctl is-active docker
getent group docker
stat -c '%A %U:%G %n' /var/www/html/index.html
curl --fail http://127.0.0.1/
```

O resultado esperado é:

- `cloud-init status --long` com status `done` e sem falhas;
- `meu-usuario` presente nos grupos `sudo` e `docker`;
- `sudo -n whoami` retornando `root`;
- Nginx e Docker habilitados e ativos;
- `/var/www/html/index.html` pertencente a `www-data:www-data`, com modo
  `0644`;
- `curl` retornando a página personalizada.

## Verificação pelo navegador

Depois de consultar a porta efetiva com `vagrant port`, acesse:

```text
http://localhost:8080
```

Se o Vagrant tiver escolhido outra porta, substitua `8080` pelo valor exibido
no comando `vagrant port`. Também é possível usar a rede privada em
`http://192.168.56.10`.

## Resultado da execução e evidências

A execução foi realizada em 20 de outubro de 2026. O host tinha Vagrant e
VirtualBox disponíveis durante a execução. A porta 8080 estava ocupada, então
o Vagrant aplicou `auto_correct` e encaminhou a porta guest 80 para a porta
2200 do host.

Resultado das verificações:

- Cloud-Init: `done`, sem erros ou erros recuperáveis;
- usuário: `meu-usuario` criado, com grupos `sudo` e `docker`;
- sudo: `sudo -n whoami` retornou `root`;
- Nginx: habilitado e `active`;
- Docker: habilitado e `active`;
- página: `/var/www/html/index.html` com `0644` e proprietário
  `www-data:www-data`;
- HTTP: `http://localhost:2200/` retornou `200` e a página personalizada.

Os registros dos comandos estão em
[`evidencias/verificacao.txt`](evidencias/verificacao.txt), e a captura da
página está em [`evidencias/02-pagina-web.png`](evidencias/02-pagina-web.png).
A captura visual dos serviços está em
[`evidencias/01-servicos-ativos.png`](evidencias/01-servicos-ativos.png).
Nenhuma chave privada foi copiada para o projeto.

## Limpeza

Para remover a VM quando os testes terminarem:

```powershell
vagrant destroy -f
```
