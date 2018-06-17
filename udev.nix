{ conifg, ...}:

{
   services.udev.extraRules =
''
## DevBoards

SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="E3C09CF4", GOTO="f4_bmp_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f4gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f4uart"
LABEL="f4_bmp_end"'

SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="B6B4CCCF", GOTO="f4_odrive_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="odrive"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="odriveuart"
LABEL="f4_odrive_end"'

# Pink BMP
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="E4C679BD", GOTO="pink_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="pinkgdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="pinkuart"
LABEL="pink_end"'

# F4 A
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="C0CBA8FB", GOTO="f4_a4_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f4a4gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f4a4uart"
LABEL="f4_a4_end"'

# F4 C
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="C0C7A8F7", GOTO="f4_c4_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f4c4gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f4c4uart"
# CAN4DISCO
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="can4disco-gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="can4disco-uart"
LABEL="f4_c4_end"'

# F4 E
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="C0E1C6A5", GOTO="f4_e4_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f4e4gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f4e4uart"
# REFLOW
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="reflow-gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="reflow-uart"
LABEL="f4_e4_end"'

# F4 Discovery [ch is for chameleon]
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="C0C8ACC6", GOTO="f4ch_bmp_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f4ch-gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f4ch-uart"
LABEL="f4ch_bmp_end"

# F3 Discovery
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="B6E6B711", GOTO="f3_bmp_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f3gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f3uart"
LABEL="f3_bmp_end"

# F3 Discovery (F303)
SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Black Sphere Technologies", ATTRS{serial}!="E2C5ADCD", GOTO="f303_bmp_end"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0660", GROUP="dialout", SYMLINK+="f303gdb"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0660", GROUP="dialout", SYMLINK+="f303uart"
LABEL="f303_bmp_end"

## Machines

# /dev/cnc Shapeoko
SUBSYSTEM=="tty", ATTRS{serial}=="1001101EAE2A9C4652B939C5F5001E81", MODE="0660", GROUP="plugdev", SYMLINK="cnc"

# /dev/mk Kossel Mini
SUBSYSTEM=="tty", ATTRS{serial}=="1100A01CAFB484074F930FA5F5001E40", MODE="0660", GROUP="dialout", SYMLINK="mk"
# /dev/taz TAZ 4
SUBSYSTEM=="tty", ATTRS{serial}=="740353034303511102B1", MODE="0660", GROUP="dialout", SYMLINK="taz"

## Tools

# /dev/ols Open Logic Sniffer
SUBSYSTEM=="tty", ATTRS{product}=="Logic Sniffer CDC-232", MODE="0660", GROUP="plugdev", SYMLINK="ols"
'';
}
