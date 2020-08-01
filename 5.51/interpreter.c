// todo less?
#include <stdio.h>
#include <stdlib.h>
#include "common.h"

/* Exercise 5.51.  Develop a rudimentary implementation of Scheme in C (or some other low-level
language of your choice) by translating the explicit-control evaluator of section 5.4 into C. In
order to run this code you will need to also provide appropriate storage-allocation routines and
other run-time support. */

// -Wall so on
// makefile or script
// several files: evaluator, primitives

//  better?
typedef void *(*impl_func_t)(void);
//typedef impl_func_internal (*impl_func)(void);

//  bool type?
int last_test_result = 0;

//  error checks, names, all args in ()
#define assign(a, b) a = b
#define perform(a) a
#define test(a) last_test_result = (a)
#define branch(a) if (last_test_result) return (a)

// name collisions?
#define save(e) push(e)
#define restore(e) e = pop()

//  types, = NULL, static
lisp_elt_t *exp_reg;
void *env_reg; //?
lisp_elt_t *val_reg;
void *proc_reg; //?
lisp_elt_t *argl_reg;
void *continue_reg; //?
void *unev_reg; //?

char **global_argv = NULL;
bool interactive = true;

// types?
bool is_self_evaluating(lisp_elt_t *e) {
    return (is_number(e) || is_string(e));
}

bool is_variable(lisp_elt_t *e) {
    return is_symbol(e);
}

/*
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
	(list 'cdr cdr)
	(list 'cons cons)
	(list 'null? null?)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)
	; <more primitives>
	))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))
*/

typedef lisp_elt_t *(*primitive_func_t)(lisp_elt_t *);

// how to do it?
//const char *primitive_procedure_names[] = { "car", NULL };
//lisp_elt_t *primitive_car_object[] = { { string, primitive_const.str },  };
//lisp_elt_t *primitive_procedure_objects[] = { { primitive, car }, NULL };

lisp_elt_t *apply_primitive_procedure(lisp_elt_t *proc, lisp_elt_t *args) {
    primitive_func_t impl = NULL;//primitive_implementation(proc); // todo
    return impl(args);
}

// forward decl?
void *read_eval_print_loop(void);

void *print_result(void) {
    perform(announce_output("result: "));
    perform(user_print(val_reg));
    return read_eval_print_loop;
}

void *signal_error(void) {
    perform(user_print(val_reg));
    return read_eval_print_loop;
}

//const?
lisp_elt_t unknown_expression_type_error = { string, "unknown_expression_type_error" };
lisp_elt_t unknown_procedure_type_error = { string, "unknown_procedure_type_error" };
lisp_elt_t ok_const = { string, "unknown_procedure_type_error" };

lisp_elt_t *empty_arglist = nil;

void *unknown_expression_type(void) {
    assign(val_reg, &unknown_expression_type_error);
    return signal_error;
}

void *unknown_procedure_type(void) {
    restore(continue_reg);    // clean up stack (from apply_dispatch)
    assign(val_reg, &unknown_procedure_type_error);
    return signal_error;
}

// forward decl
void *eval_dispatch(void);

void *ev_sequence_last_exp(void) {
    restore(continue_reg);
    return eval_dispatch;
}

// forward decl
void *ev_sequence(void);

void *ev_sequence_continue(void) {
    restore(env_reg);
    restore(unev_reg);
    assign(unev_reg, rest_exps(unev_reg));
    return ev_sequence;
}

void *ev_sequence(void) {
    assign(exp_reg, first_exp(unev_reg));
    test(is_last_exp(unev_reg));
    branch(ev_sequence_last_exp);
    save(unev_reg);
    save(env_reg);
    assign(continue_reg, ev_sequence_continue);
    return eval_dispatch;
}

// forward decl
void *apply_dispatch(void);

void *ev_appl_accum_last_arg(void) {
    restore(argl_reg);
    assign(argl_reg, adjoin_arg(val_reg, argl_reg));
    restore(proc_reg);
    return apply_dispatch;
}

void *ev_appl_last_arg(void) {
    assign(continue_reg, ev_appl_accum_last_arg);
    return eval_dispatch;
}

// forward decl
void *ev_appl_operand_loop(void);

void *ev_appl_accumulate_arg(void) {
    restore(unev_reg);
    restore(env_reg);
    restore(argl_reg);
    assign(argl_reg, adjoin_arg(val_reg, argl_reg));
    assign(unev_reg, rest_operands(unev_reg));
    return ev_appl_operand_loop;
}

void *ev_appl_operand_loop(void) {
    save(argl_reg);
    assign(exp_reg, first_operand(unev_reg));
    test(is_last_operand(unev_reg));
    branch(ev_appl_last_arg);
    save(env_reg);
    save(unev_reg);
    assign(continue_reg, ev_appl_accumulate_arg);
    return eval_dispatch;
}

void *primitive_apply(void) {
    assign(val_reg, apply_primitive_procedure(proc_reg, argl_reg));
    restore(continue_reg);
    return continue_reg;
}

