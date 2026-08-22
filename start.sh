#!/bin/bash
set -e

java ${JAVA_OPTS:-} -jar app/rmi-server.jar &

echo "Waiting for RMI registry on port 1099..."
for i in $(seq 1 60); do
    if timeout 1 bash -c "</dev/tcp/127.0.0.1/1099" 2>/dev/null; then
        echo "RMI server is ready."
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo "RMI server failed to start within 60s." >&2
        exit 1
    fi
    sleep 1
done

exec java ${JAVA_OPTS:-} -cp "src/main/webapp/WEB-INF/classes:src/main/webapp/WEB-INF/lib/*" web.WebRunner
