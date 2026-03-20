#!/usr/bin/env bash
while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nHello from Backend 2" | nc -l -p 8082 -q 1
  sleep 0.1
done
