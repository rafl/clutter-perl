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

#define CALL_SCALAR \
        PUTBACK; \
        call_sv ((SV *) GvCV (slot), G_SCALAR);

#define FINISH \
        FREETMPS; \
        LEAVE;

static void
zoomable_set_adjustment (GtkClutterZoomable *zoomable,
                         GtkAdjustment      *z_adjust)
{
        GET_METHOD (zoomable, "SET_ADJUSTMENT")

        if (METHOD_EXISTS) {
                PREP (zoomable)

                XPUSHs (sv_2mortal (newSVGtkAdjustment (z_adjust)));

                CALL_VOID

                FINISH
        }
}

static GtkAdjustment *
zoomable_get_adjustment (GtkClutterZoomable *zoomable)
{
        GtkAdjustment *adj;

        GET_METHOD (zoomable, "GET_ADJUSTMENT")

        if (METHOD_EXISTS) {
                PREP (zoomable)

                CALL_SCALAR

                adj = SvGtkAdjustment (POPs);
                if (!g_type_is_a (G_OBJECT_TYPE (adj), GTK_TYPE_ADJUSTMENT))
                  croak ("GET_ADJUSTMENT must return a "
                         "Gtk2::Adjustment instance");

                FINISH
        }

        return adj;
}

static void
gtk_clutter_perl_zoomable_init (GtkClutterZoomableIface *iface)
{
  iface->set_adjustment = zoomable_set_adjustment;
  iface->get_adjustment = zoomable_get_adjustment;
}

MODULE = Gtk2::Clutter::Zoomable      PACKAGE = Gtk2::Clutter::Zoomable     PREFIX = gtk_clutter_zoomable_

void
gtk_clutter_zoomable_set_adjustment (zoomable, z_adjust=NULL)
        GtkClutterZoomable *zoomable
        GtkAdjustment_ornull *z_adjust

GtkAdjustment_ornull *
gtk_clutter_zoomable_get_adjustment (GtkClutterZoomable *zoomable)

=for apidoc __hide__
=cut
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
          (GInterfaceInitFunc) gtk_clutter_perl_zoomable_init,
          NULL,
          NULL
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface_static (gtype, GTK_CLUTTER_TYPE_ZOOMABLE, &iface_info)
;
    }
