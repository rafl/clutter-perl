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

=for apidoc
=for signature (min_height, natural_height) = $manager->get_preferred_height ($container, $for_width)
=cut
void
clutter_layout_manager_get_preferred_height (manager, container, for_width)
        ClutterLayoutManager *manager
        ClutterContainer *container
        gfloat for_width
    PREINIT:
        gfloat min_height, natural_height;
    PPCODE:
        clutter_layout_manager_get_preferred_height (manager, container,
                                                     for_width,
                                                     &min_height,
                                                     &natural_height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (min_height)));
        PUSHs (sv_2mortal (newSVnv (natural_height)));

void
clutter_layout_manager_allocate (manager, container, allocation, flags)
        ClutterLayoutManager *manager
        ClutterContainer *container
        const ClutterActorBox *allocation
        ClutterAllocationFlags flags

void
clutter_layout_manager_layout_changed (manager)
        ClutterLayoutManager *manager

void
clutter_layout_manager_set_container (manager, container)
        ClutterLayoutManager *manager
        ClutterContainer_ornull *container

ClutterLayoutMeta *
clutter_layout_manager_get_child_meta (manager, container, actor)
        ClutterLayoutManager *manager
        ClutterContainer *container
        ClutterActor *actor

void
clutter_layout_manager_add_child_meta (manager, container, actor)
        ClutterLayoutManager *manager
        ClutterContainer *container
        ClutterActor *actor

void
clutter_layout_manager_remove_child_meta (manager, container, actor)
        ClutterLayoutManager *manager
        ClutterContainer *container
        ClutterActor *actor
