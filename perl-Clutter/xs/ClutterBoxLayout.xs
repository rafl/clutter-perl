#include "clutter-perl-private.h"

MODULE = Clutter::BoxLayout     PACKAGE = Clutter::BoxLayout    PREFIX = clutter_box_layout_

ClutterLayoutManager_noinc *clutter_box_layout_new (class=NULL);
    C_ARGS:
        /* void */

void clutter_box_layout_set_spacing (ClutterBoxLayout *layout, guint spacing);

guint clutter_box_layout_get_spacing (ClutterBoxLayout *layout);

void clutter_box_layout_set_vertical (ClutterBoxLayout *layout, gboolean vertical);

gboolean clutter_box_layout_get_vertical (ClutterBoxLayout *layout);

void clutter_box_layout_set_pack_start (ClutterBoxLayout *layout, gboolean pack_start);

gboolean clutter_box_layout_get_pack_start (ClutterBoxLayout *layout);

void clutter_box_layout_pack (layout, actor, expand=FALSE, x_fill=FALSE, y_fill=FALSE, x_align=CLUTTER_BIN_ALIGNMENT_CENTER, y_align=CLUTTER_BIN_ALIGNMENT_CENTER)
        ClutterBoxLayout *layout
        ClutterActor *actor
        gboolean expand
        gboolean x_fill
        gboolean y_fill
        ClutterBoxAlignment x_align
        ClutterBoxAlignment y_align

void clutter_box_layout_set_alignment (layout, actor, x_align, y_align)
        ClutterBoxLayout *layout
        ClutterActor *actor
        ClutterBoxAlignment x_align
        ClutterBoxAlignment y_align

=for apidoc
=for signature (x_align, y_align) = $layout->get_alignment ($actor)
=cut
void clutter_box_layout_get_alignment (layout, actor)
        ClutterBoxLayout *layout
        ClutterActor *actor
    PREINIT:
        ClutterBoxAlignment x_align, y_align;
    PPCODE:
        clutter_box_layout_get_alignment (layout, actor, &x_align, &y_align);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVClutterBinAlignment (x_align)));
        PUSHs (sv_2mortal (newSVClutterBinAlignment (y_align)));

void clutter_box_layout_set_fill (layout, actor, x_fill, y_fill)
        ClutterBoxLayout *layout
        ClutterActor *actor
        gboolean x_fill
        gboolean y_fill

=for apidoc
=for signature (x_fill, y_fill) = $layout->get_fill ($actor)
=cut
void clutter_box_layout_get_fill (layout, actor)
        ClutterBoxLayout *layout
        ClutterActor *actor
    PREINIT:
        gboolean x_fill, y_fill;
    PPCODE:
        clutter_box_layout_get_fill (layout, actor, &x_fill, &y_fill);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (x_fill)));
        PUSHs (sv_2mortal (newSVuv (y_fill)));

void clutter_box_layout_set_expand (layout, actor, expand)
        ClutterBoxLayout *layout
        ClutterActor *actor
        gboolean expand

gboolean clutter_box_layout_get_expand (layout, actor)
        ClutterBoxLayout *layout
        ClutterActor *actor
