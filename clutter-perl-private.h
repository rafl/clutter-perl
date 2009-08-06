#ifndef __CLUTTERPERL_PRIVATE_H__
#define __CLUTTERPERL_PRIVATE_H__

#include "clutter-perl.h"

G_BEGIN_DECLS

void cogl_perl_set_isa (const char *child_package,
                        const char *parent_package);

CoglMatrix *cogl_perl_copy_matrix (const CoglMatrix *matrix);

G_END_DECLS

#endif /* __CLUTTERPERL_PRIVATE_H__ */
