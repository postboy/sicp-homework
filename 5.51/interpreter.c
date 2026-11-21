#include "common.h"

lelt quote_const = { symbol, "quote" };
lelt set_const = { symbol, "set!" };
lelt define_const = { symbol, "define" };
lelt lambda_const = { symbol, "lambda" };
lelt if_const = { symbol, "if" };
lelt true_const = { symbol, "true" };
lelt false_const = { symbol, "false" };
lelt begin_const = { symbol, "begin" };
lelt primitive_const = { symbol, "primitive" };
lelt procedure_const = { symbol, "procedure" };

bool is_self_evaluating(lelt *e)
{
	return (is_number(e) || is_string(e));
}

bool is_variable(lelt *e)
{
	return is_symbol(e);
}

bool is_false(lelt *e)
{
	return is_eq(e, &false_const);
}

bool is_tagged_list(lelt *e, lelt *tag)
{
	return is_pair(e) && is_eq(car(e), tag);
}

bool is_quoted(lelt *e) { return is_tagged_list(e, &quote_const); }
lelt *text_of_quotation(lelt *e) { return cadr(e); }
lelt *make_quoted(lelt *e)
{
	//return cons(&quote_const, e); // many errors
	return cons(&quote_const, cons(e, empty_list));
}

// exp as variable?
bool is_assignment(lelt *e) { return is_tagged_list(e, &set_const); }
lelt *assignment_value(lelt *e) { return cadr(e); }
lelt *assignment_variable(lelt *e) { return caddr(e); }

bool is_lambda(lelt *e) { return is_tagged_list(e, &lambda_const); }
lelt *lambda_parameters(lelt *e) { return cadr(e); }
lelt *lambda_body(lelt *e) { return cddr(e); }

lelt *make_lambda(lelt *parameters, lelt *body)
{
	return cons(&lambda_const, cons(parameters, body));
}

bool is_definition(lelt *e) { return is_tagged_list(e, &define_const); }

lelt *definition_variable(lelt *e)
{
	if (is_symbol(cadr(e)))
		return cadr(e);
	return caadr(e);
}

lelt *definition_value(lelt *e)
{
	if (is_symbol(cadr(e)))
		return caddr(e);
	return make_lambda(cdadr(e), cddr(e));
}

bool is_if(lelt *e) { return is_tagged_list(e, &if_const); }
lelt *if_predicate(lelt *e) { return cadr(e); }
lelt *if_consequent(lelt *e) { return caddr(e); }

lelt *if_alternative(lelt *e)
{
	if (cdddr(e))
		return cadddr(e);
	return &false_const;
}

lelt *make_if(lelt *predicate, lelt *consequent, lelt *alternative)
{
	return cons(&if_const, cons(predicate, cons(consequent, cons(alternative, empty_list))));
}

bool is_begin(lelt *e) { return is_tagged_list(e, &begin_const); }
lelt *begin_actions(lelt *e) { return cdr(e); }
bool is_last_exp(lelt *e) { return !cdr(e); }
lelt *first_exp(lelt *e) { return car(e); }
lelt *rest_exps(lelt *e) { return cdr(e); }
lelt *make_begin(lelt *e) { return cons(&begin_const, e); }

lelt *sequence_to_exp(lelt *e)
{
	if (!e)
		return empty_list;
	if (is_last_exp(e))
		return first_exp(e);
	return make_begin(e);
}

bool is_application(lelt *e) { return is_pair(e); }
lelt *operator(lelt *e) { return car(e); }
lelt *operands(lelt *e) { return cdr(e); }
bool is_no_operands(lelt *e) { return !e; }
bool is_last_operand(lelt *e) { return !cdr(e); }
lelt *first_operand(lelt *e) { return car(e); }
lelt *rest_operands(lelt *e) { return cdr(e); }

// more efficient?
lelt *append(lelt *a, lelt *b)
{
	if (!a)
		return b;
	return cons(car(a), append(cdr(a), b));
}

lelt *adjoin_arg(lelt *arg, lelt *arglist)
{
	return append(arglist, cons(arg, empty_list));
}

lelt *make_procedure(lelt *parameters, lelt *body, lelt *env)
{
	return cons(&procedure_const, cons(parameters, cons(body, cons(env, empty_list))));
}

