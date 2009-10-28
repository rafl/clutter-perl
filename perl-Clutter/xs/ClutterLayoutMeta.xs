#include "clutter-perl-private.h"

MODULE = Clutter::LayoutMeta    PACKAGE = Clutter::LayoutMeta   PREFIX = clutter_layout_meta_

=for object Clutter::LayoutMeta - Wrapper for actors inside a layout manager
=cut

void clutter_layout_meta_set_manager (ClutterLayoutMeta *meta, ClutterLayoutManager *manager);
    CODE:
        meta->manager = manager;

ClutterLayoutManager *clutter_layout_meta_get_manager (ClutterLayoutMeta *meta);
