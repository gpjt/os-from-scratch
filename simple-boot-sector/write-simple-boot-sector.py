import os

sector = b'\x00' * 512

# Endless loop
sector = b'\xe9\xfd\xff'

# Padding
sector += b'\x00' * (512 - 2 - len(sector))

# Mark as boot sector
sector += b'\x55\xaa'

with open(os.path.join(os.path.dirname(__file__), "simple-boot-sector.img"), "wb") as f:
    f.write(sector)