bool is_primitive_procedure(lelt *e) { return is_tagged_list(e, &primitive_const); }
bool is_compound_procedure(lelt *e) { return is_tagged_list(e, &procedure_const); }
lelt *procedure_parameters(lelt *e) { return cadr(e); }
lelt *procedure_body(lelt *e) { return caddr(e); }
lelt *procedure_environment(lelt *e) { return cadddr(e); }

void *the_empty_environment = empty_list;

lelt *enclosing_environment(lelt *e) { return cdr(e); }
lelt *first_frame(lelt *e) { return car(e); }
lelt *make_frame(lelt *vars, lelt *vals) { return cons(vars, vals); }
lelt *frame_variables(lelt *frame) { return car(frame); }
lelt *frame_values(lelt *frame) { return cdr(frame); }

lelt *add_binding_to_frame(lelt *var, lelt *val, lelt *frame)
{
	set_car(frame, cons(var, car(frame)));
	set_cdr(frame, cons(val, cdr(frame)));
	return frame;
}

lelt *define_variable(lelt *var, lelt *val, lelt *env)
{
	lelt *frame = first_frame(env);
	ensure(frame);
	lelt *vars = frame_variables(frame);
	lelt *vals = frame_values(frame);
scan:
	if (!vars)
		return add_binding_to_frame(var, val, frame);
	if (is_eq(var, car(vars)))
		return set_car(vals, val);
	vars = cdr(vars);
	vals = cdr(vals);
	goto scan;	
}

lelt *lookup_variable_value(lelt *var, lelt *env)
{
env_loop:
	ensure(env != the_empty_environment); // (error "Unbound variable" var)
	lelt *frame = first_frame(env);
	ensure(frame);
	lelt *vars = frame_variables(frame);
	lelt *vals = frame_values(frame);
scan:
	if (!vars) {
		env = enclosing_environment(env);
		goto env_loop;
	}
	if (is_eq(var, car(vars)))
		return car(vals);
	vars = cdr(vars);
	vals = cdr(vals);
	goto scan;
}

lelt *set_variable_value(lelt *var, lelt *val, lelt *env)
{
env_loop:
	ensure(env != the_empty_environment); // (error "Unbound variable -- SET!" var)
	lelt *frame = first_frame(env);
	ensure(frame);
	lelt *vars = frame_variables(frame);
	lelt *vals = frame_values(frame);
scan:
	if (!vars) {
		env = enclosing_environment(env);
		goto env_loop;
	}
	if (is_eq(var, car(vars)))
		return set_car(vals, val);
	vars = cdr(vars);
	vals = cdr(vals);
	goto scan;
}

lelt *extend_environment(lelt *vars, lelt *vals, lelt *base_env)
{
	ensure(vars);
	ensure(vals);
	//(if (= (length vars) (length vals))
	//(if (< (length vars) (length vals))
	//(error "Too many arguments supplied" vars vals)
	//(error "Too few arguments supplied" vars vals))))	
	return cons(make_frame(vars, vals), base_env);
}

lelt cons_name = { symbol, "cons" };
//lisp_pair_t cons_name_pair = { &cons_name, empty_list };
lelt cons_primitive = { primitive, .func = cons_wrapper };
lelt another_pair = { pair, .pair = { &cons_primitive, empty_list } };
lelt cons_object = { pair, .pair = { &primitive_const, &another_pair } };
//lisp_pair_t cons_obj_pair = { &cons_object, empty_list };
//lelt car_name = { symbol, "car" };
//lelt car_object = { primitive, (char *)car };
//lelt cdr_name = { symbol, "cdr" };
//lelt cdr_object = { primitive, (char *)cdr };
lelt primitive_procedure_names = { pair, .pair = { &cons_name, empty_list } };
lelt primitive_procedure_objects = { pair, .pair = { &cons_object, empty_list } };

void *setup_environment(void)
{
	void *initial_env = extend_environment(&primitive_procedure_names, &primitive_procedure_objects, the_empty_environment);
	define_variable(&true_const, &true_const, initial_env);
	define_variable(&false_const, &false_const, initial_env);
	return initial_env;
}

void *global_environment = NULL;
