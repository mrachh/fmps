# Makefile for fmps
#
# This is the main makefile; there are other makefiles in subdirectories,
# but we recommend directly using this makefile for generating
# various interfaces
# Users should not need to edit this makefile (doing so would make it
# hard to stay up to date with repo version). Rather in order to
# change OS/environment-specific compilers and flags, create 
# the file make.inc, which overrides the defaults below (which are 
# for ubunutu linux/gcc system). 

# compiler, and linking from C, fortran

CC=gcc
FC=gfortran

FFLAGS= -fPIC -O2 -funroll-loops -std=legacy -w 
CFLAGS= -std=c99 
CFLAGS+= $(FFLAGS)
CPPFLAGS="-I/usr/local/opt/openblas/include" 

CLINK = -lgfortran -lm -ldl

LIBS = -lm

# flags for MATLAB MEX compilation..
MFLAGS=-compatibleArrayDims -lgfortran -DMWF77_UNDERSCORE1 -lm -ldl   
MWFLAGS=-c99complex -i8 

# location of MATLAB's mex compiler
MEX=mex

# For experts, location of Mwrap executable
MWRAP=../../mwrap/mwrap


# For your OS, override the above by placing make variables in make.inc
-include make.inc


# objects to compile
#
# Common objects

DIRF = src/fmps
OBJSF = $(DIRF)/fmpsrouts.o $(DIRF)/emdyadic.o $(DIRF)/emplanew.o \
	$(DIRF)/emrouts3.o $(DIRF)/emabrot3var.o $(DIRF)/xrecursion.o \
	$(DIRF)/yrecursion.o $(DIRF)/rotviarecur3.o $(DIRF)/framerot.o \
	$(DIRF)/legeexps.o $(DIRF)/dfft.o $(DIRF)/hjfuns3d.o \
	$(DIRF)/cgmres_rel.o $(DIRF)/cbicgstab_rel.o $(DIRF)/prini.o \
	$(DIRF)/prinm.o $(DIRF)/xprini.o $(DIRF)/emfmm3dsph_e2.o \
	$(DIRF)/emfmm3drouts_e2.o $(DIRF)/em3dpartdirecttarg.o \
	$(DIRF)/d3tstrcr.o $(DIRF)/treeplot.o $(DIRF)/h3dterms.o \
	$(DIRF)/helmrouts2.o $(DIRF)/helmrouts2_trunc.o \
	$(DIRF)/h3dmpmpfinal4.o $(DIRF)/h3dmplocfinal4.o \
	$(DIRF)/projections.o $(DIRF)/h3dloclocfinal4.o \
	$(DIRF)/rotprojvar.o $(DIRF)/triahquad.o $(DIRF)/triagauc.o \
	$(DIRF)/triasymq.o $(DIRF)/trirouts.o $(DIRF)/triquadflatlib.o \
	$(DIRF)/trilib.o $(DIRF)/patchmatcflat2.o \
	$(DIRF)/patchmatcquad2.o $(DIRF)/patchmatcana2.o $(DIRF)/rsolid.o \
	$(DIRF)/patchmatc3.o $(DIRF)/dotcross3d.o $(DIRF)/inter3dn.o \
	$(DIRF)/triaselfquad2.o $(DIRF)/triaselftables012.o \
	$(DIRF)/triaselftables3.o $(DIRF)/c8triadam.o $(DIRF)/c9triadam.o \
	$(DIRF)/c28triadam.o $(DIRF)/c29triadam.o $(DIRF)/ortho2eva.o \
	$(DIRF)/ortho2exps2.o $(DIRF)/orthom.o

