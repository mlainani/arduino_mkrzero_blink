LDSCRIPT = samd21g18a_flash.ld
STARTUP = startup_samd21.o system_samd21.o
PTYPE=__SAMD21G18A__

OBJS=$(STARTUP) main.o

# Tools
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as

ELF=$(notdir $(CURDIR)).elf

LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m0 -Wl,--gc-sections

CFLAGS+= -mcpu=cortex-m0 -mthumb -g
CFLAGS+= -I ./include -I ./cmsis -I .
CFLAGS+= -D$(PTYPE)

$(ELF): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

# compile and generate dependency info

%.o:    %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o:    %.s
	$(AS) $< -o $@

clean:
	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) $(CLEANOTHER)

debug:  $(ELF)
	arm-none-eabi-gdb -iex "target extended-remote localhost:3333" $(ELF)

# pull in dependencies

-include        $(OBJS:.o=.d)
