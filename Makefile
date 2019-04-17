ICXX = icpc
GCXX = g++

ICXXFLAGS=-O2 -xCORE-AVX512 -qopt-zmm-usage=high -DSoA -DOMP_SIMD -DAligned
GCXXFLAGS=-O3 -march=native -ffast-math 
ICXXOMPFLAG = -qopenmp
GCXXOMPFLAG = -fopenmp
IOPTFLAGS = -g -qopt-report=5 -qopt-report-phase=vec -inline-level=0 -qopt-report-filter="nbody.cc,56-169" -qopt-report-file=$@.optrpt
GOPTFLAGS = -g 

IOBJECTS = nbody.oicc
GOBJECTS = nbody.ogcc

TARGET=app-ICC app-GCC


.SUFFIXES: .oicc .cc .ogcc 

all: $(TARGET) instructions

%-ICC: $(IOBJECTS)
	$(info )
	$(info Linking the ICC executable:)
	$(ICXX) $(ICXXFLAGS) $(ICXXOMPFLAG) -o $@ $(IOBJECTS)

%-GCC: $(GOBJECTS)
	$(info )
	$(info Linking the GCC executable:)
	$(GCXX) $(GCXXFLAGS) $(GCXXOMPFLAG) -o $@ $(GOBJECTS)

.cc.oicc:
	$(info )
	$(info Compiling a ICC object file:)
	$(ICXX) -c $(ICXXFLAGS) $(ICXXOMPFLAG) $(IOPTFLAGS) -o "$@" "$<"

.cc.ogcc:
	$(info )
	$(info Compiling a GCC object file:)
	$(GCXX) -c $(GCXXFLAGS) $(GCXXOMPFLAG) $(GOPTFLAGS) -o "$@" "$<"

instructions:
	$(info )
	$(info TO EXECUTE THE APPLICATION: )
	$(info "make run-icc" to run the Intel compiled application)
	$(info "make run-gcc" to run the GNU compiled application)
	$(info )

run-icc: app-ICC
	./app-ICC 65536

run-gcc: app-GCC
	./app-GCC 65536

clean:
	rm -f $(IOBJECTS) $(GOBJECTS) $(TARGET) *.optrpt
