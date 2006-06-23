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

MODULE = Clutter::Label		PACKAGE = Clutter::Label	PREFIX = clutter_label_


ClutterActor_noinc *
clutter_label_new (class, font_name=NULL, text=NULL)
	const gchar_ornull *font_name
	const gchar_ornull *text
    CODE:
        RETVAL = clutter_label_new ();
	if (font_name) {
		clutter_label_set_font_name (CLUTTER_LABEL (RETVAL), font_name);
	}
	if (text) {
		clutter_label_set_text (CLUTTER_LABEL (RETVAL), text);
	}
    OUTPUT:
    	RETVAL

void
clutter_label_set_text (ClutterLabel *label, const gchar_ornull *text)

const gchar_ornull *
clutter_label_get_text (ClutterLabel *label)

void
clutter_label_set_font_name (ClutterLabel *label, const gchar *font_name)

const gchar_ornull *
clutter_label_get_font_name (ClutterLabel *label)

void
clutter_label_set_color (ClutterLabel *label, ClutterColor *color)

ClutterColor_copy *
clutter_label_get_color (ClutterLabel *label)
    PREINIT:
        ClutterColor color;
    CODE:
        clutter_label_get_color (label, &color);
	RETVAL = &color;
    OUTPUT:
        RETVAL

void
clutter_label_set_text_extents (ClutterLabel *label, gint width, gint height)

=for apidoc
=for signature (width, height) = $label->get_text_extents
=cut
void
clutter_label_get_text_extents (ClutterLabel *label)
    PREINIT:
        gint width, height;
    PPCODE:
        clutter_label_get_text_extents (label, &width, &height);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (width)));
	PUSHs (sv_2mortal (newSViv (height)));
