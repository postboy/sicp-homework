/* Exercise 5.51.  Develop a rudimentary implementation of Scheme in C (or some other low-level
language of your choice) by translating the explicit-control evaluator of section 5.4 into C. In
order to run this code you will need to also provide appropriate storage-allocation routines and
other run-time support. */

#include <stdio.h>
#include <stdlib.h>
#include "common.h"

// -Wall so on
// makefile or script
// several files: evaluator, primitives

//  bool type?
int last_test_result = 0;

//  error checks, names, all args in ()
#define assign(a, b) a = b
#define perform(a) a
#define test(a) last_test_result = (a)
#define branch(a) if (last_test_result) return (a)
#define go_to(x) return x
#define state(name) static void *name(void)
typedef void *(*impl_func_t)(void);

#define save(e) push(e)
#define restore(e) e = pop()

//  types, = NULL, static
lelt *exp_reg;
void *env_reg; //?
lelt *val_reg;
void *proc_reg; //?
lelt *argl_reg;
void *continue_reg; //?
void *unev_reg; //?

char **global_argv = NULL;
bool interactive = true;

// types?
bool is_self_evaluating(lelt *e) {
    return (is_number(e) || is_string(e));
}

bool is_variable(lelt *e) {
    return is_symbol(e);
}

typedef lelt *(*primitive_func_t)(lelt *);

primitive_func_t primitive_implementation(lelt *e) { return (primitive_func_t)cadr(e)->func; }

lelt *apply_primitive_procedure(lelt *proc, lelt *args) {
    primitive_func_t impl = primitive_implementation(proc);
    return impl(args);
}

// forward decl
state(read_eval_print_loop);

state(print_result)
{
    perform(announce_output("result: "));
    perform(user_print(val_reg));
    go_to(read_eval_print_loop);
}

state(signal_error)
{
    perform(user_print(val_reg));
    go_to(read_eval_print_loop);
}

//const?
lelt unknown_expression_type_error = { string, "unknown_expression_type_error" };
lelt unknown_procedure_type_error = { string, "unknown_procedure_type_error" };
lelt ok_const = { string, "ok" };

lelt *empty_arglist = NULL;

state(unknown_expression_type)
{
    assign(val_reg, &unknown_expression_type_error);
    go_to(signal_error);
}

state(unknown_procedure_type)
{
    restore(continue_reg);    // clean up stack (from apply_dispatch)
    assign(val_reg, &unknown_procedure_type_error);
    go_to(signal_error);
}

// forward decl
state(eval_dispatch);

state(ev_sequence_last_exp)
{
    restore(continue_reg);
    go_to(eval_dispatch);
}

// forward decl
state(ev_sequence);

state(ev_sequence_continue)
{
    restore(env_reg);
    restore(unev_reg);
    assign(unev_reg, rest_exps(unev_reg));
    go_to(ev_sequence);
}

state(ev_sequence)
{
    assign(exp_reg, first_exp(unev_reg));
    test(is_last_exp(unev_reg));
    branch(ev_sequence_last_exp);
    save(unev_reg);
    save(env_reg);
    assign(continue_reg, ev_sequence_continue);
    go_to(eval_dispatch);
}

// forward decl
state(apply_dispatch);

state(ev_appl_accum_last_arg)
{
    restore(argl_reg);
    assign(argl_reg, adjoin_arg(val_reg, argl_reg));
    restore(proc_reg);
    go_to(apply_dispatch);
}

state(ev_appl_last_arg)
{
    assign(continue_reg, ev_appl_accum_last_arg);
    go_to(eval_dispatch);
}

// forward decl
state(ev_appl_operand_loop);

state(ev_appl_accumulate_arg)
{
    restore(unev_reg);
    restore(env_reg);
    restore(argl_reg);
    assign(argl_reg, adjoin_arg(val_reg, argl_reg));
    assign(unev_reg, rest_operands(unev_reg));
    go_to(ev_appl_operand_loop);
}

state(ev_appl_operand_loop)
{
    save(argl_reg);
    assign(exp_reg, first_operand(unev_reg));
    test(is_last_operand(unev_reg));
    branch(ev_appl_last_arg);
    save(env_reg);
    save(unev_reg);
    assign(continue_reg, ev_appl_accumulate_arg);
    go_to(eval_dispatch);
}

state(primitive_apply)
{
    assign(val_reg, apply_primitive_procedure(proc_reg, argl_reg));
    restore(continue_reg);
    go_to(continue_reg);
}

