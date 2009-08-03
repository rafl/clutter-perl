#include "clutterperl-private.h"

MODULE = Clutter::Text  PACKAGE = Clutter::Text PREFIX = clutter_text_

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Text> is an actor that displays custom text using Pango
as the text rendering engine.

Clutter::Text also allows inline editing of the text if the actor is set
editable using Clutter::Text::set_editable().

Selection using keyboard or pointers can be enabled using
Clutter::Text::set_selectable().

=cut

ClutterActor *
clutter_text_new (class, const gchar *font_name=NULL, const gchar *text=NULL, ClutterColor *color=NULL)
    PREINIT:
        ClutterText *ctext;
    CODE:
        RETVAL = clutter_text_new ();
        ctext = CLUTTER_TEXT (RETVAL);
        if (font_name) {
                clutter_text_set_font_name (ctext, font_name);
        }
        if (text) {
                clutter_text_set_text (ctext, text);
        }
        if (color) {
                clutter_text_set_color (ctext, color);
        }
    OUTPUT:
        RETVAL

const gchar_ornull *clutter_text_get_text (ClutterText *text);

void clutter_text_set_text (ClutterText *text, const gchar_ornull *string);

void clutter_text_set_markup (ClutterText *text, const gchar_ornull *pango_markup);

void clutter_text_set_color (ClutterText *text, ClutterColor *color);

ClutterColor_copy *clutter_text_get_color (ClutterText *text);
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_text_get_color (text, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

void clutter_text_set_font_name (ClutterText *text, const gchar *font_name);

const gchar *clutter_text_get_font_name (ClutterText *text);

void clutter_text_set_ellipsize (ClutterText *text, PangoEllipsizeMode  mode);

PangoEllipsizeMode clutter_text_get_ellipsize (ClutterText *text);

void clutter_text_set_line_wrap (ClutterText *text, gboolean line_wrap);

gboolean clutter_text_get_line_wrap (ClutterText *text);

void clutter_text_set_line_wrap_mode (ClutterText *text, PangoWrapMode wrap_mode);

PangoWrapMode clutter_text_get_line_wrap_mode (ClutterText *text);

PangoLayout_noinc *clutter_text_get_layout (ClutterText *text);

void clutter_text_set_attributes (ClutterText *text, PangoAttrList_ornull *attrs);

PangoAttrList_ornull *clutter_text_get_attributes (ClutterText *text);

void clutter_text_set_use_markup (ClutterText *text, gboolean setting);

gboolean clutter_text_get_use_markup (ClutterText *text);

void clutter_text_set_line_alignment (ClutterText *text, PangoAlignment alignment);

PangoAlignment clutter_text_get_line_alignment (ClutterText *text);

void clutter_text_set_justify (ClutterText *text, gboolean justify);

gboolean clutter_text_get_justify (ClutterText *text);

void clutter_text_insert_unichar (ClutterText *text, gunichar wc);

void clutter_text_delete_chars (ClutterText *text, guint n_chars);

void clutter_text_insert_text (ClutterText *text, const gchar *string, gint position=-1);

void clutter_text_delete_text (ClutterText *text, gint start_pos=0, gint end_pos=-1);

gchar_own *clutter_text_get_chars (ClutterText *text, gint start_pos=0, gint end_pos=-1);

void clutter_text_set_editable (ClutterText *text, gboolean editable);

gboolean clutter_text_get_editable (ClutterText *text);

void clutter_text_set_activatable (ClutterText *text, gboolean activatable);

gboolean clutter_text_get_activatable (ClutterText *text);

gint clutter_text_get_cursor_position (ClutterText *text);

void clutter_text_set_cursor_position (ClutterText *text, gint position);

void clutter_text_set_cursor_visible (ClutterText *text, gboolean cursor_visible);

gboolean clutter_text_get_cursor_visible (ClutterText *text);

void clutter_text_set_cursor_color (ClutterText *text, ClutterColor *color);

ClutterColor_copy *clutter_text_get_cursor_color (ClutterText *text);
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_text_get_cursor_color (text, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

void clutter_text_set_cursor_size (ClutterText *text, gint width);

guint clutter_text_get_cursor_size (ClutterText *text);

void clutter_text_set_selectable (ClutterText *text, gboolean selectable);

gboolean clutter_text_get_selectable (ClutterText *text);

void clutter_text_set_selection_bound (ClutterText *text, gint selection_bound);

gint clutter_text_get_selection_bound (ClutterText *text);

void clutter_text_set_selection (ClutterText *text, gint start_pos=0, gint end_pos=-1);

gchar_own *clutter_text_get_selection (ClutterText *text);

void clutter_text_set_selection_color (ClutterText *text, ClutterColor *color);

ClutterColor_copy *clutter_text_get_selection_color (ClutterText *text);
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_text_get_selection_color (text, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

gboolean clutter_text_delete_selection (ClutterText *text);

void clutter_text_set_password_char (ClutterText *text, gunichar wc=0);

gunichar clutter_text_get_password_char (ClutterText *text);

void clutter_text_set_max_length (ClutterText *text, gint max=0);

gint clutter_text_get_max_length (ClutterText *text);

void clutter_text_set_single_line_mode (ClutterText *text, gboolean single_line);

gboolean clutter_text_get_single_line_mode (ClutterText *text);

gboolean clutter_text_activate (ClutterText *text);

=for apidoc
=for signature (x, y, line_height) = $text->position_to_coords ($position)
=cut
void clutter_text_position_to_coords (ClutterText *text, gint position);
    PREINIT:
        gfloat x, y, line_height;
    PPCODE:
        if (clutter_text_position_to_coords (text, position, &x, &y, &line_height)) {
                EXTEND (SP, 3);
                PUSHs (sv_2mortal (newSVnv (x)));
                PUSHs (sv_2mortal (newSVnv (y)));
                PUSHs (sv_2mortal (newSVnv (line_height)));
        }

