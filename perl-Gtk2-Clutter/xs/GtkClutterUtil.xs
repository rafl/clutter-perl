#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter::Util        PACKAGE = Clutter::Texture       PREFIX = gtk_clutter_texture_

ClutterActor_noinc *
gtk_clutter_texture_new_from_pixbuf (class, pixbuf)
		GdkPixbuf *pixbuf
	C_ARGS:
		pixbuf

ClutterActor_noinc *
gtk_clutter_texture_new_from_stock (class, widget, stock_id, size)
		GtkWidget *widget
		const gchar *stock_id
		GtkIconSize size
	C_ARGS:
		widget, stock_id, size

ClutterActor_noinc *
gtk_clutter_texture_new_from_icon_name (class, widget, icon_name, size)
		GtkWidget *widget
		const gchar *icon_name
		GtkIconSize size
	C_ARGS:
		widget, icon_name, size

gboolean
gtk_clutter_texture_set_from_pixbuf (class, texture, pixbuf)
		ClutterTexture *texture
		GdkPixbuf *pixbuf
	PREINIT:
		GError *err = NULL;
	C_ARGS:
		texture, pixbuf, &err
	POSTCALL:
		if (!RETVAL) {
			gperl_croak_gerror (NULL, err);
		}

gboolean
gtk_clutter_texture_set_from_stock (class, texture, widget, stock_id, size)
		ClutterTexture *texture
		GtkWidget *widget
		const gchar *stock_id
		GtkIconSize size
	PREINIT:
		GError *err = NULL;
	C_ARGS:
		texture, widget, stock_id, size, &err
	POSTCALL:
		if (!RETVAL) {
			gperl_croak_gerror (NULL, err);
		}

gboolean
gtk_clutter_texture_set_from_icon_name (class, texture, widget, icon_name, size)
		ClutterTexture *texture
		GtkWidget *widget
		const gchar *icon_name
		GtkIconSize size
	PREINIT:
		GError *err = NULL;
	C_ARGS:
		texture, widget, icon_name, size, &err
	POSTCALL:
		if (!RETVAL) {
			gperl_croak_gerror (NULL, err);
		}

MODULE = Gtk2::Clutter::Util        PACKAGE = Gtk2::Clutter::Util       PREFIX = gtk_clutter_

void
gtk_clutter_get_fg_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_bg_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_text_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_text_aa_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_base_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_light_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_dark_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

void
gtk_clutter_get_mid_color (class, GtkWidget *widget, GtkStateType state, OUTLIST ClutterColor *color)
	C_ARGS:
		widget, state, color

