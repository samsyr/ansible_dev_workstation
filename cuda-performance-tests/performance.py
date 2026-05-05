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

