#include "common.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#ifdef __GLIBC__
#include <unistd.h>
#include <execinfo.h>
#endif // __GLIBC__

// gc_free
void *gc_alloc(size_t size) {
    void *result = malloc(size);
    ensure(result);
    return result;
}

// call this less often? better error handling
lisp_elt_t *fatal(const char *file, int line, const char *inv) {
    fprintf(stderr, "fatal error: check \"%s\" failed at %s:%i\n", inv, file, line);
#ifdef __GLIBC__
    void *bt_stack[50];
    int size = backtrace(bt_stack, sizeof(bt_stack)/sizeof(*bt_stack));
    backtrace_symbols_fd(bt_stack, size, STDERR_FILENO);
#endif // __GLIBC__
    exit(1); //?
    return NULL;
}

void announce_output(const char *str) {
    if (!interactive)
	return;
    printf("%s", str);
}

void prompt_for_input(const char *str) {
    if (!interactive)
	return;
    printf("%s", str);
    fflush(stdout);
}

// return value -- does it need space after itself in general?
bool user_print_internal(lisp_elt_t *e, bool needs_parens, bool needs_separator) {
    // for printing lists
    if (!e)
	return false;

    if (needs_separator)
	printf(" ");
    
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
	needs_separator = user_print_internal(car(e), true, false);
	user_print_internal(cdr(e), false, needs_separator);
	if (needs_parens) printf(")");
    }
    else {
	ensure(0); //error
    }
    return true;
}

lisp_elt_t *user_print(lisp_elt_t *e) {
    ensure(e); //?
    user_print_internal(e, true, false);
    printf("\n");
    return e;
}

// forward decl
lisp_elt_t *string_to_lisp(char *str, char **next, bool in_list);

lisp_elt_t *elt_or_sublist(lisp_elt_t *elt, char *str, char **next, bool in_list)
{
    if (in_list) {
	ensure(next);
	return cons(elt, string_to_lisp(*next, next, true));
    }
    else {
	return elt;
    }
}

// beware of stack overflow!
lisp_elt_t *string_to_lisp(char *str, char **next, bool in_list)
{
    ensure(str);
    //lisp_elt_t *result = NULL;
    while (str[0]) {
	if (isspace(str[0])) {
	    str++;
	}
	else if (isdigit(str[0])) {
	    lisp_elt_t *elt = gc_alloc(sizeof(lisp_elt_t));
	    // ensure?
	    elt->type = number;
	    elt->num = strtol(str, next, 0);
	    //str = str_end;
	    //result = elt; // todo
	    return elt_or_sublist(elt, str, next, in_list);
	}
	else if (str[0] == '\'') {
	    str++;
	    lisp_elt_t *elt = string_to_lisp(str, &str, in_list);
	    ensure(elt);
	    return make_quoted(elt);
	}
	else if (str[0] == '(') {
	    str++;
	    lisp_elt_t *elt = string_to_lisp(str, &str, true);
	    //ensure(car_elt);
	    //lisp_elt_t *cdr_elt = string_to_lisp(str, &str, true);
	    //ensure(cdr_elt); // no, end of list!
       	    //lisp_elt_t *elt = cons(car_elt, cdr_elt);
	    //ensure(elt);
	    //result = elt; // todo
	    // empty list
	    if (!elt)
		return cons(nil, nil);
	    return elt;
	}
	else if (str[0] == ')') {
	    ensure(next);
	    *next = ++str;
	    return nil;
	}
	else if (str[0] == '"') {
	    char *start = ++str;
	    do {
		ensure(str[0]);
		// skip next symbol
		/*if (str[0] == "\\") {
		  str++;
		  ensure(str[0]);
		  }*/ // todo
		str++;
	    } while (str[0] != '"');
	    str[0] = '\0'; // end
	    str++;

	    lisp_elt_t *elt = gc_alloc(sizeof(lisp_elt_t));
	    // ensure?
	    elt->type = string;
	    elt->str = start;
	    //result = elt; // todo
	    return elt;
	} else {
	    char *start = str;
	    do {
		ensure(str[0]);
		// skip next symbol
		/*if (str[0] == "\\") {
		  str++;
		  ensure(str[0]);
		  }*/ // todo
		str++;
	    } while (isalnum(str[0]));
	    str[0] = '\0'; // end
	    str++;

	    lisp_elt_t *elt = gc_alloc(sizeof(lisp_elt_t));
	    // ensure?
	    elt->type = symbol;
	    elt->sym = start;
	    //result = elt; // todo
	    return elt;
	}
    }
    ensure(0); // ?
    return nil;
}

// GNU readline? name of func? load function is must-have
lisp_elt_t *read_stdin(void) {
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
    //return user_print(string_to_lisp(line, NULL)); // debug
    return string_to_lisp(line, NULL, false);
}

// automatic memory?
lisp_elt_t *stack_mem[2048];
size_t stack_elts = 0;

//  static, (void)
void initialize_stack(void) {
    stack_elts = 0;
}

lisp_elt_t *push(lisp_elt_t *e) {
    ensure(e);
    ensure(stack_elts < (sizeof(stack_mem)/sizeof(*stack_mem)));
    stack_mem[stack_elts++] = e;
    return e;
}

lisp_elt_t *pop() {
    ensure(stack_elts > 0);
    return stack_mem[--stack_elts];
}
