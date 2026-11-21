#include "common.h"

lelt *cadr(lelt *e) { return car(cdr(e)); }
lelt *cddr(lelt *e) { return cdr(cdr(e)); }
lelt *caadr(lelt *e) { return car(car(cdr(e))); }
lelt *caddr(lelt *e) { return car(cdr(cdr(e))); }
lelt *cdadr(lelt *e) { return cdr(car(cdr(e))); }
lelt *cdddr(lelt *e) { return cdr(cdr(cdr(e))); }
lelt *cadddr(lelt *e) { return car(cdr(cdr(cdr(e)))); }
