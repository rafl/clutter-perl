#include "clutter-gtk-perl.h"

#define GET_METHOD(obj, name) \
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (obj)); \
        GV *slot = gv_fetchmethod (stash, name);

#define METHOD_EXISTS   (slot && GvCV (slot))

#define PREP(obj) \
        dSP; \
        ENTER; \
        SAVETMPS; \
        PUSHMARK (SP) ; \
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (obj))));

#define CALL_VOID \
        PUTBACK; \
        call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

#define CALL_ARRAY(n_args) \
        PUTBACK; \
        (n_args) = call_sv ((SV *) GvCV (slot), G_ARRAY); \
        SPAGAIN;

#define FINISH \
        FREETMPS; \
        LEAVE;

static void
scrollable_set_adjustments (GtkClutterScrollable *scrollable,
                            GtkAdjustment        *h_adjust,
                            GtkAdjustment        *v_adjust)
{
        GET_METHOD (scrollable, "SET_ADJUSTMENTS")

        if (METHOD_EXISTS) {
                PREP (scrollable)

                XPUSHs (sv_2mortal (newSVGtkAdjustment (h_adjust)));
                XPUSHs (sv_2mortal (newSVGtkAdjustment (v_adjust)));

                CALL_VOID

                FINISH
        }
}

static void
scrollable_get_adjustments (GtkClutterScrollable  *scrollable,
                            GtkAdjustment        **h_adjust,
                            GtkAdjustment        **v_adjust)
{
        GET_METHOD (scrollable, "GET_ADJUSTMENTS")

        if (METHOD_EXISTS) {
                GtkAdjustment *adj;
                gint count;

                PREP (scrollable)

                CALL_ARRAY (count)

                if (count != 2) {
                        croak ("GET_ADJUSTMENTS must return two "
                               "Gtk2::Adjustment instances");
                }

                adj = SvGtkAdjustment (POPs);
                if (!g_type_is_a (G_OBJECT_TYPE (adj), GTK_TYPE_ADJUSTMENT))
                  croak ("GET_ADJUSTMENTS must return two "
                         "Gtk2::Adjustment instances");

                if (v_adjust)
                  *v_adjust = adj;

                adj = SvGtkAdjustment (POPs);
                if (!g_type_is_a (G_OBJECT_TYPE (adj), GTK_TYPE_ADJUSTMENT))
                  croak ("GET_ADJUSTMENTS must return two "
                         "Gtk2::Adjustment instances");

                if (h_adjust)
                  *h_adjust = adj;

                FINISH
        }
        else {
                if (h_adjust)
                  *h_adjust = NULL;

                if (v_adjust)
                  *v_adjust = NULL;
        }
}

static void
gtk_clutter_perl_scrollable_init (GtkClutterScrollableIface *iface)
{
  iface->set_adjustments = scrollable_set_adjustments;
  iface->get_adjustments = scrollable_get_adjustments;
}

MODULE = Gtk2::Clutter::Scrollable      PACKAGE = Gtk2::Clutter::Scrollable     PREFIX = gtk_clutter_scrollable_

void
gtk_clutter_scrollable_set_adjustments (scrollable, h_adjust=NULL, v_adjust=NULL)
        GtkClutterScrollable *scrollable
        GtkAdjustment_ornull *h_adjust
        GtkAdjustment_ornull *v_adjust

=for apidoc
=for signature (h_adjust, v_adjust) = $scrollable->get_adjustments
void
gtk_clutter_scrollable_get_adjustments (GtkClutterScrollable *scrollable)
    PREINIT:
        GtkAdjustment *h_adjust, *v_adjust;
    PPCODE:
        h_adjust = v_adjust = NULL;
        gtk_clutter_scrollable_get_adjustments (scrollable, &h_adjust, &v_adjust);
        if (h_adjust != NULL)
                XPUSHs (sv_2mortal (newSVGtkAdjustment (h_adjust)));
        if (v_adjust != NULL)
                XPUSHs (sv_2mortal (newSVGtkAdjustment (v_adjust)));

=for apidoc __hide__
=cut
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
          (GInterfaceInitFunc) gtk_clutter_perl_scrollable_init,
          NULL,
          NULL
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface_static (gtype, GTK_CLUTTER_TYPE_SCROLLABLE, &iface_info)
;
    }
