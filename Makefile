# --------------
# to run this code: 
# make new 
# mpirun -n <number_of_processes> ./diffusion
# ----------------------------------------------------------------------

SHELL       = /bin/sh
TARGET      = diffusion
MPICC       = mpif90
DEBUG       = -C
OPT         = -O3
FFLAGS      = $(OPT) -free $(DEBUG)
CFLAGS      = -O
LD          = $(MPICC)
LDFLAGS     = 
CPP         = /lib/cpp
DEFINE      = 
LIBS        = 

VPATH = ./RCS

.SUFFIXES : .inc .inc,v .f,v .c,v
.f,v.f :
	 co $*.f

.c,v.c :
	 co $*.c

.inc,v.inc :
	 co $*.inc

bindir      = $(HOME)/bin

all: $(TARGET)

OBJS =\
    module_precise.o\
    module_bounds.o\
    module_timings.o\
    module_diag.o\
    module_inputs.o\
    module_setup.o\
    module_output.o\
    module_diffuse.o\
    diffusion.o

diffusion.o: diffusion.f90 module_diffuse.o module_setup.o module_inputs.o module_output.o
	$(MPICC) $(FFLAGS) -c diffusion.f90

module_diffuse.o: module_diffuse.f90 module_precise.o module_setup.o module_output.o
	$(MPICC) $(FFLAGS) -c module_diffuse.f90

module_setup.o: module_setup.f90 module_precise.o
	$(MPICC) $(FFLAGS) -c module_setup.f90

module_output.o: module_output.f90 module_precise.o
	$(MPICC) $(FFLAGS) -c module_output.f90

module_bounds.o: module_bounds.f90 module_precise.o 
	$(MPICC) $(FFLAGS) -c module_bounds.f90

module_inputs.o: module_inputs.f90
	$(MPICC) $(FFLAGS) -c module_inputs.f90

module_precise.o: module_precise.f90
	$(MPICC) $(FFLAGS) -c module_precise.f90

module_timings.o: module_timings.f90
	$(MPICC) $(FFLAGS) -c module_timings.f90

module_diag.o: module_diag.f90
	$(MPICC) $(FFLAGS) -c module_diag.f90

$(TARGET): $(OBJS)
	$(LD) -o $(TARGET) $(LDFLAGS) $(OBJS) $(LIBS)

install: $(TARGET)
	(cp -f $(TARGET) $(bindir))

run: $(TARGET)
	mpirun -n <number_of_processes> $(TARGET)

new: cleanall diffusion

cleanall:
	 rm -f __*.f
	 rm -f $(OBJS)
	 rm -f *.lst
	 rm -f *.mod
	 rm -f *.l
	 rm -f *.L

clean:
	 rm -f __*.f
	 rm -f *.lst
