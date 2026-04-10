#!/usr/bin/env bash
# 停止股票分析系统
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PIDFILE="$DIR/.server.pid"

if [ ! -f "$PIDFILE" ]; then
    echo "未找到运行中的服务"
    exit 0
fi

PID=$(cat "$PIDFILE")
if kill -0 "$PID" 2>/dev/null; then
    kill "$PID"
    echo "服务已停止 (PID: $PID)"
else
    echo "进程 $PID 已不存在"
fi
rm -f "$PIDFILE"
