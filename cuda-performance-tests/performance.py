import torch, time

print("CUDA:", torch.cuda.is_available())
print("Device:", torch.cuda.get_device_name(0))

n = 8192
x = torch.randn(n, n, device='cuda')

torch.cuda.synchronize()
t0 = time.time()
y = x @ x
torch.cuda.synchronize()

print("Time:", time.time() - t0)



import torch, time

print("torch:", torch.__version__)
print("torch cuda:", torch.version.cuda)
print("cuda available:", torch.cuda.is_available())
print("device:", torch.cuda.get_device_name(0))

for n in [4096, 8192, 12288]:
    x = torch.randn(n, n, device="cuda", dtype=torch.float16)
    torch.cuda.synchronize()

    for _ in range(5):
        y = x @ x
    torch.cuda.synchronize()

    t0 = time.perf_counter()
    y = x @ x
    torch.cuda.synchronize()
    dt = time.perf_counter() - t0

    tflops = (2 * n**3) / dt / 1e12
    print(f"{n}x{n} fp16: {dt:.4f}s, {tflops:.2f} TFLOPS")
