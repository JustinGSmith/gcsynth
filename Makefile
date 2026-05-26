SRC=src/

FLAGS=--no-auto-compile --debug

gcsynth:
	guile ${FLAGS} -L ${SRC} src/gcsynth/gcsynth.scm

util-test:
	guile ${FLAGS} -L ${SRC} test/noisesmith/util-test.scm

gcsynth-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/gcsynth-test.scm

opcodes-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/opcodes-test.scm

instruments-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/instruments-test.scm

event-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/event-test.scm

render-test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/render-test.scm

.PHONY: test
test: util-test gcsynth-test opcodes-test instruments-test event-test render-test

repl:
	guile ${FLAGS} -L ${SRC} --
