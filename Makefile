SOURCES = test/runtests.cpp \
          test/fake_serial.cpp \
          test/mock_arduino.cpp \
          libraries/dsm2_tx/dsm2_tx.cpp \
          libraries/dsm2_tx/raw_input.cpp \
          libraries/dsm2_tx/trim.cpp \
          libraries/dsm2_tx/interpolated_curve.cpp \
          libraries/dsm2_tx/expo_curve.cpp

OBJECTS := $(addsuffix .o, $(addprefix .build/, $(basename $(SOURCES))))
DEPFILES := $(subst .o,.dep, $(subst .build/,.deps/, $(OBJECTS)))
TESTCPPFLAGS = -D_TEST_ -Ilibraries/dsm2_tx -Itest
CPPDEPFLAGS = -MMD -MP -MF .deps/$(basename $<).dep
RUNTEST := $(if $(COMSPEC), runtests.exe, runtests)

all: runtests

.build/%.o: %.cpp
	mkdir -p .deps/$(dir $<)
	mkdir -p .build/$(dir $<)
	$(COMPILE.cpp) $(TESTCPPFLAGS) $(CPPDEPFLAGS) -o $@ $<

runtests: $(OBJECTS)
	$(CC) $(OBJECTS) -lstdc++ -o $@

clean:
	@rm -rf .deps/ .build/ $(RUNTEST)

-include $(DEPFILES)
