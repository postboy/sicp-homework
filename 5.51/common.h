#pragma once

#include <stddef.h>
#include <stdbool.h>

typedef struct {
	/* lelt* */void *car;
	/* lelt* */void *cdr;
} lpair_t;

typedef enum {
	string = 1,
	symbol,
	number,
	pair,
	primitive,
} ltype_t;

typedef enum {
	no_args = 0,
	one_arg,
	two_args,
} apply_variant_t;

typedef struct {
	void *callback;
	apply_variant_t variant;
} primitive_func_t;

typedef struct {
	ltype_t type;
	union {
		const char *str;
		const char *sym;
		int num;
		lpair_t pair;
		primitive_func_t func;
	};
} lelt;

#define empty_list NULL

// evaluator.c

#define state(name) void *name(void)
typedef void *(*impl_func_t)(void);
state(read_eval_print_loop);

// primitives.c

lelt *apply_primitive_procedure(lelt *proc, lelt *args);

lelt *set_car(lelt *e, lelt *val);
lelt *set_cdr(lelt *e, lelt *val);

lelt *cons(lelt *car, lelt *cdr);
lelt *car(lelt *e);
lelt *cdr(lelt *e);

bool is_number(lelt *e);
bool is_string(lelt *e);
bool is_symbol(lelt *e);
bool is_pair(lelt *e);
bool is_primitive_procedure(lelt *e);

bool is_eq(lelt *a, lelt *b);

lelt *plus(lelt *a, lelt *b);
lelt *minus(lelt *a, lelt *b);
lelt *multiply(lelt *a, lelt *b);
lelt *quotient(lelt *a, lelt *b);

// combinations.c

bool is_true(lelt *e);

lelt *cadr(lelt *e);
lelt *cddr(lelt *e);
lelt *caadr(lelt *e);
lelt *caddr(lelt *e);
lelt *cdadr(lelt *e);
lelt *cdddr(lelt *e);
lelt *cadddr(lelt *e);

lelt *make_inv_list(lelt *first, ...);

lelt *append(lelt *a, lelt *b);

//lelt *sequence_to_exp(lelt *e);

// interpreter.c

bool is_self_evaluating(lelt *e);
bool is_variable(lelt *e);

bool is_false(lelt *e);

bool is_definition(lelt *e);
lelt *definition_variable(lelt *e);
lelt *definition_value(lelt *e);

bool is_quoted(lelt *e);
lelt *text_of_quotation(lelt *e);
lelt *make_quoted(lelt *e);

bool is_assignment(lelt *e);
lelt *assignment_value(lelt *e);
lelt *assignment_variable(lelt *e);

bool is_lambda(lelt *e);
lelt *lambda_parameters(lelt *e);
lelt *lambda_body(lelt *e);

bool is_application(lelt *e);
lelt *operator(lelt *e);
lelt *operands(lelt *e);
bool is_no_operands(lelt *e);
bool is_last_operand(lelt *e);
lelt *first_operand(lelt *e);
lelt *rest_operands(lelt *e);
lelt *adjoin_arg(lelt *arg, lelt *arglist);
lelt *make_procedure(lelt *parameters, lelt *body, lelt *env);

bool is_compound_procedure(lelt *e);
lelt *procedure_parameters(lelt *e);
lelt *procedure_body(lelt *e);
lelt *procedure_environment(lelt *e);

bool is_if(lelt *e);
lelt *if_predicate(lelt *e);
lelt *if_consequent(lelt *e);
lelt *if_alternative(lelt *e);

bool is_begin(lelt *e);
lelt *begin_actions(lelt *e);
bool is_last_exp(lelt *e);
lelt *first_exp(lelt *e);
lelt *rest_exps(lelt *e);

lelt *define_variable(lelt *var, lelt *val, lelt *env);
lelt *lookup_variable_value(lelt *var, lelt *env);
lelt *set_variable_value(lelt *var, lelt *val, lelt *env);

lelt *extend_environment(lelt *vars, lelt *vals, lelt *base_env);

void *setup_environment(void);

extern void *global_environment;

// runtime.c

void *gc_alloc(size_t size);

#define ensure(inv) do { if (!(inv)) { fatal(__FILE__, __LINE__, #inv); return NULL; } } while(0)
lelt *fatal(const char *file, int line, const char *inv);

void prompt_for_input(const char *str);
void announce_output(const char *str);
lelt *print(lelt *e);
lelt *read_input(void);

void initialize_stack(void);
lelt *push(lelt *e);
lelt *pop(void);
