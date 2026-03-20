# 🚀 Reverse Proxy Infrastructure (NGINX)

A hands-on DevOps project demonstrating how to build a **Reverse Proxy and Load Balancer** using **NGINX on Linux**.

---

## 📌 Overview

This project simulates how production systems handle incoming traffic using a reverse proxy.

NGINX receives client requests and routes them to backend services based on rules.

---

## 🧱 Architecture Diagram

```
        ┌─────────────┐
        │   Client    │
        └─────┬───────┘
              │
              ▼
      ┌───────────────┐
      │     NGINX     │
      │ Reverse Proxy │
      └─────┬─────────┘
            │
    ┌───────┴────────┐
    ▼                ▼
Backend 1       Backend 2
 (8081)          (8082)
```

---

## 🖼️ Request Flow

```
Client Request → NGINX → Route Decision → Backend → Response → Client
```

---

## ⚙️ Tech Stack

* Linux (Ubuntu / WSL)
* NGINX
* Bash (netcat-based backend servers)

---

## 🔁 Features

* Reverse proxy routing (`/app1`, `/app2`)
* Load balancing (`/loadbalance`)
* Domain-based routing (`app1.local`, `app2.local`)
* Security headers
* Logging (access & error logs)
* Custom error pages

---

## 🖼️ Example Outputs

### 🔹 Backend 1

```
Hello from Backend 1
```

### 🔹 Backend 2

```
Hello from Backend 2
```

### 🔹 Load Balancing

```
Hello from Backend 1
Hello from Backend 2
Hello from Backend 1
```

---

## 🚀 Getting Started

### 1. Install Dependencies

```bash
sudo apt update
sudo apt install nginx netcat-openbsd -y
```

---

### 2. Start Backend Servers

```bash
./backend/app1/server.sh
./backend/app2/server.sh
```

---

### 3. Configure NGINX

```bash
sudo rm -f /etc/nginx/sites-enabled/default

sudo cp nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/
```

Edit main config:

```bash
sudo nano /etc/nginx/nginx.conf
```

Add inside `http {}`:

```nginx
upstream backend_servers {
    server 127.0.0.1:8081;
    server 127.0.0.1:8082;
}
```

---

### 4. Restart NGINX

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🧪 Usage

```bash
curl http://localhost/app1
curl http://localhost/app2
curl http://localhost/loadbalance
```

---

## 🌐 Optional: Domain Routing

Edit `/etc/hosts`:

```
127.0.0.1 app1.local
127.0.0.1 app2.local
```

---

## 📊 Logs

* `logs/access.log`
* `logs/error.log`

---

## 📁 Project Structure

```
reverse-proxy-infrastructure/
├── nginx/
├── backend/
├── logs/
├── setup.sh
├── README.md
└── .gitignore
```

---

## 🧠 Learnings

* Reverse proxy architecture
* NGINX configuration structure
* Load balancing basics
* Linux networking fundamentals

---

## 🚀 Future Improvements

* HTTPS (SSL/TLS)
* Rate limiting
* systemd service management
* Health checks

---

## 👨‍💻 Author

**Manvendra Negi**
