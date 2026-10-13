#!/bin/bash
# benchmark.sh — IO-bound тест (Вариант 1)
# Синхронная запись/чтение мелких блоков 4 KB



TEST_DIR="/tmp/io_bench"
mkdir -p "$TEST_DIR"


echo "[1/2] Writing 100MB in 4KB blocks (sync)..."
dd if=/dev/zero of="$TEST_DIR/testfile" bs=4k count=25600 oflag=dsync 2>&1

# --- Чтение: тот же файл, очищаем кэш  ---
echo "[2/2] Reading 100MB in 4KB blocks..."
sync
# Попытка очистить page cache 
echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || echo "(drop_caches skipped — no permission)"

dd if="$TEST_DIR/testfile" of=/dev/null bs=4k iflag=direct 2>&1

# --- Очистка ---
rm -rf "$TEST_DIR"

echo "=== End IO Workload ==="