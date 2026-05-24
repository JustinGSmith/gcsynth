SRC=src/

gcsynth:
	guile -L ${SRC} src/gcsynth/gcsynth.scm

.PHONY: test
test:
	guile -L ${SRC} test/gcsynth/gcsynth-test.scm
