#!/usr/bin/env bash
# PaoloMind — instalar.sh v1.1 Autónomo
# PaolosSoftware © 2026

echo "╔══════════════════════════════════╗"
echo "║   PaoloMind — Instalando...      ║"
echo "╚══════════════════════════════════╝"

# ── Carpeta sandbox ──────────────────
mkdir -p ~/sandbox
cd ~/sandbox
echo "[1/5] Carpeta sandbox creada"

# ── Dependencias mínimas ─────────────
echo "[2/5] Instalando dependencias..."
sudo apt-get update -qq || true
sudo apt-get install -y -qq curl wget git \
    python3 python3-pip || true
pip3 install --break-system-packages -q \
    beautifulsoup4 requests yt-dlp || true
echo "      Dependencias listas"

# ── Clonar repo ──────────────────────
echo "[3/5] Descargando PaoloMind..."
rm -rf ~/sandbox/PAOLOSMIND
git clone https://github.com/PaoloGonzalez776/PAOLOSMIND.git \
    ~/sandbox/PAOLOSMIND || true
echo "      Repo descargado"

# ── Instalar binario y datos ─────────
echo "[4/5] Instalando binario..."

BINARIO=~/sandbox/PAOLOSMIND/bin/paolosmind
DATOS=~/sandbox/PAOLOSMIND/data

sudo mkdir -p /opt/paolosmind
sudo mkdir -p /var/paolosmind/{data,logs,memory}

if [ -f "$BINARIO" ]; then
    sudo cp "$BINARIO" /opt/paolosmind/paolosmind
    sudo chmod +x /opt/paolosmind/paolosmind
    sudo ln -sf /opt/paolosmind/paolosmind /usr/local/bin/paolosmind
    echo "      ✅ Binario instalado"
else
    echo "      ⚠️  No se encontro el binario en $BINARIO"
fi

if [ -d "$DATOS" ]; then
    sudo cp "$DATOS"/*.json /var/paolosmind/data/ 2>/dev/null && \
        echo "      ✅ Conocimiento cargado" || true
fi

# ── Registrar como servicio systemd ──
echo "[5/5] Registrando servicio..."
sudo bash -c 'cat > /etc/systemd/system/paolosmind.service << SERVICE
[Unit]
Description=PaoloMind Sistema de Conciencia Artificial
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/opt/paolosmind/paolosmind
WorkingDirectory=/var/paolosmind
StandardOutput=append:/var/paolosmind/logs/paolosmind.log
StandardError=append:/var/paolosmind/logs/paolosmind_error.log
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE'

sudo systemctl daemon-reload || true
sudo systemctl enable paolosmind || true
sudo systemctl start paolosmind || true
echo "      ✅ Servicio registrado y arrancado"

echo ""
echo "╔══════════════════════════════════╗"
echo "║      ✅ Instalacion lista        ║"
echo "╠══════════════════════════════════╣"
echo "║                                  ║"
echo "║  Ver que hace PaoloMind:         ║"
echo "║  journalctl -u paolosmind -f     ║"
echo "║                                  ║"
echo "║  Parar:                          ║"
echo "║  systemctl stop paolosmind       ║"
echo "╚══════════════════════════════════╝"