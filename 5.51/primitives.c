#include "common.h"
#include <string.h>

lelt *set_car(lelt *e, lelt *val)
{
	ensure(is_pair(e));
	ensure(val);
	e->pair.car = val;
	return e;
}

lelt *set_cdr(lelt *e, lelt *val)
{
	ensure(is_pair(e));
	ensure(val);
	e->pair.cdr = val;
	return e;
}

lelt *cons(lelt *car, lelt *cdr)
{
    //ensure(car); // todo: why it's not working?
	lelt *result = gc_alloc(sizeof(lelt));
	result->type = pair;
	result->pair.car = car;
	result->pair.cdr = cdr;
	return result;
}

lelt *cons_wrapper(lelt *args)
{
	// todo: more general and more effective
	lelt *first = car(args);
	ensure(first);
	lelt *second = cadr(args);
	ensure(second);
	return cons(first, second);
}

lelt *car(lelt *e)
{
	ensure(is_pair(e));
	return e->pair.car;
}

lelt *cdr(lelt *e)
{
	ensure(is_pair(e));
	return e->pair.cdr;
}

bool is_eq(lelt *a, lelt *b)
{
	if (!a && !b)
		return true;
	if (!a || !b)
		return false;
	if (a->type != b->type)
		return false;
	if (a->type == string)
		return !strcmp(a->str, b->str);
	if (a->type == symbol)
		return !strcmp(a->sym, b->sym);
	if (a->type == number)
		return (a->num == b->num);
	if (a->type == pair)
		return (is_eq(car(a), car(b)) && is_eq(cdr(a), cdr(b)));
	ensure(false); // error!
	return false;
}

bool is_number(lelt *e)
{
	ensure(e);
	return (e->type == number);
}

bool is_string(lelt *e)
{
	ensure(e);
	return (e->type == string);
}

bool is_symbol(lelt *e)
{
	ensure(e);
	return (e->type == symbol);	
}

bool is_pair(lelt *e)
{
	ensure(e);
	return (e->type == pair);	
}

typedef lelt *(*primitive_func_t)(lelt *);

primitive_func_t primitive_implementation(lelt *e) { return (primitive_func_t)cadr(e)->func; }

// todo proper apply, cause this is ugly
lelt *apply_primitive_procedure(lelt *proc, lelt *args)
{
	primitive_func_t impl = primitive_implementation(proc);
	return impl(args);
}
