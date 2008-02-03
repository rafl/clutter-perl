/* Clutter.
 *
 * Perl bindings for the OpenGL based 'interactive canvas' library.
 *
 * Clutter Authored By Matthew Allum  <mallum@openedhand.com>
 * Perl bindings by Emmanuele Bassi  <ebassi@openedhand.com>
 * 
 * Copyright (C) 2006 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "clutterperl.h"

static void
clutterperl_entry_paint_cursor (ClutterEntry *entry)
{
  HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (entry));
  GV *slot = gv_fetchmethod (stash, "PAINT_CURSOR");

  if (slot && GvCV (slot))
    {
      dSP;

      ENTER;
      SAVETMPS;
      PUSHMARK (SP);

      PUSHs (newSVClutterEntry (entry));

      PUTBACK;

      call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

      SPAGAIN;

      FREETMPS;
      LEAVE;
    }
}

static void
clutterperl_entry_class_init (ClutterEntryClass *klass)
{
  klass->paint_cursor = clutterperl_entry_paint_cursor;
}

MODULE = Clutter::Entry PACKAGE = Clutter::Entry        PREFIX = clutter_entry_

ClutterActor *
clutter_entry_new (class, font_name=NULL, text=NULL, color=NULL)
        const gchar_ornull *font_name
        const gchar_ornull *text
        ClutterColor_ornull *color
    CODE:
        RETVAL = clutter_entry_new ();
        if (font_name)
          clutter_entry_set_font_name (CLUTTER_ENTRY (RETVAL), font_name);
        if (text)
          clutter_entry_set_text (CLUTTER_ENTRY (RETVAL), text);
        if (color)
          clutter_entry_set_color (CLUTTER_ENTRY (RETVAL), color);
    OUTPUT:
        RETVAL

void
clutter_entry_set_text (ClutterEntry *entry, const gchar_ornull *text)

const gchar_ornull *
clutter_entry_get_text (ClutterEntry *entry)

void
clutter_entry_set_font_name (ClutterEntry *entry, const gchar *font_name)

const gchar *
clutter_entry_get_font_name (ClutterEntry *entry)

void
clutter_entry_set_color (ClutterEntry *entry, const ClutterColor *color)

ClutterColor_copy *
clutter_entry_get_color (ClutterEntry *entry)
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_entry_get_color (entry, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

PangoLayout *
clutter_entry_get_layout (ClutterEntry *entry)

void
clutter_entry_set_alignment (ClutterEntry *entry, PangoAlignment alignment)

PangoAlignment
clutter_entry_get_alignment (ClutterEntry *entry)

void
clutter_entry_set_cursor_position (ClutterEntry *entry, gint position)

gint
clutter_entry_get_cursor_position (ClutterEntry *entry)

void
clutter_entry_handle_key_event (ClutterEntry *entry, ClutterEvent *event)
    CODE:
        if (event->type != CLUTTER_KEY_PRESS ||
            event->type != CLUTTER_KEY_RELEASE) {
                croak("Event of type `%s' is not a Clutter::Event::Key",
                      clutterperl_event_get_package (event));
        }
        clutter_entry_handle_key_event (entry, (ClutterKeyEvent *) event);

void
clutter_entry_insert_unichar (ClutterEntry *entry, gunichar wc)

void
clutter_entry_delete_chars (ClutterEntry *entry, guint len)

void
clutter_entry_insert_text (ClutterEntry *entry, const gchar *text)
    CODE:
        clutter_entry_insert_text (entry, text, -1);

void
clutter_entry_delete_text (ClutterEntry *entry, gint start_pos, gint end_pos)

void
clutter_entry_set_visible_cursor (ClutterEntry *entry, gboolean visible)

gboolean
clutter_entry_get_visible_cursor (ClutterEntry *entry)

void
clutter_entry_set_visibility (ClutterEntry *entry, gboolean visible)

gboolean
clutter_entry_get_visibility (ClutterEntry *entry)

void
clutter_entry_set_invisible_char (ClutterEntry *entry, gunichar wc)

gunichar
clutter_entry_get_invisible_char (ClutterEntry *entry)

void
clutter_entry_set_max_length (ClutterEntry *entry, gint max)

gint
clutter_entry_get_max_length (ClutterEntry *entry)

=for apidoc Clutter::Entry::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterEntryClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with Clutter-Perl", package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_ENTRY)) {
                croak("package `%s' (%s) is not a Clutter::Entry",
                      package,
                      g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s' (%d)",
                      g_type_name (gtype), gtype);
        }
        clutterperl_entry_class_init (klass);

## allow chaining up to the parent's methods from a perl subclass

=for apidoc Clutter::Entry::PAINT_CURSOR __hide__
=cut

void
PAINT_CURSOR (ClutterEntry *entry)
    PREINIT:
        ClutterEntryClass *klass;
        GType this_class, parent_class;
        SV *saveddefssv;
    CODE:
        saveddefssv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        this_class = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefssv);
        if (!this_class) {
                this_class = G_OBJECT_TYPE (entry);
        }
        parent_class = g_type_parent (this_class);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_ENTRY)) {
                croak("parent of %s is not a Clutter::Entry",
                      g_type_name (this_class));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->paint_cursor) {
                klass->paint_cursor (entry);
        }

