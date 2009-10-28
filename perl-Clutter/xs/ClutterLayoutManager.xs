#include "clutter-perl-private.h"

static void
clutterperl_layout_manager_sink (GObject *gobject)
{
        g_object_ref_sink (gobject);
        g_object_unref (gobject);
}

MODULE = Clutter::LayoutManager PACKAGE = Clutter::LayoutManager        PREFIX = clutter_layout_manager_

BOOT:
        gperl_register_sink_func (CLUTTER_TYPE_LAYOUT_MANAGER,
                                  clutterperl_layout_manager_sink);


=for apidoc
=for signature (min_width, natural_width) = $manager->get_preferred_width ($container, $for_height)
=cut
void
clutter_layout_manager_get_preferred_width (manager, container, for_height)
        ClutterLayoutManager *manager
        ClutterContainer *container
        gfloat for_height
    PREINIT:
        gfloat min_width, natural_width;
    PPCODE:
        clutter_layout_manager_get_preferred_width (manager, container,
                                                    for_height,
                                                    &min_width,
                                                    &natural_width);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (min_width)));
        PUSHs (sv_2mortal (newSVnv (natural_width)));
