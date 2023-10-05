src = src.c
out = out

make:
	# bear makes the compile_commands.json
	bear -- gcc -Wall -ansi -pedantic-errors -o $(out) $(src)

run: make
	./$(out)

