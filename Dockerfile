# ─────────────────────────────────────────────────────────────────────────────
# Base image
FROM python:3.11-slim-bookworm
ENV DEBIAN_FRONTEND=noninteractive

# ─────────────────────────────────────────────────────────────────────────────
# Install system dependencies (Tkinter, GUI libs)
RUN apt-get update && apt-get install -y \
    build-essential python3-dev python3-tk \
    libgl1-mesa-glx libglib2.0-0 curl iptables dnsutils openssl \
 && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────────────────────────────────────
# Create non-root user
RUN useradd -ms /bin/bash appuser

# ─────────────────────────────────────────────────────────────────────────────
# App setup
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Give ownership to non-root user
RUN chown -R appuser:appuser /app

# ─────────────────────────────────────────────────────────────────────────────
# Optional: vault passphrase
RUN openssl rand -hex 32 > /app/.vault_pass && \
    echo "export VAULT_PASSPHRASE=$(cat /app/.vault_pass)" > /app/set_env.sh && \
    chmod +x /app/set_env.sh && \
    chown appuser:appuser /app/.vault_pass /app/set_env.sh

# ─────────────────────────────────────────────────────────────────────────────
# Firewall + app launch script
RUN cat <<'EOF' > /app/firewall_start.sh
#!/bin/bash
set -e
source /app/set_env.sh || true

# Apply firewall rules (requires NET_ADMIN capability at runtime)
iptables -F OUTPUT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allow CoinGecko API
for DOMAIN in api.coingecko.com; do
  getent ahosts "$DOMAIN" | awk '/STREAM/ {print $1}' | sort -u | \
    while read ip; do
      [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && iptables -A OUTPUT -d "$ip" -j ACCEPT
    done
done

# Block everything else
iptables -A OUTPUT -j REJECT

# Drop privileges to non-root user
exec su appuser -c "export DISPLAY=:0 && python main.py"
EOF

RUN chmod +x /app/firewall_start.sh

# ─────────────────────────────────────────────────────────────────────────────
# Entrypoint
CMD ["/app/firewall_start.sh"]
