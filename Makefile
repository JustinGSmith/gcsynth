SRC=src/

FLAGS=--no-auto-compile --debug

gcsynth:
	guile ${FLAGS} -L ${SRC} src/gcsynth/gcsynth.scm

.PHONY: test
test:
	guile ${FLAGS} -L ${SRC} test/gcsynth/gcsynth-test.scm

repl:
	guile ${FLAGS} -L ${SRC} --
