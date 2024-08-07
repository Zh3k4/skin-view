.POSIX:

include config.mk

VERSION = 0.4.1

CFLAGS = \
	--std=c11 -pedantic \
	-Os \
	-Wall -Wextra -Wshadow -Wconversion -Werror \
	-D_XOPEN_SOURCE=700
LDFLAGS = -s

OBJ = src/main.o

$(TARGET): $(OBJ)
	@printf 'CCLD\t%s\n' '$@'
	@$(CC) $(LDFLAGS) -o $@ $(OBJ) $(LIBS)

$(BUNDLE): src/bundle.c
	@printf 'CCLD\t%s\n' '$@'
	@$(CC) -o $@ $<

src/bundle.h: $(BUNDLE)
	@printf 'BUNDLE\t%s\n' '$@'
	@./$(BUNDLE)

src/main.o: src/bundle.h

.SUFFIXES:
.SUFFIXES: .c .o

.c.o:
	@printf 'CC\t%s\n' '$@'
	@$(CC) $(CFLAGS) $(INCLUDE) -c -o $@ $<

clean:
	rm -f $(TARGET) $(BUNDLE) src/bundle.h $(OBJ)

dist: $(TARGET)
	mkdir -p skin-view-$(VERSION)
	cp -t skin-view-$(VERSION) -r \
		$(TARGET) resources
	$(ARCHIVE) skin-view-$(VERSION)$(ARCHIVE_EXT) skin-view-$(VERSION)
	rm -rf skin-view-$(VERSION)
