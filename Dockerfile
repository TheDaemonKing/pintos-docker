FROM ubuntu:latest
ENV TZ=Indian/Maldives
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y qemu-system-i386 build-essential perl gcc gdb git sed 

RUN cd /root && git clone git://pintos-os.org/pintos-anon pintos

RUN sed -i 's_GDBMACROS=/usr/class/cs140/pintos/pintos/src/misc/gdb-macros_GDBMACROS=/root/pintos/src/misc/gdb-macros_g' /root/pintos/src/utils/pintos-gdb
RUN sed -i 's_LOADLIBES_LDLIBS_g' /root/pintos/src/utils/Makefile
RUN sed -i 's_#include <stropts.h>_//#include <stropts.h>_g' /root/pintos/src/utils/squish-pty.c
RUN sed -i 's_#include <stropts.h>_//#include <stropts.h>_g' /root/pintos/src/utils/squish-unix.c
RUN sed -i '288s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '289s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '290s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '291s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '292s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '293s_^_//_g' /root/pintos/src/utils/squish-pty.c

RUN cd /root/pintos/src/utils && ls -l && pwd && make

RUN sed -i 's_--bochs_--qemu_g' /root/pintos/src/threads/Make.vars

RUN cd /root/pintos/src/threads && make

RUN sed -i 's_$sim = "bochs" if_$sim = "qemu" if_g' /root/pintos/src/utils/pintos
RUN sed -i '257s+kernel.bin+/root/pintos/src/threads/build/kernel.bin+g' /root/pintos/src/utils/pintos
RUN sed -i '362s+loader.bin+/root/pintos/src/threads/build/loader.bin+g' /root/pintos/src/utils/Pintos.pm