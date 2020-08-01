#pragma once

#include <stddef.h>
#include <stdbool.h>

typedef struct {
    /*lisp_elt_t*/void *car;
    /*lisp_elt_t*/void *cdr;
} lisp_pair_t;

// boolean type?
typedef enum {
    string = 1,
    symbol,
    number,
    pair,
} lisp_type_t;

typedef struct {
    lisp_type_t type;
    union {
	/*const*/ char *str;
	/*const*/ char *sym;
	int num;
	lisp_pair_t pair;
    };
} lisp_elt_t;

#define nil NULL

// interpreter.c

char **global_argv;
bool interactive;

// primitives.c

lisp_elt_t *set_car(lisp_elt_t *e, lisp_elt_t *val);
lisp_elt_t *set_cdr(lisp_elt_t *e, lisp_elt_t *val);

lisp_elt_t *cons(lisp_elt_t *car, lisp_elt_t *cdr);
lisp_elt_t *car(lisp_elt_t *e);
lisp_elt_t *cdr(lisp_elt_t *e);

lisp_elt_t *cadr(lisp_elt_t *e);
lisp_elt_t *cddr(lisp_elt_t *e);
lisp_elt_t *caadr(lisp_elt_t *e);
lisp_elt_t *caddr(lisp_elt_t *e);
lisp_elt_t *cdadr(lisp_elt_t *e);
lisp_elt_t *cdddr(lisp_elt_t *e);
lisp_elt_t *cadddr(lisp_elt_t *e);

bool is_eq(lisp_elt_t *a, lisp_elt_t *b);

bool is_number(lisp_elt_t *e);
bool is_string(lisp_elt_t *e);
bool is_symbol(lisp_elt_t *e);
bool is_pair(lisp_elt_t *e);

// evaluator.c

bool is_true(lisp_elt_t *e);

bool is_definition(lisp_elt_t *e);
lisp_elt_t *definition_variable(lisp_elt_t *e);
lisp_elt_t *definition_value(lisp_elt_t *e);

bool is_quoted(lisp_elt_t *e);
lisp_elt_t *text_of_quotation(lisp_elt_t *e);
lisp_elt_t *make_quoted(lisp_elt_t *e);

bool is_assignment(lisp_elt_t *e);
lisp_elt_t *assignment_value(lisp_elt_t *e);
lisp_elt_t *assignment_variable(lisp_elt_t *e);

bool is_lambda(lisp_elt_t *e);
lisp_elt_t *lambda_parameters(lisp_elt_t *e);
lisp_elt_t *lambda_body(lisp_elt_t *e);

bool is_application(lisp_elt_t *e);
lisp_elt_t *operator(lisp_elt_t *e);
lisp_elt_t *operands(lisp_elt_t *e);
bool is_no_operands(lisp_elt_t *e);
bool is_last_operand(lisp_elt_t *e);
lisp_elt_t *first_operand(lisp_elt_t *e);
lisp_elt_t *rest_operands(lisp_elt_t *e);
lisp_elt_t *adjoin_arg(lisp_elt_t *arg, lisp_elt_t *arglist);
lisp_elt_t *make_procedure(lisp_elt_t *parameters, lisp_elt_t *body, lisp_elt_t *env);

bool is_primitive_procedure(lisp_elt_t *e);
bool is_compound_procedure(lisp_elt_t *e);
lisp_elt_t *procedure_parameters(lisp_elt_t *e);
lisp_elt_t *procedure_body(lisp_elt_t *e);
lisp_elt_t *procedure_environment(lisp_elt_t *e);

bool is_if(lisp_elt_t *e);
lisp_elt_t *if_predicate(lisp_elt_t *e);
lisp_elt_t *if_consequent(lisp_elt_t *e);
lisp_elt_t *if_alternative(lisp_elt_t *e);

bool is_begin(lisp_elt_t *e);
lisp_elt_t *begin_actions(lisp_elt_t *e);
bool is_last_exp(lisp_elt_t *e);
lisp_elt_t *first_exp(lisp_elt_t *e);
lisp_elt_t *rest_exps(lisp_elt_t *e);

void *define_variable(void *var, void *val, void *env);
lisp_elt_t *lookup_variable_value(lisp_elt_t *e, lisp_elt_t *e2);
lisp_elt_t *set_variable_value(lisp_elt_t *e, lisp_elt_t *e2, lisp_elt_t *e3);

lisp_elt_t *extend_environment(lisp_elt_t *e, lisp_elt_t *e2, lisp_elt_t *e3);
void *get_global_environment(void);

// runtime.c

void *gc_alloc(size_t size);

#define ensure(inv) do { if (!(inv)) { fatal(__FILE__, __LINE__, #inv); return NULL; } } while(0)
lisp_elt_t *fatal(const char *file, int line, const char *inv);

void prompt_for_input(const char *str);
void announce_output(const char *str);
lisp_elt_t *user_print(lisp_elt_t *e);
lisp_elt_t *read_stdin(void);

void initialize_stack(void);
lisp_elt_t *push(lisp_elt_t *e);
lisp_elt_t *pop();
