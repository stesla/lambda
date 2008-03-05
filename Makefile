PROGRAM=lambda

OBJS=${shell cat .objs}
XOBJS=${OBJS:.cmo=.cmx}

TEST_OBJS=${shell cat .test_objs}
TEST_XOBJS=${TEST_OBJS:.cmo=.cmx}

# Commands
OCAMLC=ocamlfind ocamlc
OCAMLOPT=ocamlfind ocamlopt
OCAMLDEP=ocamlfind ocamldep
OCAMLOBJS=ocamlobjs
INCLUDES=-I src
TEST_INCLUDES=-package oUnit -linkpkg -I tests
OCAMLFLAGS=${INCLUDES} str.cma
OCAMLOPTFLAGS=${INCLUDES} str.cmxa

# Definitions for building byte-compiled executables
all: bin/byte/${PROGRAM}

test: bin/byte/tests
	bin/byte/tests

bin/byte:
	mkdir -p bin/byte

bin/byte/${PROGRAM}: bin/byte ${OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${OBJS}

bin/byte/tests: INCLUDES += ${TEST_INCLUDES}
bin/byte/tests: bin/byte ${TEST_OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${TEST_OBJS}

# Targets for building native-compiled executables
opt: bin/opt/${PROGRAM}

test-opt: bin/opt/tests
	bin/opt/tests

bin/opt:
	mkdir -p bin/opt

bin/opt/${PROGRAM}: bin/opt ${XOBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${XOBJS}

bin/opt/tests: INCLUDES += ${TEST_INCLUDES}
bin/opt/tests: bin/opt ${TEST_XOBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${TEST_XOBJS}

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.mli.cmi:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.ml.cmx:
	${OCAMLOPT} ${OCAMLOPTFLAGS} -c $<

# Clean up
.PHONY: clean
clean:
	rm -f bin/byte/* bin/opt/*
	find . -name '*.cm[iox]' -exec rm {} \;
	find . -name '*.o' -exec rm {} \;

# Dependencies
.PHONY: depend objs
depend: FIND_COMMAND=find . -name '*.ml' -print -o -name '*.mli' -print
depend: SOURCES=${shell ${FIND_COMMAND} | sed -e s#./##}
depend:
	${OCAMLDEP} ${INCLUDES} -I src -I tests ${SOURCES} > .depend

objs:
	${OCAMLOBJS} src/main.cmo < .depend > .objs
	${OCAMLOBJS} tests/suite.cmo < .depend > .test_objs

include .depend
