#include "common.h"

bool is_true(lelt *e) { return !is_false(e); }

lelt *cadr(lelt *e) { return car(cdr(e)); }
lelt *cddr(lelt *e) { return cdr(cdr(e)); }
lelt *caadr(lelt *e) { return car(car(cdr(e))); }
lelt *caddr(lelt *e) { return car(cdr(cdr(e))); }
lelt *cdadr(lelt *e) { return cdr(car(cdr(e))); }
lelt *cdddr(lelt *e) { return cdr(cdr(cdr(e))); }
lelt *cadddr(lelt *e) { return car(cdr(cdr(cdr(e)))); }

lelt *append(lelt *a, lelt *b)
{
	if (!a)
		return b;
	return cons(car(a), append(cdr(a), b));
}

// for cond_to_if
/*lelt *sequence_to_exp(lelt *e)
{
	if (!e)
		return empty_list;
	return (is_last_exp(e) ? first_exp(e) : make_begin(e));
}*/