state(compound_apply)
{
    assign(unev_reg, procedure_parameters(proc_reg));
    assign(env_reg, procedure_environment(proc_reg));
    assign(env_reg, extend_environment(unev_reg, argl_reg, env_reg));
    assign(unev_reg, procedure_body(proc_reg));
    go_to(ev_sequence);
}

state(apply_dispatch)
{
    test(is_primitive_procedure(proc_reg));
    branch(primitive_apply);
    test(is_compound_procedure(proc_reg));
    branch(compound_apply);
    go_to(unknown_procedure_type);
}

state(ev_self_eval)
{
    assign(val_reg, exp_reg);
    go_to(continue_reg);
}

state(ev_variable)
{
    assign(val_reg, lookup_variable_value(exp_reg, env_reg));
    go_to(continue_reg);
}

state(ev_quoted)
{
    assign(val_reg, text_of_quotation(exp_reg));
    go_to(continue_reg);
}

state(ev_appl_did_operator)
{
    restore(unev_reg);                 // the operands
    restore(env_reg);
    assign(argl_reg, empty_arglist);
    assign(proc_reg, val_reg);         // the operator
    test(is_no_operands(unev_reg));
    branch(apply_dispatch);
    save(proc_reg);
    go_to(ev_appl_operand_loop);
}

state(ev_assignment_1)
{
    restore(continue_reg);
    restore(env_reg);
    restore(unev_reg);
    perform(set_variable_value(unev_reg, val_reg, env_reg));
    assign(val_reg, &ok_const);
    go_to(continue_reg);
}

state(ev_assignment)
{
    assign(unev_reg, assignment_variable(exp_reg));
    save(unev_reg); // save variable for later
    assign(exp_reg, assignment_value(exp_reg));
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_assignment_1);
    go_to(eval_dispatch); // evaluate the assignment value
}

state(ev_definition_1)
{
    restore(continue_reg);
    restore(env_reg);
    restore(unev_reg);
    perform(define_variable(unev_reg, val_reg, env_reg));
    assign(val_reg, &ok_const);
    go_to(continue_reg);
}

state(ev_definition)
{
    assign(unev_reg, definition_variable(exp_reg));
    save(unev_reg); // save variable for later
    assign(exp_reg, definition_value(exp_reg));
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_definition_1);
    go_to(eval_dispatch); // evaluate the definition value
}

state(ev_if_consequent)
{
    assign(exp_reg, if_consequent(exp_reg));
    go_to(eval_dispatch);
}

state(ev_if_alternative)
{
    assign(exp_reg, if_alternative(exp_reg));
    go_to(eval_dispatch);
}

state(ev_if_decide)
{
    restore(continue_reg);
    restore(env_reg);
    restore(exp_reg);
    test(is_true(val_reg));
    branch(ev_if_consequent);
    go_to(ev_if_alternative);
}

state(ev_if)
{
    save(exp_reg); // save expression for later
    save(env_reg);
    save(continue_reg);
    assign(continue_reg, ev_if_decide);
    assign(exp_reg, if_predicate(exp_reg));
    go_to(eval_dispatch); // evaluate the predicate
}

state(ev_lambda)
{
    assign(unev_reg, lambda_parameters(exp_reg));
    assign(exp_reg, lambda_body(exp_reg));
    assign(val_reg, make_procedure(unev_reg, exp_reg, env_reg));
    go_to(continue_reg);
}

state(ev_begin)
{
    assign(unev_reg, begin_actions(exp_reg));
    save(continue_reg);
    go_to(ev_sequence);
}

state(ev_application)
{
    save(continue_reg);
    save(env_reg);
    assign(unev_reg, operands(exp_reg));
    save(unev_reg);
    assign(exp_reg, operator(exp_reg));
    assign(continue_reg, ev_appl_did_operator);
    go_to(eval_dispatch);
}

state(eval_dispatch)
{
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
    go_to(unknown_expression_type);
}

state(read_eval_print_loop)
{
    perform(initialize_stack());
    perform(prompt_for_input("lisp> "));
    assign(exp_reg, read_input());
    assign(env_reg, get_global_environment());
    assign(continue_reg, print_result);
    go_to(eval_dispatch);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
	interactive = false;
	global_argv = &argv[1];
    }
    impl_func_t func = read_eval_print_loop;
    while (func) {
	func = (impl_func_t)func();
    }
    return 0;
}