DIRM = src/muller
OBJSM = $(DIRM)/atritools3.o $(DIRM)/patchmatc3.o $(DIRM)/dotcross3d.o \
	$(DIRM)/inter3dn.o $(DIRM)/rsolid.o $(DIRM)/atrirouts.o \
	$(DIRM)/emdyadic.o $(DIRM)/emplanew.o $(DIRM)/emrouts2.o \
	$(DIRM)/emabrot2.o $(DIRM)/dfft.o $(DIRM)/hjfuns3d.o \
	$(DIRM)/rotviarecur3.o $(DIRM)/yrecursion.o \
	$(DIRM)/xrecursion.o $(DIRM)/triaadap.o \
	$(DIRM)/ctriaadap.o $(DIRM)/triagauc.o $(DIRM)/triasymq.o \
	$(DIRM)/triaselfquad2.o $(DIRM)/triaselftables012.o \
	$(DIRM)/triaselftables3.o $(DIRM)/c8triadam.o \
	$(DIRM)/c9triadam.o $(DIRM)/c28triadam.o \
	$(DIRM)/c29triadam.o $(DIRM)/cgmres_rel.o $(DIRM)/cgmressq_rel.o \
	$(DIRM)/cbicgstab_rel.o $(DIRM)/cqrsolve.o $(DIRM)/legeexps.o \
	$(DIRM)/ortho2eva.o $(DIRM)/ortho2exps2.o $(DIRM)/orthom.o \
	$(DIRM)/prini.o $(DIRM)/prinm.o $(DIRM)/xprini.o



OBJS = $(OBJSF) $(OBJSM) 


.PHONY: usage matlab mex muller

default: usage 

all: matlab

usage:
	@echo "Makefile for fmps. Specify what to make:"
	@echo "  make matlab - compile matlab interfaces"
	@echo "  make muller - generate executable scripts for running muller and mfie codes"
	@echo "  make mex - generate matlab interfaces (for expert users only, requires mwrap)"
	@echo "  make clean - also remove lib, MEX, and demo executables"


# implicit rules for objects (note -o ensures writes to correct dir)
%.o: %.cpp %.h
	$(CXX) -c $(CXXFLAGS) $< -o $@
%.o: %.c %.h
	$(CC) -c $(CFLAGS) $< -o $@
%.o: %.f %.h
	$(FC) -c $(FFLAGS) $< -o $@

LIBNAMEF = libfmps
LIBNAMEM = libmuller
STATICLIBF = $(LIBNAMEF).a
STATICLIBM = $(LIBNAMEM).a

lib: $(STATICLIBF) $(STATICLIBM)

$(STATICLIBF): $(OBJSF) 
	ar rcs $(STATICLIBF) $(OBJSF)
	mv $(STATICLIBF) lib-static/

$(STATICLIBM): $(OBJSM) 
	ar rcs $(STATICLIBM) $(OBJSM)
	mv $(STATICLIBM) lib-static/

# matlab..
MWRAPFILE = fmpslib
GATEWAY = $(MWRAPFILE)

matlab:	$(STATICLIBF) fmps/$(GATEWAY).c 
	$(MEX) -v fmps/$(GATEWAY).c lib-static/$(STATICLIBF) $(MFLAGS) -output fmps/fmpslib $(MEX_LIBS);


mex:  $(STATICLIBF)
	cd fmps;  $(MWRAP) $(MWFLAGS) -list -mex $(GATEWAY) -mb $(MWRAPFILE).mw;\
	$(MWRAP) $(MWFLAGS) -mex $(GATEWAY) -c $(GATEWAY).c $(MWRAPFILE).mw;\
	$(MEX) -v $(GATEWAY).c ../lib-static/$(STATICLIBF) $(MFLAGS) -output $(MWRAPFILE) $(MEX_LIBS); \

muller: $(STATICLIBM) test/muller test/mfie
	cp src/muller/int2-muller muller/
	cp src/muller/int2-mfie muller/

test/mfie:
	$(FC) $(FFLAGS) src/muller/test11c4.f $(OBJSM) -o src/muller/int2-mfie $(LIBS)

test/muller:
	$(FC) $(FFLAGS) src/muller/test12c4.f $(OBJSM) -o src/muller/int2-muller $(LIBS)


clean: objclean

objclean: 
	rm -f $(OBJS) 
