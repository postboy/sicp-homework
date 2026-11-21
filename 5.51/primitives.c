#include "common.h"
#include <string.h>

typedef lelt *(*callback_1_t)(lelt *);

// todo: more general and more effective
lelt *apply_1(callback_1_t func, lelt *args)
{
	lelt *first = car(args);
	ensure(first);
	ensure(!cdr(args));	
	return func(first);
}

typedef lelt *(*callback_2_t)(lelt *, lelt *);

// todo: more general and more effective
lelt *apply_2(callback_2_t func, lelt *args)
{
	lelt *first = car(args);
	ensure(first);
	lelt *second = cadr(args);
	ensure(second);
	ensure(!cddr(args));	
	return func(first, second);
}

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
	lelt *result = gc_alloc(sizeof(lelt));
	result->type = pair;
	result->pair.car = car;
	result->pair.cdr = cdr;
	return result;
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

bool is_primitive_procedure(lelt *e) {
	ensure(e);
	return (e->type == primitive);
}

bool is_eq(lelt *a, lelt *b)
{
	if (!a && !b)
		return true;
	if (!a || !b)
		return false;
	if (a->type != b->type)
		return false;
	if (is_string(a))
		return !strcmp(a->str, b->str);
	if (is_symbol(a))
		return !strcmp(a->sym, b->sym);
	if (is_number(a))
		return (a->num == b->num);
	if (is_pair(a))
		return (is_eq(car(a), car(b)) && is_eq(cdr(a), cdr(b)));
	if (is_primitive_procedure(a))
		return (a->func.callback == b->func.callback && a->func.variant == b->func.variant);
	ensure(false); // error!
	return false;
}

// todo proper apply because this is ugly
lelt *apply_primitive_procedure(lelt *proc, lelt *args)
{
	ensure(proc);
	ensure(proc->func.callback);
	switch (proc->func.variant) {
	case one_arg:
		return apply_1(proc->func.callback, args);
	case two_args:
		return apply_2(proc->func.callback, args);
	default:
		ensure(false); // error
		return empty_list;
	}
}
