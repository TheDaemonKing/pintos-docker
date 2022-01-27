#Feching latest ubuntu image
FROM ubuntu:latest

#following two line is needed to fix tzdata promt fix it's just setting timezone
ENV TZ=Indian/Maldives
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#installing tools for the project
RUN apt-get update && apt-get install -y qemu-system-i386 build-essential perl gcc gdb git sed 

#cloning the rep from original soruce 
RUN cd /root && git clone git://pintos-os.org/pintos-anon pintos

#making required changes 
RUN sed -i 's_GDBMACROS=/usr/class/cs140/pintos/pintos/src/misc/gdb-macros_GDBMACROS=/root/pintos/src/misc/gdb-macros_g' /root/pintos/src/utils/pintos-gdb
RUN sed -i 's_LOADLIBES_LDLIBS_g' /root/pintos/src/utils/Makefile
RUN sed -i 's_#include <stropts.h>_//#include <stropts.h>_g' /root/pintos/src/utils/squish-pty.c
RUN sed -i 's_#include <stropts.h>_//#include <stropts.h>_g' /root/pintos/src/utils/squish-unix.c
RUN sed -i '288s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '289s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '290s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '291s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '292s_^_//_g' /root/pintos/src/utils/squish-pty.c && sed -i '293s_^_//_g' /root/pintos/src/utils/squish-pty.c

#building utils
RUN cd /root/pintos/src/utils && pwd && make

#setting it to use qemu instrad of bochs
RUN sed -i 's_--bochs_--qemu_g' /root/pintos/src/threads/Make.vars

#building threads 
RUN cd /root/pintos/src/threads && make

#setting it to use qemu
RUN sed -i 's_$sim = "bochs" if_$sim = "qemu" if_g' /root/pintos/src/utils/pintos

#removing unnecessary headers and code 
RUN sed -i '257s+kernel.bin+/root/pintos/src/threads/build/kernel.bin+g' /root/pintos/src/utils/pintos
RUN sed -i '362s+loader.bin+/root/pintos/src/threads/build/loader.bin+g' /root/pintos/src/utils/Pintos.pm
