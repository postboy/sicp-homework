#include "common.h"

lisp_elt_t quote_const = { symbol, "quote" };
lisp_elt_t set_const = { symbol, "set!" };
lisp_elt_t define_const = { symbol, "define" };
lisp_elt_t lambda_const = { symbol, "lambda" };
lisp_elt_t if_const = { symbol, "if" };
lisp_elt_t true_const = { symbol, "true" };
lisp_elt_t false_const = { symbol, "false" };
lisp_elt_t begin_const = { symbol, "begin" };
lisp_elt_t primitive_const = { symbol, "primitive" };
lisp_elt_t procedure_const = { symbol, "procedure" };

bool is_false(lisp_elt_t *e) {
    return is_eq(e, &false_const);
}

bool is_true(lisp_elt_t *e) {
    return !is_eq(e, &false_const);
}

// consts etc
bool is_tagged_list(lisp_elt_t *e, lisp_elt_t *tag) {
    return is_pair(e) && is_eq(car(e), tag);
}

bool is_quoted(lisp_elt_t *e) { return is_tagged_list(e, &quote_const); }
lisp_elt_t *text_of_quotation(lisp_elt_t *e) { return cadr(e); }
lisp_elt_t *make_quoted(lisp_elt_t *e) {
    // list?
    //return cons(&quote_const, e); // many errors
    return cons(&quote_const, cons(e, nil));
}

// exp as variable?
bool is_assignment(lisp_elt_t *e) { return is_tagged_list(e, &set_const); }
lisp_elt_t *assignment_value(lisp_elt_t *e) { return cadr(e); }
lisp_elt_t *assignment_variable(lisp_elt_t *e) { return caddr(e); }

bool is_lambda(lisp_elt_t *e) { return is_tagged_list(e, &lambda_const); }
lisp_elt_t *lambda_parameters(lisp_elt_t *e) { return cadr(e); }
lisp_elt_t *lambda_body(lisp_elt_t *e) { return cddr(e); }

lisp_elt_t *make_lambda(lisp_elt_t *parameters, lisp_elt_t *body) {
    // list?
    return cons(&lambda_const, cons(parameters, body));
}

bool is_definition(lisp_elt_t *e) { return is_tagged_list(e, &define_const); }

lisp_elt_t *definition_variable(lisp_elt_t *e) {
    if (is_symbol(cadr(e)))
	return cadr(e);
    else
	return caadr(e);
}

lisp_elt_t *definition_value(lisp_elt_t *e) {
    if (is_symbol(cadr(e)))
	return caddr(e);
    else
	return make_lambda(cdadr(e), cddr(e));
}

bool is_if(lisp_elt_t *e) { return is_tagged_list(e, &if_const); }
lisp_elt_t *if_predicate(lisp_elt_t *e) { return cadr(e); }
lisp_elt_t *if_consequent(lisp_elt_t *e) { return caddr(e); }

lisp_elt_t *if_alternative(lisp_elt_t *e) {
    if (cdddr(e))
	return cadddr(e);
    else
	return &false_const;
}

lisp_elt_t *make_if(lisp_elt_t *predicate, lisp_elt_t *consequent, lisp_elt_t *alternative) {
    // list?
    return cons(&if_const, cons(predicate, cons(consequent, cons(alternative, nil))));
}

bool is_begin(lisp_elt_t *e) { return is_tagged_list(e, &begin_const); }
lisp_elt_t *begin_actions(lisp_elt_t *e) { return cdr(e); }
bool is_last_exp(lisp_elt_t *e) { return (!cdr(e)); }
lisp_elt_t *first_exp(lisp_elt_t *e) { return car(e); }
lisp_elt_t *rest_exps(lisp_elt_t *e) { return cdr(e); }
lisp_elt_t *make_begin(lisp_elt_t *e) { return cons(&begin_const, e); }

lisp_elt_t *sequence_to_exp(lisp_elt_t *e) {
    if (!e)
	return nil;
    if (is_last_exp(e))
	return first_exp(e);
    return make_begin(e);
}

bool is_application(lisp_elt_t *e) { return is_pair(e); }
lisp_elt_t *operator(lisp_elt_t *e) { return car(e); }
lisp_elt_t *operands(lisp_elt_t *e) { return cdr(e); }
bool is_no_operands(lisp_elt_t *e) { return !e; }
bool is_last_operand(lisp_elt_t *e) { return !cdr(e); }
lisp_elt_t *first_operand(lisp_elt_t *e) { return car(e); }
lisp_elt_t *rest_operands(lisp_elt_t *e) { return cdr(e); }

// more efficient?
lisp_elt_t *append(lisp_elt_t *a, lisp_elt_t *b) {
    if (!a)
	return b;
    return cons(car(a), append(cdr(a), b));
}

lisp_elt_t *adjoin_arg(lisp_elt_t *arg, lisp_elt_t *arglist) {
    // list?
    return append(arglist, cons(arg, nil));
}

lisp_elt_t *make_procedure(lisp_elt_t *parameters, lisp_elt_t *body, lisp_elt_t *env) {
    //list?
    return cons(&procedure_const, cons(parameters, cons(body, cons(env, nil))));
}

bool is_primitive_procedure(lisp_elt_t *e) { return is_tagged_list(e, &primitive_const); }
bool is_compound_procedure(lisp_elt_t *e) { return is_tagged_list(e, &procedure_const); }
lisp_elt_t *procedure_parameters(lisp_elt_t *e) { return cadr(e); }
lisp_elt_t *procedure_body(lisp_elt_t *e) { return caddr(e); }
lisp_elt_t *procedure_environment(lisp_elt_t *e) { return cadddr(e); }

void *the_empty_environment = nil;

// type?
void *enclosing_environment(void *e) { return cdr(e); }
void *first_frame(void *e) { return car(e); }
void *make_frame(void *vars, void *vals) { return cons(vars, vals); }
void *frame_variables(void *frame) { return car(frame); }

void *frame_values(void *frame) { return cdr(frame); }

void *add_binding_to_frame(void *var, void *val, void *frame) {
    set_car(frame, cons(var, car(frame)));
    set_cdr(frame, cons(val, cdr(frame)));
    return frame;
}

void *define_variable(void *var, void *val, void *env) {
    void *frame = first_frame(env);
    ensure(frame);
    void *vars = frame_variables(frame);
    void *vals = frame_values(frame);
scan:
    if (!vars)
	return add_binding_to_frame(var, val, frame);
    if (is_eq(var, car(vars)))
	return set_car(vals, val);
    vars = cdr(vars);
    vals = cdr(vals);
    goto scan;    
}

lisp_elt_t *lookup_variable_value(lisp_elt_t *e, lisp_elt_t *e2) {return NULL;}

lisp_elt_t *set_variable_value(lisp_elt_t *e, lisp_elt_t *e2, lisp_elt_t *e3) {return NULL;}

lisp_elt_t *extend_environment(lisp_elt_t *e, lisp_elt_t *e2, lisp_elt_t *e3) {return NULL;}

void *setup_environment(void) {
    void *initial_env = NULL;//extend_environment(primitive_proc_names, primitive_proc_objects, the_empty_environment); // todo
    //define_variable(true_const.str, &true_const, initial_env); // ?
    //define_variable(false_const.str, &false_const, initial_env); //?
    return initial_env;
}

void *get_global_environment(void) {
    /*static*/ void *the_global_environment = setup_environment();
    return the_global_environment;
}
