#include <stack>
#include <cstdio>
#include <cstdlib>

typedef void *(state_t)();

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

void *the_global_environment = NULL;

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

void prompt_for_input(const char *str)
{
  announce_output(str);
}

void announce_output(const char *str)
{
  printf("%s\n", str);
}

void *read()
{
  exit(1);//todo
}

void user_print(void *)
{
  exit(1);//todo
}

//----------------------------

/*(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp)
  (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)   ; formal parameters
                   (cddr exp)))) ; body

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))*/

//----------------------------

void *eval_dispatch()
{
  test(is_self_evaluating(expr));
  branch(ev_self_eval);
  test(is_variable(expr));
  branch(ev_variable);
  test(is_quoted(expr));
  branch(ev_quoted);
  test(is_assignment(expr));
  branch(ev_assignment);
  test(is_definition(expr));
  branch(ev_definition);
  test(is_if(expr));
  branch(ev_if);
  test(is_lambda(expr));
  branch(ev_lambda);
  test(is_begin(expr));
  branch(ev_begin);
  test(is_application(expr));
  branch(ev_application);
  go_to(unknown_expression_type);
}

void *ev_self_eval()
{
  val = expr;
  go_to(cont);
}

void *ev_variable()
{
  val = lookup_variable_value(expr, env);
  go_to(cont);
}

void *ev_quoted()
{
  val = text_of_quotation(expr);
  go_to(cont);
}

void *ev_lambda()
{
  unev = lambda_parameters(expr);
  expr = lambda_body(expr);
  val = make_procedure(unev, expr, env);
  go_to(cont);
}

void *ev_application()
{
  save((void *)cont);
  save(env);
  unev = operands(expr);
  save(unev);
  expr = operation(expr);
  cont = ev_appl_did_operator;
  go_to(eval_dispatch);
}

void *ev_appl_did_operator()
{
  unev = restore(); // the operands
  env = restore();
  argl = empty_arglist;
  proc = val; // the operator
  test(is_no_operands(unev));
  branch(apply_dispatch);
  save(proc);
  go_to(ev_appl_operand_loop);
}

void *ev_appl_operand_loop()
{
  save(argl);
  expr = first_operand(unev);
  test(is_last_operand(unev));
  branch(ev_appl_last_arg);
  save(env);
  save(unev);
  cont = ev_appl_accumulate_arg;
  go_to(eval_dispatch);
}

void *ev_appl_accumulate_arg()
{
  unev = restore();
  env = restore();
  argl = restore();
  argl = adjoin_arg(val, argl);
  unev = rest_operands(unev);
  go_to(ev_appl_operand_loop);
}

void *ev_appl_last_arg()
{
  cont = ev_appl_accum_last_arg;
  go_to(eval_dispatch);
}

void *ev_appl_accum_last_arg()
{
  argl = restore();
  argl = adjoin_arg(val, argl);
  proc = restore();
  go_to(apply_dispatch);
}

void *apply_dispatch()
{
  test(is_primitive_procedure(proc));
  branch(primitive_apply);
  test(is_compound_procedure(proc));  
  branch(compound_apply);
  go_to(unknown_procedure_type);
}

void *primitive_apply()
{
  val = apply_primitive_procedure(proc, argl);
  cont = (state_t *)restore();
  go_to(cont);
}

void *compound_apply()
{
  unev = procedure_parameters(proc);
  env = procedure_environment(proc);
  env = extend_environment(unev, argl, env);
  unev = procedure_body(proc);
  go_to(ev_sequence);
}

void *ev_begin()
{
  unev = begin_actions(expr);
  save((void *)cont);
  go_to(ev_sequence);
}

void *ev_sequence()
{
  expr = first_exp(unev);
  test(is_last_exp(unev));
  branch(ev_sequence_last_exp);
  save(unev);
  save(env);
  cont = ev_sequence_continue;
  go_to(eval_dispatch);
}

void *ev_sequence_continue()
{
  env = restore();
  unev = restore();
  unev = rest_exps(unev);
  go_to(ev_sequence);
}

void *ev_sequence_last_exp()
{
  cont = (state_t *)restore();
  go_to(eval_dispatch);
}

void *ev_if()
{
  save(expr); // save expression for later
  save(env);
  save((void *)cont);
  cont = ev_if_decide;
  expr = if_predicate(expr);
  go_to(eval_dispatch); // evaluate the predicate
}

void *ev_if_decide()
{
  cont = (state_t *)restore();
  env = restore();
  expr = restore();
  test(is_true(val));
  branch(ev_if_consequent);
  go_to(ev_if_alternative);
}

void *ev_if_alternative()
{
  expr = if_alternative(expr);
  go_to(eval_dispatch);
}

void *ev_if_consequent()
{
  expr = if_consequent(expr);
  go_to(eval_dispatch);
}

void *ev_assignment()
{
  unev = assignment_variable(expr);
  save(unev); // save variable for later
  expr = assignment_value(expr);
  save(env);
  save((void *)cont);
  cont = ev_assignment_1;
  go_to(eval_dispatch); // evaluate the assignment value
}

void *ev_assignment_1()
{
  cont = (state_t *)restore();
  env = restore();
  unev = restore();
  set_variable_value(unev, val, env);
  val = ok;
  go_to(cont);
}

void *ev_definition()
{
  unev = definition_variable(expr);
  save(unev); // save variable for later
  expr = definition_value(expr);
  save(env);
  save((void *)cont);
  cont = ev_definition_1;
  go_to(eval_dispatch); // evaluate the definition value
}

void *ev_definition_1()
{
  cont = (state_t *)restore();
  env = restore();
  unev = restore();
  define_variable(unev, val, env);
  val = ok;
  go_to(cont);
}

//----------------------------

void *read_eval_print_loop()
{
  initialize_stack();
  prompt_for_input(";;; EC-Eval input:");
  expr = read();
  env = get_global_environment();
  cont = print_result;
  go_to(eval_dispatch);
}

void *print_result()
{
  announce_output(";;; EC-Eval value:");
  user_print(val);
  go_to(read_eval_print_loop);
}

void *unknown_expression_type()
{
  val = unknown_expression_type_error;
  go_to(signal_error);
}

void *unknown_procedure_type()
{
  cont = (state_t *)restore(); // clean up stack (from apply_dispatch)
  val = unknown_procedure_type_error;
  go_to(signal_error);
}

void *signal_error()
{
  user_print(val);
  go_to(read_eval_print_loop);
}

//----------------------------

int main()
{
  the_global_environment = setup_environment();
  state_t *cur = read_eval_print_loop;
  while (cur)
    cur = (state_t *)cur();
  return 0;
}
