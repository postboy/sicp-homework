#include "common.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#ifdef __GLIBC__
#include <unistd.h>
#include <execinfo.h>
#endif // __GLIBC__

bool interactive = true;
char **global_argv = NULL;

// todo: garbage collector
void *gc_alloc(size_t size)
{
	void *result = malloc(size);
	ensure(result);
	return result;
}

char *gc_strdup(const char *str)
{
	size_t len = strlen(str);
	char *result = malloc(len + 1);
	ensure(result);
	memcpy(result, str, len + 1);
	return result;
}

// call this less often? better error handling
lelt *fatal(const char *file, int line, const char *inv)
{
	fprintf(stderr, "fatal error: check \"%s\" failed at %s:%i\n", inv, file, line);
#ifdef __GLIBC__
	void *bt_stack[50];
	int size = backtrace(bt_stack, sizeof(bt_stack)/sizeof(*bt_stack));
	backtrace_symbols_fd(bt_stack, size, STDERR_FILENO);
#endif // __GLIBC__
	exit(1); // todo
	return NULL;
}

void announce_output(const char *str)
{
	if (!interactive)
		return;
	printf("%s", str);
}

void prompt_for_input(const char *str)
{
	if (!interactive)
		return;
	printf("%s", str);
	fflush(stdout);
}

// return value -- does it need space after itself in general?
bool print_internal(lelt *e, bool needs_parens, bool needs_separator, bool is_cdr)
{
	// for printing lists
	if (!e)
		return false;

	if (needs_separator)
		printf(" ");
	
	if (is_cdr && e->type != pair)
		printf(". ");
	
	if (e->type == string) {
		printf("\"%s\"", e->str);
	}
	else if (e->type == symbol) {
		printf("%s", e->sym);
	}
	else if (e->type == number) {
		printf("%i", e->num);
	}
	else if (e->type == pair) {
		if (needs_parens) printf("(");
		needs_separator = print_internal(car(e), true, false, false);
		print_internal(cdr(e), false, needs_separator, true);
		if (needs_parens) printf(")");
	}
	else {
		ensure(0); // error
	}
	return true;
}

lelt *print(lelt *e)
{
	if (!e)
		printf("()");
	else
		print_internal(e, true, false, false);
	printf("\n");
	return e;
}

lelt *to_lisp(char *str, char **next, bool in_list);

lelt *elt_or_sublist(lelt *elt, char **next, bool in_list)
{
	if (in_list) {
		ensure(next);
		return cons(elt, to_lisp(*next, next, true));
	}
	else {
		return elt;
	}
}

// beware of stack overflow!
lelt *to_lisp(char *str, char **next, bool in_list)
{
	ensure(str);
	//lelt *result = NULL;
	while (str[0]) {
		if (isspace(str[0])) {
			str++;
		}
		else if (isdigit(str[0]) || (str[0] == '-' && isdigit(str[1]))) {
			lelt *elt = gc_alloc(sizeof(lelt));
			elt->type = number;
			elt->num = strtol(str, next, 0);
			//str = str_end;
			//result = elt; // todo
			return elt_or_sublist(elt, next, in_list);
		}
		else if (str[0] == '\'') {
			str++;
			lelt *elt = to_lisp(str, next, false);
			return make_quoted(elt);
		}
		else if (str[0] == '(') {
			str++;
			lelt *elt = to_lisp(str, next, true);
			//ensure(car_elt);
			//lelt *cdr_elt = to_lisp(str, &str, true);
			//ensure(cdr_elt); // no, end of list!
				   //lelt *elt = cons(car_elt, cdr_elt);
			//ensure(elt);
			//result = elt; // todo
			// empty list
			if (!elt)
				return empty_list;
			//return elt;
			return elt_or_sublist(elt, next, in_list);
		}
		else if (str[0] == ')') {
			ensure(next);
			*next = ++str;
			return empty_list;
		}
		else if (str[0] == '"') {
			char *start = ++str;
			while (str[0] && str[0] != '"') {
				// skip next symbol
				/*if (str[0] == "\\") {
				  str++;
				  ensure(str[0]);
				  }*/ // todo
				str++;
			}
			str[0] = '\0';
			//char *copy = gc_strdup(start);
			*next = ++str;

			lelt *elt = gc_alloc(sizeof(lelt));
			elt->type = string;
			elt->str = start;
			//result = elt; // todo
			//return elt;
			return elt_or_sublist(elt, next, in_list);
		} else {
			char *start = str;
			do {
				// skip next symbol
				/*if (str[0] == "\\") {
				  str++;
				  ensure(str[0]);
				  }*/ // todo
				str++;
			} while (str && !isspace(str[0]) && str[0] != ')');
			char tmp = str[0];
			str[0] = '\0'; // end
			char *copy = gc_strdup(start);
			str[0] = tmp;
			*next = str;

			lelt *elt = gc_alloc(sizeof(lelt));
			elt->type = symbol;
			elt->sym = copy;
			//result = elt; // todo
			return elt_or_sublist(elt, next, in_list);
		}
	}
	ensure(0); // ?
	return empty_list;
}

// GNU readline? load function is must-have
lelt *read_input(void)
{
	char *line = NULL;
	if (interactive) {
		char *tmp_line = NULL;
		size_t len = 0;
		ensure(getline(&tmp_line, &len, stdin) != -1);
		// remove trailing newline
		len = strlen(tmp_line);
		tmp_line[len - 1] = '\0';
		line = gc_alloc(len);
		memcpy(line, tmp_line, len);
		free(tmp_line);
	}
	else {
		line = global_argv[0];
		if (!line)
			exit(0);
		global_argv++;
	}
	char *next = line;
	//return user_print(to_lisp(line, NULL)); // debug
	return to_lisp(line, &next, false);
}

lelt *stack_mem[2048];
size_t stack_elts = 0;

void initialize_stack(void)
{
	stack_elts = 0;
}

lelt *push(lelt *e)
{
	ensure(stack_elts < (sizeof(stack_mem)/sizeof(*stack_mem)));
	stack_mem[stack_elts++] = e;
	return e;
}

lelt *pop(void)
{
	ensure(stack_elts > 0);
	return stack_mem[--stack_elts];
}

int main(int argc, char *argv[])
{
	global_environment = setup_environment();
	if (argc > 1) {
		interactive = false;
		global_argv = &argv[1];
	}
	impl_func_t func = read_eval_print_loop;
	while (func) {
		func = func();
	}
	return 0;
}
