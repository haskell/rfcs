#	Tools for building the Haskell Report

# tex.hs             -- Program to generate html from verb / hs
# index.hs           -- Program to hyperlink prelude index
# splitAndIndexPgm   -- perl script to convert .hs to .verb

# What is GHC?
GHC = ghc

# What is Lex?
LEX = flex
LEX_OPTS = -t -8

all : verbatim verb-tex4ht run_index

%.c : %.lex
	$(LEX) $(LEX_OPTS) $< > $@ || ( rm -f verbatim.c && exit 1 )

%.o : %.c
	$(CC) -c $< -o $@

verbatim: verbatim.o
	$(CC) -o $@ $^

verb-tex4ht: verb-tex4ht.o
	$(CC) -o $@ $^

run_index: index.hs
	$(GHC) -o run_index index.hs -Wall

clean:
	rm -f verbatim verb-tex4ht run_tex run_index *.o *.hi
