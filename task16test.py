import os

file_name = "task16.asm"
#with open("1.in", "w"):
#    for _ in range(10
for i in range(1, 100):
    os.system(f"rars {file_name} pa tests/{i}.in")
    with open(f"tests/{i}.in", "r") as inp:
        lines = inp.readlines()
        lines.sort()
        with open(f"tests/{i}.in.sorted", "r") as out:
            for line_in, line_out in zip(lines, out):
                assert line_in == line_out
