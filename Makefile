SRC=src/

FLAGS=--no-auto-compile --debug

basics-1.wav: src/composition/basics-1.scm
	guile ${FLAGS} -L src src/composition/basics-1.scm > basics-1.csd
	csound basics-1.csd
gcsynth:
	guile ${FLAGS} -L ${SRC} src/gcsynth/gcsynth.scm

util-test:
	guile ${FLAGS} -L ${SRC} test/noisesmith/util-test.scm

gcsynth-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/gcsynth-test.scm

opcodes-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/opcodes-test.scm

render-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/render-test.scm

.PHONY: test
test: util-test gcsynth-test opcodes-test render-test

repl:
	guile ${FLAGS} -L ${SRC} -L . --

clean:
	rm -f test.csd test.aif
