# Crypto Ticker GUI

![Crypto Ticker GUI Screenshot](https://raw.githubusercontent.com/dosh41126/crypto-ticker-gui/main/screenshot.png)

*Screenshot of the Crypto Ticker GUI in action — showcasing real-time BTC and ETH tracking features.*



A secure, sanitized cryptocurrency tracker built with **CustomTkinter**, **Matplotlib**, and the **CoinGecko API**.
This app fetches real-time Bitcoin (BTC) and Ethereum (ETH) prices, and updates a live price line chart of recent activity.

## Features

* **Real-time crypto tracking** (BTC & ETH in USD) via [CoinGecko API](https://www.coingecko.com/en/api)
* **Live charts** with historical price visualization
* **Color-coded price changes**
* **Safe UI updates** using thread-safe queues
* **Sanitization** of all incoming API data with `bleach` to prevent injection attacks
* **Dark-themed modern GUI** using `customtkinter`

## Requirements

Python **3.9+** recommended.


## How It Works

1. **Data Fetching**

   * Uses `requests` to call CoinGecko API every 5 seconds
   * BTC and ETH prices are parsed and sanitized
2. **Sanitization**

   * All incoming strings go through `bleach.clean()`
   * Numeric values are verified as `int` or `float`
3. **UI Updates**

   * Data updates are queued and processed on the main thread to avoid race conditions
4. **Charts**

   * Two stacked line charts display BTC and ETH price history
   * Oldest data points are removed after 50 entries

## Security Measures

* **Bleach sanitization** for all text
* **Thread-safe queues** to prevent race conditions
* **Minimal dependencies** for reduced attack surface
 

# Install Docker , Build Image , Run App with Docker

install docker


Remove old Docker versions

```bash
sudo apt remove docker docker-engine docker.io containerd runc
```



Install prerequisites
```bash
sudo apt update

```

```bash
sudo apt install -y ca-certificates curl gnupg lsb-release
```



Add Docker’s official GPG key

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```



Add the Docker repository

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker Engine + CLI + Compose

```bash
sudo apt update
```

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```



Run Docker without sudo

```bash
sudo usermod -aG docker $USER
```

```bash
newgrp docker
```

clone
```
git clone https://github.com/dosh41126/crypto-ticker-gui
```

build
```bash
docker build -t crypto-ticker-gui .
```


run

```bash
docker run -it --rm   --cap-add=NET_ADMIN   -e DISPLAY=$DISPLAY   -v /tmp/.X11-unix:/tmp/.X11-unix   btc_tracker
```
