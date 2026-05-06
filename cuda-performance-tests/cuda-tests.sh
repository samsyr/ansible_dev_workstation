#!/usr/bin/env bash

pip3 install torch --index-url https://download.pytorch.org/whl/cu128

set -euo pipefail

echo "== System =="
lsb_release -a 2>/dev/null || cat /etc/os-release
uname -a
echo

echo "== GPU / PCI binding =="
lspci -nnk | grep -A4 -Ei 'vga|3d|display|nvidia' || true
echo

echo "== Kernel modules =="
lsmod | grep -E 'nvidia|nouveau' || true
echo

echo "== Secure Boot =="
mokutil --sb-state 2>/dev/null || echo "mokutil not installed"
echo

echo "== NVIDIA driver / NVML =="
nvidia-smi || {
  echo "ERROR: nvidia-smi failed"
  exit 1
}
echo

echo "== NVIDIA driver details =="
modinfo nvidia 2>/dev/null | grep -E '^(filename|version|license):' || true
dkms status | grep -i nvidia || true
echo

echo "== CUDA compiler/toolkit =="
command -v nvcc || echo "nvcc not found"
nvcc --version 2>/dev/null || true
echo

echo "== CUDA libraries =="
ldconfig -p | grep -E 'libcuda|libcudart|libcublas|libcudnn' || true
echo

echo "== CUDA env =="
echo "PATH=$PATH"
echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-}"
echo "CUDA_HOME=${CUDA_HOME:-}"
echo

echo "== GPU query =="
nvidia-smi --query-gpu=name,driver_version,cuda_version,pstate,power.draw,power.limit,memory.total,memory.used,utilization.gpu,temperature.gpu --format=csv || true
echo

echo "== PyTorch CUDA test =="
python3 - <<'PY'
import sys, time

try:
    import torch
except Exception as e:
    print("ERROR: could not import torch:", e)
    sys.exit(0)

print("torch:", torch.__version__)
print("torch.version.cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())

if not torch.cuda.is_available():
    sys.exit(0)

dev = torch.device("cuda:0")
print("device:", torch.cuda.get_device_name(0))
print("capability:", torch.cuda.get_device_capability(0))

# Warmup
x = torch.randn(4096, 4096, device=dev)
for _ in range(3):
    y = x @ x
torch.cuda.synchronize()

# Benchmark
n = 8192
x = torch.randn(n, n, device=dev)
torch.cuda.synchronize()

t0 = time.perf_counter()
y = x @ x
torch.cuda.synchronize()
dt = time.perf_counter() - t0

flops = 2 * n**3
tflops = flops / dt / 1e12

print(f"matmul {n}x{n}: {dt:.4f} s")
print(f"approx TFLOPS: {tflops:.2f}")
print("allocated GB:", torch.cuda.memory_allocated() / 1024**3)
print("reserved GB:", torch.cuda.memory_reserved() / 1024**3)
PY

echo
echo "== Recent NVIDIA kernel messages =="
dmesg -T 2>/dev/null | grep -Ei 'nvidia|nvrm|nouveau|secure|firmware' | tail -120 || true

echo
echo "== Verdict hints =="
echo "- GOOD: nvidia-smi works"
echo "- GOOD: lspci says 'Kernel driver in use: nvidia'"
echo "- GOOD: nouveau is not loaded"
echo "- GOOD: PyTorch cuda available = True"
echo "- GOOD: matmul benchmark reports TFLOPS, not seconds of CPU-like slowness"
echo "- BAD: nvidia-smi says 'No devices were found'"
echo "- BAD: nouveau appears loaded"
echo "- BAD: PyTorch cuda available = False"


python3 ./performance.py
