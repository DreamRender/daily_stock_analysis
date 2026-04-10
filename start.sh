#!/usr/bin/env bash
# 后台启动股票分析系统
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

PIDFILE="$DIR/.server.pid"
mkdir -p "$DIR/logs"

# 检查是否已在运行
if [ -f "$PIDFILE" ]; then
    OLD_PID=$(cat "$PIDFILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "服务已在运行 (PID: $OLD_PID)"
        echo "如需重启请先执行: bash stop.sh"
        exit 1
    else
        rm -f "$PIDFILE"
    fi
fi

# 激活虚拟环境
source "$DIR/.venv/bin/activate"

# 后台启动
nohup python main.py --serve > /dev/null 2>&1 &
PID=$!
echo "$PID" > "$PIDFILE"

echo "服务已启动 (PID: $PID)"
echo "日志: tail -f $DIR/logs/app.log"
echo "停止: bash stop.sh"
