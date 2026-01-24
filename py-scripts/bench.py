import argparse
import os
import subprocess
import time

parser = argparse.ArgumentParser(
    description="Benchmark execution time over multiple trials."
)

parser.add_argument("command", type=str)
opts = parser.parse_args()

runs = 10
total = 0
cwd = os.getcwd()

for i in range(runs):
    start = time.time()
    subprocess.run(opts.command, shell=True, cwd=cwd, capture_output=True, check=True)
    duration = time.time() - start
    print(f"{i}: {duration:.3f}")
    total += duration

print(f"Total: {total:.3f} seconds")
print(f"Average: {total / runs:.3f} seconds")
