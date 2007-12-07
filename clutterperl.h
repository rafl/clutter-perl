#ifndef _CLUTTER_PERL_H_
#define _CLUTTER_PERL_H_

#include <gtk2perl.h>
#include <clutter/clutter.h>

#ifdef CLUTTERPERL_GST
#include <clutter-gst/clutter-gst.h>
#include <gst2perl.h>
#endif

#ifdef CLUTTERPERL_CAIRO
#include <clutter-cairo.h>
#include <cairo-perl.h>
#endif

#ifdef CLUTTERPERL_GTK
#include <clutter-gtk/clutter-gtk.h>
#endif

#include "clutterperl-autogen.h"

G_BEGIN_DECLS

const char *clutterperl_event_get_package (ClutterEvent *event);

G_END_DECLS

#endif /* _CLUTTER_PERL_H_ */
