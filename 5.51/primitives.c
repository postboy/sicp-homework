#include "common.h"
#include <string.h>

// modify to optimize non-lisp usages like stack

lelt *set_car(lelt *e, lelt *val) {
    ensure(is_pair(e));
    ensure(val);
    e->pair.car = val;
    return e;
}

lelt *set_cdr(lelt *e, lelt *val) {
    ensure(is_pair(e));
    //ensure(val); // ok?
    e->pair.cdr = val;
    return e;
}

// not sure
lelt *cons(lelt *car, lelt *cdr) {
    //ensure(car); // for empty list
    //ensure(cdr); //?
    lelt *result = gc_alloc(sizeof(lelt));
    ensure(result);
    result->type = pair;
    result->pair.car = car;
    result->pair.cdr = cdr;
    return result;
}

lelt *cons_wrapper(lelt *args) {
    // todo: more general and more effective
    lelt *first = car(args);
    ensure(first);
    lelt *second = cadr(args);
    ensure(second);
    return cons(first, second);
}

lelt *car(lelt *e) {
    ensure(is_pair(e));
    return e->pair.car;
}

lelt *cdr(lelt *e) {
    ensure(is_pair(e));
    return e->pair.cdr;
}

lelt *cadr(lelt *e) { return car(cdr(e)); }
lelt *cddr(lelt *e) { return cdr(cdr(e)); }
lelt *caadr(lelt *e) { return car(car(cdr(e))); }
lelt *caddr(lelt *e) { return car(cdr(cdr(e))); }
lelt *cdadr(lelt *e) { return cdr(car(cdr(e))); }
lelt *cdddr(lelt *e) { return cdr(cdr(cdr(e))); }
lelt *cadddr(lelt *e) { return car(cdr(cdr(cdr(e)))); }

bool is_eq(lelt *a, lelt *b) {
    if (!a && !b)
	return true;
    if (!a || !b)
	return false;
    if (a->type != b->type)
	return false; // error?
    if (a->type == string) // todo obarray
	//return (a->str == b->str);
	return !strcmp(a->str, b->str);
    if (a->type == symbol) // todo obarray
	//return (a->sym == b->sym);
	return !strcmp(a->sym, b->sym);
    if (a->type == number)
	return (a->num == b->num);
    if (a->type == pair) // I guess
	return (is_eq(a->pair.car, b->pair.car) && is_eq(a->pair.cdr, b->pair.cdr));
    ensure(false); // error!
    return false;
}

bool is_number(lelt *e) {
    ensure(e);
    return (e->type == number);
}

bool is_string(lelt *e) {
    ensure(e);
    return (e->type == string);
}

bool is_symbol(lelt *e) {
    ensure(e);
    return (e->type == symbol);    
}

bool is_pair(lelt *e) {
    ensure(e);
    return (e->type == pair);    
}
