#ifndef _CLUTTER_PERL_H_
#define _CLUTTER_PERL_H_

#include <gperl.h>

#include <cairo-perl.h>
#include <pango-perl.h>

#include <cogl/cogl.h>
#include <clutter/clutter.h>

#include "clutterperl-autogen.h"

G_BEGIN_DECLS

const char *clutterperl_event_get_package (ClutterEvent *event);

gpointer cogl_perl_object_from_sv (SV *sv, const char *package);
SV *cogl_perl_object_to_sv (gpointer object, const char *package);

gpointer cogl_perl_struct_from_sv (SV *sv, const char *package);
SV *cogl_perl_struct_to_sv (gpointer object, const char *package);

SV *cogl_perl_handle_to_sv (CoglHandle handle);

void cogl_perl_color_from_sv (SV *sv, CoglColor *color);
SV *cogl_perl_color_to_sv (const CoglColor *color);

void cogl_perl_texture_vertex_from_sv (SV *sv, CoglTextureVertex *vertex);
SV *cogl_perl_texture_vertex_to_sv (const CoglTextureVertex *vertex);

/* CoglHandle */
typedef CoglHandle      CoglHandle_noinc;
typedef CoglHandle      CoglHandle_ornull;
#define SvCoglHandle(sv)                ((CoglHandle) cogl_perl_object_from_sv (sv, "Clutter::Cogl::Handle"))
#define SvCoglHandle_ornull(sv)         (((sv) && SvOK (sv)) ? SvCoglHandle(sv) : NULL)
#define newSVCoglHandle(object)         (cogl_perl_handle_to_sv (cogl_handle_ref (object)))
#define newSVCoglHandle_noinc(object)   (cogl_perl_handle_to_sv (object))

/* CoglMatrix */
typedef CoglMatrix      CoglMatrix_ornull;
#define SvCoglMatrix(sv)                ((CoglMatrix *) cogl_perl_struct_from_sv (sv, "Clutter::Cogl::Matrix"))
#define SvCoglMatrix_ornull(sv)         (((sv) && SvOK (sv)) ? SvCoglMatrix(sv) : NULL)
#define newSVCoglMatrix(object)         (cogl_perl_struct_to_sv ((object), "Clutter::Cogl::Matrix"))
#define newSVCoglMatrix_ornull(object)  ((object) == NULL ? &PL_sv_undef : newSVCoglMatrix(object))

/* custom structs */
SV *newSVCoglTextureVertex (CoglTextureVertex *vertex);
CoglTextureVertex *SvCoglTextureVertex (SV *sv);

SV *newSVCoglColor (CoglColor *color);
CoglColor *SvCoglColor (SV *sv);

G_END_DECLS

#endif /* _CLUTTER_PERL_H_ */
