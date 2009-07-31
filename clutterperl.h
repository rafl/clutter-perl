#ifndef _CLUTTER_PERL_H_
#define _CLUTTER_PERL_H_

#include <gperl.h>

#include <cairo-perl.h>

#include <cogl/cogl.h>
#include <clutter/clutter.h>

#include "clutterperl-autogen.h"

G_BEGIN_DECLS

SV *               newSVCoglHandle        (CoglHandle         handle);
CoglHandle         SvCoglHandle           (SV                *sv);

SV *               newSVCoglTextureVertex (CoglTextureVertex *vertex);
CoglTextureVertex *SvCoglTextureVertex    (SV                *sv);

const char *clutterperl_event_get_package (ClutterEvent *event);

G_END_DECLS

#endif /* _CLUTTER_PERL_H_ */
