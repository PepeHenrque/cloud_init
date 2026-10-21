#!/bin/bash
set -e

# Instalar o Cloud-Init
apt-get update
apt-get install -y cloud-init

# Preparar o diretório da fonte NoCloud
mkdir -p /var/lib/cloud/seed/nocloud

# Copiar o user-data disponibilizado pelo Vagrant
install -m 0644 /tmp/user-data \
    /var/lib/cloud/seed/nocloud/user-data

# Criar os metadados da instância
cat > /var/lib/cloud/seed/nocloud/meta-data <<'EOF'
instance-id: devops-lab-001
local-hostname: servidor-devops
EOF

# Configurar explicitamente a fonte NoCloud
cat > /etc/cloud/cloud.cfg.d/99-nocloud.cfg <<'EOF'
datasource:
  NoCloud:
    seedfrom: file:///var/lib/cloud/seed/nocloud/
EOF

# Limpar o estado anterior para permitir nova inicialização
cloud-init clean --logs