void *compound_apply(void) {
    assign(unev_reg, procedure_parameters(proc_reg));
    assign(env_reg, procedure_environment(proc_reg));
    assign(env_reg, extend_environment(unev_reg, argl_reg, env_reg));
    assign(unev_reg, procedure_body(proc_reg));
    return ev_sequence;
}

void *apply_dispatch(void) {
    test(is_primitive_procedure(proc_reg));
    branch(primitive_apply);
    test(is_compound_procedure(proc_reg));
    branch(compound_apply);
    return unknown_procedure_type;
}

void *ev_self_eval(void) {
    assign(val_reg, exp_reg);
    return continue_reg;
}

void *ev_variable(void) {
    assign(val_reg, lookup_variable_value(exp_reg, env_reg));
    return continue_reg;
}

void *ev_quoted(void) {
    assign(val_reg, text_of_quotation(exp_reg));
    return continue_reg;
}

void *ev_appl_did_operator(void) {
    restore(unev_reg);                 // the operands
    restore(env_reg);
    assign(argl_reg, empty_arglist);
    assign(proc_reg, val_reg);         // the operator
    test(is_no_operands(unev_reg));
    branch(apply_dispatch);
    save(proc_reg);
    return ev_appl_operand_loop;
}

void *ev_assignment_1(void) {
    restore(continue_reg);
    restore(env_reg);
    restore(unev_reg);
    perform(set_variable_value(unev_reg, val_reg, env_reg));
    assign(val_reg, &ok_const);
    return continue_reg;
}

void *ev_assignment(void) {
    assign(unev_reg, assignment_variable(exp_reg));
    save(unev_reg); // save variable for later
    assign(exp_reg, assignment_value(exp_reg));
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_assignment_1);
    return eval_dispatch; // evaluate the assignment value
}

void *ev_definition_1(void) {
    restore(continue_reg);
    restore(env_reg);
    restore(unev_reg);
    perform(define_variable(unev_reg, val_reg, env_reg));
    assign(val_reg, &ok_const);
    return continue_reg;
}

void *ev_definition(void) {
    assign(unev_reg, definition_variable(exp_reg));
    save(unev_reg); // save variable for later
    assign(exp_reg, definition_value(exp_reg));
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_definition_1);
    return eval_dispatch; // evaluate the definition value
}

void *ev_if_consequent(void) {
    assign(exp_reg, if_consequent(exp_reg));
    return eval_dispatch;
}

void *ev_if_alternative(void) {
    assign(exp_reg, if_alternative(exp_reg));
    return eval_dispatch;
}

void *ev_if_decide(void) {
    restore(continue_reg);
    restore(env_reg);
    restore(exp_reg);
    test(is_true(val_reg));
    branch(ev_if_consequent);
    return ev_if_alternative;
}

void *ev_if(void) {
    save(exp_reg); // save expression for later
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_if_decide);
    assign(exp_reg, if_predicate(exp_reg));
    return eval_dispatch; // evaluate the predicate
}

void *ev_lambda(void) {
    assign(unev_reg, lambda_parameters(exp_reg));
    assign(exp_reg, lambda_body(exp_reg));
    assign(val_reg, make_procedure(unev_reg, exp_reg, env_reg));
    return continue_reg;
}

void *ev_begin(void) {
    assign(unev_reg, begin_actions(exp_reg));
    save(continue_reg);
    return ev_sequence;
}

void *ev_application(void) {
    save(continue_reg);
    save(env_reg);
    assign(unev_reg, operands(exp_reg));
    save(unev_reg);
    assign(exp_reg, operator(exp_reg));
    assign(continue_reg, ev_appl_did_operator);
    return eval_dispatch;
}

//  autoformat
void *eval_dispatch(void) {
    test(is_self_evaluating(exp_reg));
    branch(ev_self_eval);
    test(is_variable(exp_reg));
    branch(ev_variable);
    test(is_quoted(exp_reg));
    branch(ev_quoted);
    test(is_assignment(exp_reg));
    branch(ev_assignment);
    test(is_definition(exp_reg));
    branch(ev_definition);
    test(is_if(exp_reg));
    branch(ev_if);
    test(is_lambda(exp_reg));
    branch(ev_lambda);
    test(is_begin(exp_reg));
    branch(ev_begin);
    test(is_application(exp_reg));
    branch(ev_application);
    return unknown_expression_type;
}

void *read_eval_print_loop(void) {
    perform(initialize_stack());
    perform(prompt_for_input("lisp> "));
    assign(exp_reg, read_stdin());
    assign(env_reg, get_global_environment());
    assign(continue_reg, print_result);
    return eval_dispatch;
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
	interactive = false;
	global_argv = &argv[1];
    }
    void *ptr = read_eval_print_loop;
    for (;ptr;) {
	impl_func_t func = (impl_func_t)ptr;
	ptr = func();
    }
    return 0;
}
