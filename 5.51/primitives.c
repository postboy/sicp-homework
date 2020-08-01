#include "common.h"

// modify to optimize non-lisp usages like stack

lisp_elt_t *set_car(lisp_elt_t *e, lisp_elt_t *val) {
    ensure(is_pair(e));
    ensure(val);
    e->pair.car = val;
    return e;
}

lisp_elt_t *set_cdr(lisp_elt_t *e, lisp_elt_t *val) {
    ensure(is_pair(e));
    //ensure(val); // ok?
    e->pair.cdr = val;
    return e;
}

// not sure
lisp_elt_t *cons(lisp_elt_t *car, lisp_elt_t *cdr) {
    //ensure(car); // for empty list
    //ensure(cdr); //?
    lisp_elt_t *result = gc_alloc(sizeof(lisp_elt_t));
    ensure(result);
    result->type = pair;
    result->pair.car = car;
    result->pair.cdr = cdr;
    return result;
}

lisp_elt_t *car(lisp_elt_t *e) {
    ensure(is_pair(e));
    return e->pair.car;
}

lisp_elt_t *cdr(lisp_elt_t *e) {
    ensure(is_pair(e));
    return e->pair.cdr;
}

lisp_elt_t *cadr(lisp_elt_t *e) { return car(cdr(e)); }
lisp_elt_t *cddr(lisp_elt_t *e) { return cdr(cdr(e)); }
lisp_elt_t *caadr(lisp_elt_t *e) { return car(car(cdr(e))); }
lisp_elt_t *caddr(lisp_elt_t *e) { return car(cdr(cdr(e))); }
lisp_elt_t *cdadr(lisp_elt_t *e) { return cdr(car(cdr(e))); }
lisp_elt_t *cdddr(lisp_elt_t *e) { return cdr(cdr(cdr(e))); }
lisp_elt_t *cadddr(lisp_elt_t *e) { return car(cdr(cdr(cdr(e)))); }

bool is_eq(lisp_elt_t *a, lisp_elt_t *b) {
    if (a->type != b->type)
	return false; // error?
    if (a->type == string) // ?
	return (a->str == b->str);
    if (a->type == symbol) // ?
	return (a->sym == b->sym);
    if (a->type == number)
	return (a->num == b->num);
    if (a->type == pair) // ?
	return ((a->pair.car == b->pair.car) && (a->pair.cdr == b->pair.cdr));
    ensure(false); // error!
    return false;
}

bool is_number(lisp_elt_t *e) {
    ensure(e);
    return (e->type == number);
}

bool is_string(lisp_elt_t *e) {
    ensure(e);
    return (e->type == string);
}

bool is_symbol(lisp_elt_t *e) {
    ensure(e);
    return (e->type == symbol);    
}

bool is_pair(lisp_elt_t *e) {
    ensure(e);
    return (e->type == pair);    
}
