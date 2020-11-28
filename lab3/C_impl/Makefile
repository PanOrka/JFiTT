all:
	bison -o calc_y.c -d -v calc.y && \
	flex -o calc_l.c calc.l && \
	gcc -lfl calc_y.c mod_oper.c calc_l.c -o calc

clean:
	rm -f calc*.c calc*.h

cleanall: clean
	rm -f calc calc_y.output
