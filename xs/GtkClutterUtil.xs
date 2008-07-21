#include "clutterperl.h"

MODULE = Gtk2::ClutterUtil     PACKAGE = Gtk2::ClutterUtil    PREFIX = gtk_clutter_

=for position DESCRIPTION

=head1 DESCRIPTION

A set of utility calls for retrieving theme colors from a L<Gtk2::Widget>
in a form understandable by Clutter.

=cut

ClutterColor_copy *
get_fg_clutter_color (GtkWidget *widget, GtkStateType state)
    ALIAS:
        Gtk2::ClutterUtil::get_bg_clutter_color   = 1
        Gtk2::ClutterUtil::get_text_clutter_color = 2
        Gtk2::ClutterUtil::get_base_clutter_color = 3
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        switch (ix) {
          case 0: gtk_clutter_get_fg_color   (widget, state, &color); break;
          case 1: gtk_clutter_get_bg_color   (widget, state, &color); break;
          case 2: gtk_clutter_get_text_color (widget, state, &color); break;
          case 3: gtk_clutter_get_base_color (widget, state, &color); break;
          default:
                g_assert_not_reached ();
                break;
        }
        RETVAL = &color;
    OUTPUT:
        RETVAL

MODULE = Gtk2::ClutterUtil      PACKAGE = Gtk2::ClutterTexture  PREFIX = gtk_clutter_texture_

=for position DESCRIPTION

=head1 DESCRIPTION

A set of utility calls for using L<Clutter::Texture> with GTK+ stock icons,
icons from themes and L<Gtk2::Gdk::Pixbuf> objects.

=cut

ClutterActor_noinc *
gtk_clutter_texture_new_from_pixbuf (class, GdkPixbuf *pixbuf)
    C_ARGS:
        pixbuf

ClutterActor_noinc *
gtk_clutter_texture_new_from_stock (class, GtkWidget *widget, const gchar *stock_id, GtkIconSize size=-1)
    C_ARGS:
        widget, stock_id, size

ClutterActor_noinc *
gtk_clutter_texture_new_from_icon_name (class, GtkWidget_ornull *widget, const gchar *icon_name, GtkIconSize size=-1)
    C_ARGS:
        widget, icon_name, size

void
gtk_clutter_texture_set_from_pixbuf (ClutterTexture *texture, GdkPixbuf *pixbuf)

void
gtk_clutter_texture_set_from_stock (ClutterTexture *texture, GtkWidget *widget, const gchar *stock_id, GtkIconSize size=-1)

void
gtk_clutter_texture_set_from_icon_name (ClutterTexture *texture, GtkWidget_ornull *widget, const gchar *icon_name, GtkIconSize size=-1)
