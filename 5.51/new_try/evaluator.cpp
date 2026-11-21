#include <stack>
#include <cstdio>
#include <cstdlib>
#include <cstring>

typedef void *(state_t)(void);

state_t initialize_stack,
    read,
    get_global_environment,
    print_result,
    eval_dispatch,
    signal_error,
    setup_environment,
    ev_definition,
    ev_definition_1,
    ev_assignment,
    ev_assignment_1,
    ev_if_decide,
    ev_if_consequent,
    ev_if_alternative,
    ev_sequence,
    ev_sequence_last_exp,
    ev_sequence_continue,
    primitive_apply,
    compound_apply,
    unknown_procedure_type,
    ev_self_eval,
    ev_variable,
    ev_quoted,
    ev_assignment,
    ev_definition,
    ev_if,
    ev_lambda,
    ev_begin,
    ev_application,
    unknown_expression_type,
    ev_appl_did_operator,
    apply_dispatch,
    ev_appl_operand_loop,
    ev_appl_last_arg,
    ev_appl_accumulate_arg,
    ev_appl_accum_last_arg;

bool flag = false;
void *expr, *env, *val, *proc, *argl, *unev;
state_t *cont;

void *unknown_expression_type_error = NULL;
void *unknown_procedure_type_error = NULL;
void *ok = NULL;
void *empty_arglist = NULL;

void *global_environment = NULL;

void prompt_for_input(const char *str);
void announce_output(const char *str);
void user_print(void *);
void define_variable(void *, void *, void *);
void set_variable_value(void *, void *, void *);
void *make_procedure(void *, void *, void *);
void *lookup_variable_value(void *, void *);
void *apply_primitive_procedure(void *, void *);
void *extend_environment(void *, void *, void *);
bool is_self_evaluating(void *);
void *adjoin_arg(void *, void *);

bool is_pair(void *);
bool is_number(void *);
bool is_string(void *);
void *make_string(const char *);
void *make_bool(bool);
char *get_string(void *);
bool is_symbol(void *);
bool is_tagged_list(void *, const char *);

void *cons(void *, void *);
void *car(void *);
void *cdr(void *);
void *cadr(void *);
void *cddr(void *);
void *caadr(void *);
void *caddr(void *);
void *cdadr(void *);
void *cdddr(void *);
void *cadddr(void *);
void *make_list_4(void *, void *, void *, void *);

void *lambda_parameters(void *);
void *lambda_body(void *);
bool is_no_operands(void *);
bool is_last_operand(void *);
void *first_operand(void *);
void *rest_operands(void *);
void *operands(void *);
void *operation(void *);
void *text_of_quotation(void *);
bool is_variable(void *);
bool is_quoted(void *);
bool is_assignment(void *);
bool is_definition(void *);
bool is_if(void *);
bool is_lambda(void *);
bool is_begin(void *);
bool is_application(void *);
void *definition_variable(void *);
void *definition_value(void *);
void *assignment_variable(void *);
void *assignment_value(void *);
void *if_predicate(void *);
void *if_alternative(void *);
void *if_consequent(void *);
void *begin_actions(void *);
void *first_exp(void *);
void *rest_exps(void *);
bool is_true(void *);
bool is_last_exp(void *);
bool is_primitive_procedure(void *);
bool is_compound_procedure(void *);
void *procedure_parameters(void *);
void *procedure_environment(void *);
void *procedure_body(void *);
void *make_lambda(void *, void *);
void *make_begin(void *);

#define go_to(x) return (void *)x
#define test(x) flag = x
#define branch(x) if (flag) go_to(x)

std::stack<void *> the_stack;

void save(void *val)
{
    the_stack.push(val);
}

void *restore()
{
    void *value = the_stack.top();
    the_stack.pop();
    return value;
}

/*void *setup_environment()
{
    void *initial_env = extend-environment(primitive_procedure_names(), primitive_procedure_objects(), the_empty_environment);
    define_variable("true", true, initial_env);
    define_variable("false", false, initial_env);
    return initial_env;
}*/
