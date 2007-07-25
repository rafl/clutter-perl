#include "clutterperl.h"

MODULE = Clutter::Behaviour::Bspline PACKAGE = Clutter::Behaviour::Bspline PREFIX = clutter_behaviour_bspline_

ClutterBehaviour_noinc *
clutter_behaviour_bspline_new (class, alpha, knot=NULL, ...)
        ClutterAlpha_ornull *alpha
        ClutterKnot_ornull *knot
    PREINIT:
        ClutterBehaviourBspline *bspline;
        int i;
    CODE:
        RETVAL = clutter_behaviour_bspline_new (alpha, NULL, 0);
        bspline = CLUTTER_BEHAVIOUR_BSPLINE (RETVAL);
        for (i = 2; i < items; i++) {
                clutter_behaviour_bspline_append_knot (bspline, 
                                                       SvClutterKnot (ST (i)));
        }
    OUTPUT:
        RETVAL

=for apidoc
=for arg knot (__hide__)
=for arg ... list of knots
=cut
void
clutter_behaviour_bspline_append_knot (bspline, knot, ...)
        ClutterBehaviourBspline *bspline
        ClutterKnot *knot
    PREINIT:
        int i;
    CODE:
        clutter_behaviour_bspline_append_knot (bspline, knot);
        for (i = 2; i < items; i++) {
                clutter_behaviour_bspline_append_knot (bspline,
                                                       SvClutterKnot (ST (i)));
        }

void
clutter_behaviour_bspline_truncate (ClutterBehaviourBspline *bspline, guint offset)

void
clutter_behaviour_bspline_join (ClutterBehaviourBspline *bspline1, ClutterBehaviourBspline *bspline2)

ClutterBehaviour_noinc *
clutter_behaviour_bspline_split (ClutterBehaviourBspline *bspline, guint offset)

void
clutter_behaviour_bspline_clear (ClutterBehaviourBspline *bspline)

void
clutter_behaviour_bspline_adjust (bspline, offset, knot)
        ClutterBehaviourBspline *bspline
        guint offset
        ClutterKnot *knot

void
clutter_behaviour_bspline_set_origin (ClutterBehaviourBspline *bspline, ClutterKnot *knot)

ClutterKnot_copy *
clutter_behaviour_bspline_get_origin (ClutterBehaviourBspline *bspline)
    PREINIT:
        ClutterKnot knot;
    CODE:
        clutter_behaviour_bspline_get_origin (bspline, &knot);
        RETVAL = &knot;
    OUTPUT:
        RETVAL

