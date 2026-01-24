# taken from vEnhance
import argparse
import os
import subprocess
import sys
import time
from pathlib import Path

TERM_COLOR: dict[str, str] = {}
TERM_COLOR["NORMAL"] = ""
TERM_COLOR["RESET"] = "\033[m"
TERM_COLOR["BOLD"] = "\033[1m"
TERM_COLOR["RED"] = "\033[31m"
TERM_COLOR["GREEN"] = "\033[32m"
TERM_COLOR["YELLOW"] = "\033[33m"
TERM_COLOR["BLUE"] = "\033[34m"
TERM_COLOR["MAGENTA"] = "\033[35m"
TERM_COLOR["CYAN"] = "\033[36m"
TERM_COLOR["BOLD_RED"] = "\033[1;31m"
TERM_COLOR["BOLD_GREEN"] = "\033[1;32m"
TERM_COLOR["BOLD_YELLOW"] = "\033[1;33m"
TERM_COLOR["BOLD_BLUE"] = "\033[1;34m"
TERM_COLOR["BOLD_MAGENTA"] = "\033[1;35m"
TERM_COLOR["BOLD_CYAN"] = "\033[1;36m"
TERM_COLOR["BG_RED"] = "\033[41m"
TERM_COLOR["BG_GREEN"] = "\033[42m"
TERM_COLOR["BG_YELLOW"] = "\033[43m"
TERM_COLOR["BG_BLUE"] = "\033[44m"
TERM_COLOR["BG_MAGENTA"] = "\033[45m"
TERM_COLOR["BG_CYAN"] = "\033[46m"

parser = argparse.ArgumentParser(
    "stomp",
    description="Stomps on your work. A C++/Python/Rust grader for comp programming.",
)
parser.add_argument(
    "program_path",
    help="The C++/Python/Rust program that you're going to use.",
)
parser.add_argument(
    "-o",
    "--stdout",
    help="Show stdout",
    action="store_true",
)
parser.add_argument(
    "-e",
    "--stderr",
    help="Show stderr (for debugging)",
    action="store_true",
)
parser.add_argument(
    "-f",
    "--fast",
    help="Disable compile warnings and runtime checks (C++ only).",
    action="store_true",
)
parser.add_argument(
    "-23",
    help="Use C++23 (default is C++17).",
    action="store_true",
    dest="cpp23",
)

opts = parser.parse_args()

file = Path(opts.program_path)
if not file.exists():
    raise ValueError(f"{file} doesn't exist")

filename = file.name
binary: Path
if filename.endswith(".cpp"):
    PROGRAM_TYPE = "C++"
    binary = file.with_suffix(".out")
elif filename.endswith(".py"):
    PROGRAM_TYPE = "PYTHON"
    binary = Path()  # python is interpreted
elif filename.endswith(".rs"):
    PROGRAM_TYPE = "RUST"
    binary = file.with_suffix("")
else:
    raise ValueError(f"Unsupported file extension: {file}")

os.chdir(file.parent)


if PROGRAM_TYPE == "C++" or PROGRAM_TYPE == "RUST":
    start = time.time()
    if PROGRAM_TYPE == "C++":
        print("⏳ Compiling C++ code...")
        if opts.fast:
            print("🐇 Fast compile enabled.")
            extra_flags = []
        else:
            extra_flags = [
                "-Wall",
                "-Wextra",
                "-Wconversion",
                "-Wshadow",
                "-Wfloat-equal",
                "-fsanitize=address",
                "-fsanitize=undefined",
                "-fmax-errors=1",
                "-g",
            ]
        cpp_standard = 23 if opts.cpp23 else 17
        compile_process = subprocess.run(
            ["g++", "-O2", f"-std=c++{cpp_standard}"]
            + extra_flags
            + [file, "-o", binary]
        )
    else:
        print("⏳ Compiling Rust code...")
        compile_process = subprocess.run(["rustc", "-g", file])

    if compile_process.returncode == 0:
        print(f"🆗 Compilation OK. Elapsed time: {time.time() - start:.4f}")
    else:
        print(f"👿 {TERM_COLOR['BOLD_YELLOW']}COMPILATION FAILED{TERM_COLOR['RESET']}")
        sys.exit(1)

any_failed = False
for input_file_path in sorted(Path("tests").glob("*.input")):
    stdout_path = input_file_path.with_suffix(".stdout")
    stderr_path = input_file_path.with_suffix(".stderr")
    answer_path = input_file_path.with_suffix(".answer")

    print("-" * 60)
    print(f"🎬 {TERM_COLOR['BOLD_CYAN']}{input_file_path}{TERM_COLOR['RESET']}")
    with (
        open(input_file_path) as input_file,
        open(stdout_path, "w") as stdout_file,
        open(stderr_path, "w") as stderr_file,
    ):
        if PROGRAM_TYPE == "PYTHON":
            command = ["python", file]
        else:
            command = [str(binary.resolve())]

        start = time.time()
        process = subprocess.run(
            command,
            stdin=input_file,
            stdout=stdout_file,
            stderr=stderr_file,
        )

    if opts.stderr:
        print(TERM_COLOR["YELLOW"], end="")
        with open(stderr_path) as stderr_file:
            print(stderr_file.read(), end="")
        print(TERM_COLOR["RESET"], end="")
    if opts.stdout:
        print(TERM_COLOR["GREEN"], end="")
        with open(stdout_path) as stdout_file:
            print(stdout_file.read(), end="")
        print(TERM_COLOR["RESET"], end="")

    if process.returncode != 0:
        print(
            f"💥 {TERM_COLOR['BOLD_RED']}CRASHED{TERM_COLOR['RESET']} "
            f"{input_file_path}: return-code={process.returncode}"
        )
        any_failed = True
    elif answer_path.exists():
        diff_process = subprocess.run(
            ["delta", "-s", stdout_path, answer_path],
            capture_output=True,
        )
        if diff_process.returncode == 0:
            print(
                f"✅ {TERM_COLOR['BOLD_GREEN']}PASSED{TERM_COLOR['RESET']} ",
                end="",
            )
        else:
            print(diff_process.stdout.decode().strip())
            print(
                f"❌ {TERM_COLOR['BOLD_RED']}FAILED{TERM_COLOR['RESET']} ",
                end="",
            )
            any_failed = True
        print(
            f"test case {input_file_path}, elapsed time: {time.time() - start:.4f}",
        )
    elif any_failed:
        print(f"🤷 {answer_path} doesn't exist, and an earlier test failed")
    else:
        print(f"📜 Saving {answer_path} since no existing answer was given")
        subprocess.call(["cp", stdout_path, answer_path])
