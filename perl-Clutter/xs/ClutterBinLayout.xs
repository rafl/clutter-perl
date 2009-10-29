#include "clutter-perl-private.h"

MODULE = Clutter::BinLayout     PACKAGE = Clutter::BinLayout    PREFIX = clutter_bin_layout_

ClutterLayoutManager_noinc *
clutter_bin_layout_new (class=NULL, x_align=CLUTTER_BIN_ALIGNMENT_CENTER, y_align=CLUTTER_BIN_ALIGNMENT_CENTER)
        ClutterBinAlignment x_align
        ClutterBinAlignment y_align
    C_ARGS:
        x_align, y_align

void
clutter_bin_layout_set_alignment (layout, child, x_align, y_align)
        ClutterBinLayout *layout
        ClutterActor *child
        ClutterBinAlignment x_align
        ClutterBinAlignment y_align

=for apidoc
=for signature (x_align, y_align) = $layout->get_alignment ($child)
=cut
void
clutter_bin_layout_get_alignment (layout, child)
        ClutterBinLayout *layout
        ClutterActor *child
    PREINIT:
        ClutterBinAlignment x_align, y_align;
    PPCODE:
        clutter_bin_layout_get_alignment (layout, child, &x_align, &y_align);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVClutterBinAlignment (x_align)));
        PUSHs (sv_2mortal (newSVClutterBinAlignment (y_align)));

void
clutter_bin_layout_add (layout, actor, x_align=CLUTTER_BIN_ALIGNMENT_CENTER, y_align=CLUTTER_BIN_ALIGNMENT_CENTER)
        ClutterBinLayout *layout
        ClutterActor *actor
        ClutterBinAlignment x_align
        ClutterBinAlignment y_align
