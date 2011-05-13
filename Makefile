CC = cc

ifeq "$(shell uname -s)" "Darwin"
  CFLAGS = -bundle -undefined dynamic_lookup
else
  CFLAGS = -fPIC -shared -I/usr/local/include -O3 -Wall -Wextra
endif

BUILD = $(CC) $(CFLAGS) $< -o $@

build: src/mwalker.so

src/mwalker.so: src/mwalker.c
	$(BUILD)

doc: doc/mwalker.1.html doc/mwalker.1.roff

doc/mwalker.1.html: doc/mwalker.1.ronn
doc/mwalker.1.roff: doc/mwalker.1.ronn

.SUFFIXES: .ronn .roff
.SUFFIXES: .ronn .html

.ronn.roff:
	ronn -r $<

.ronn.html:
	ronn -5 --style toc $<

clean:
	rm -f src/mwalker.so doc/*roff doc/mwalker.1.html

.PHONY: clean
