import random

for i in range(1, 100):
    with open(f"{i}.in", 'w') as inp:
        for _ in range(random.randint(0, 100)):
            for j in range(random.randint(0, 100)):
                inp.write(chr(random.randint(48, 126)))
            inp.write("\n")

