#include "clutter-perl-private.h"

MODULE = Clutter::FlowLayout    PACKAGE = Clutter::FlowLayout   PREFIX = clutter_flow_layout_

=for enum ClutterFlowOrientation
=cut

ClutterLayoutManager_noinc *
clutter_flow_layout_new (class=NULL, ClutterFlowOrientation orientation=CLUTTER_FLOW_HORIZONTAL)
    C_ARGS:
        orientation

void clutter_flow_layout_set_orientation (ClutterFlowLayout *layout, ClutterFlowOrientation orientation);

ClutterFlowOrientation clutter_flow_layout_get_orientation (ClutterFlowLayout *layout);

void clutter_flow_layout_set_homogeneous (ClutterFlowLayout *layout, gboolean homogeneous);

gboolean clutter_flow_layout_get_homogeneous (ClutterFlowLayout *layout);

void clutter_flow_layout_set_column_spacing (ClutterFlowLayout *layout, gfloat spacing);

gfloat clutter_flow_layout_get_column_spacing (ClutterFlowLayout *layout);

void clutter_flow_layout_set_row_spacing (ClutterFlowLayout *layout, gfloat spacing);

gfloat clutter_flow_layout_get_row_spacing (ClutterFlowLayout *layout);

void clutter_flow_layout_set_column_width (ClutterFlowLayout *layout, gfloat min_width, gfloat max_width);

=for apidoc
=for signature (min_width, max_width) = $layout->get_column_width
=cut
void
clutter_flow_layout_get_column_width (ClutterFlowLayout *layout)
    PREINIT:
        gfloat min_width, max_width;
    PPCODE:
        clutter_flow_layout_get_column_width (layout, &min_width, &max_width);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (min_width)));
        PUSHs (sv_2mortal (newSVnv (max_width)));

void clutter_flow_layout_set_row_height (ClutterFlowLayout *layout, gfloat min_height, gfloat max_height);

=for apidoc
=for signature (min_height, max_height) = $layout->get_row_height
=cut
void clutter_flow_layout_get_row_height (ClutterFlowLayout *layout)
    PREINIT:
        gfloat min_height, max_height;
    PPCODE:
        clutter_flow_layout_get_row_height (layout, &min_height, &max_height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (min_height)));
        PUSHs (sv_2mortal (newSVnv (max_height)));

