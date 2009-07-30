#ifndef _CLUTTER_PERL_H_
#define _CLUTTER_PERL_H_

#include <gtk2perl.h>

#include <cogl/cogl.h>
#include <clutter/clutter.h>

#ifdef CLUTTERPERL_GST
#include <clutter-gst/clutter-gst.h>
#include <gst2perl.h>
#else
#define clutter_gst_init        clutter_gst_init_dummy
#endif

#ifdef CLUTTERPERL_GTK
#include <clutter-gtk/gtk-clutter-embed.h>
#else
#define clutter_gtk_init        clutter_gtk_init_dummy
#endif

#include "clutterperl-autogen.h"

G_BEGIN_DECLS

SV *               newSVCoglPixelFormat   (CoglPixelFormat    format);
CoglPixelFormat    SvCoglPixelFormat      (SV                *sv);

SV *               newSVCoglFeatureFlags  (CoglFeatureFlags   flags);
CoglFeatureFlags   SvCoglFeatureFlags     (SV                *sv);

SV *               newSVCoglBufferTarget  (CoglBufferTarget   flags);
CoglBufferTarget   SvCoglBufferTarget     (SV                *sv);

SV *               newSVCoglHandle        (CoglHandle         handle);
CoglHandle         SvCoglHandle           (SV                *sv);

SV *               newSVCoglTextureVertex (CoglTextureVertex *vertex);
CoglTextureVertex *SvCoglTextureVertex    (SV                *sv);

const char *clutterperl_event_get_package (ClutterEvent *event);

G_END_DECLS

#endif /* _CLUTTER_PERL_H_ */
