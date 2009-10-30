#include "clutter-perl-private.h"

static void
clutterperl_layout_manager_allocate (ClutterLayoutManager   *manager,
                                     ClutterContainer       *container,
                                     const ClutterActorBox  *box,
                                     ClutterAllocationFlags  flags)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (manager));
        GV *slot = gv_fetchmethod (stash, "ALLOCATE");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 4);
                PUSHs (newSVClutterLayoutManager (manager));
                PUSHs (newSVClutterContainer (container));
                PUSHs (sv_2mortal (newSVClutterActorBox (box)));
                PUSHs (sv_2mortal (newSVClutterAllocationFlags (flags)));

                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_layout_manager_get_preferred_width (ClutterLayoutManager *manager,
                                                ClutterContainer     *container,
                                                gfloat                for_height,
                                                gfloat               *min_width_p,
                                                gfloat               *natural_width_p)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (manager));
        GV *slot = gv_fetchmethod (stash, "GET_PREFERRED_WIDTH");
        int count;

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 3);
                PUSHs (newSVClutterLayoutManager (manager));
                PUSHs (newSVClutterContainer (container));
                PUSHs (newSVnv (for_height));

                PUTBACK;
                count = call_sv ((SV *) GvCV (slot), G_ARRAY);
                SPAGAIN;

                if (count != 2)
                        croak ("GET_PREFERRED_WIDTH must return an array "
                               "with two items -- (min_width, natural_width)");

                /* XXX - reverse order on the stack */
                if (natural_width_p)
                        *natural_width_p = POPn;

                if (min_width_p)
                        *min_width_p = POPn;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_layout_manager_get_preferred_height (ClutterLayoutManager *manager,
                                                 ClutterContainer     *container,
                                                 gfloat                for_width,
                                                 gfloat               *min_height_p,
                                                 gfloat               *natural_height_p)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (manager));
        GV *slot = gv_fetchmethod (stash, "GET_PREFERRED_HEIGHT");
        int count;

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 3);
                PUSHs (newSVClutterLayoutManager (manager));
                PUSHs (newSVClutterContainer (container));
                PUSHs (newSVnv (for_width));

                PUTBACK;
                count = call_sv ((SV *) GvCV (slot), G_ARRAY);
                SPAGAIN;

                if (count != 2)
                        croak ("GET_PREFERRED_HEIGHT must return an array "
                               "with two items -- (min_height, natural_height)");

                /* XXX - reverse order on the stack */
                if (natural_height_p)
                        *natural_height_p = POPn;

                if (min_height_p)
                        *min_height_p = POPn;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_layout_manager_set_container (ClutterLayoutManager *manager,
                                          ClutterContainer     *container)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (manager));
        GV *slot = gv_fetchmethod (stash, "SET_CONTAINER");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterLayoutManager (manager));
                PUSHs (newSVClutterContainer (container));

                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_layout_manager_class_init (ClutterLayoutManagerClass *klass)
{
        klass->get_preferred_width = clutterperl_layout_manager_get_preferred_width;
        klass->get_preferred_height = clutterperl_layout_manager_get_preferred_height;
        klass->allocate = clutterperl_layout_manager_allocate;
        klass->set_container = clutterperl_layout_manager_set_container;
}

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

=for apidoc Clutter::LayoutManager::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterLayoutManagerClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with Clutter-Perl",
                      package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_LAYOUT_MANAGER)) {
                croak("package `%s' (%s) is not a Clutter::LayoutManager",
                      package, g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s' (%d)",
                      g_type_name (gtype), gtype);
        }
        clutterperl_layout_manager_class_init (klass);
