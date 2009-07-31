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

MODULE = Clutter::Types		PACKAGE = Clutter::Color

=for position DESCRIPTION

=head1 DESCRIPTION

Color representation in RGBA format. Every color component is 8 bits
wide.

=cut

ClutterColor_copy *
new (class, red=0, green=0, blue=0, alpha=0)
	guint8 red
	guint8 green
	guint8 blue
	guint8 alpha
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        color.red   = red;
	color.green = green;
	color.blue  = blue;
	color.alpha = alpha;
        RETVAL = &color;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Color::red
=for signature integer = $color->red
=for signature oldvalue = $color->red ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::green
=for signature integer = $color->green
=for signature oldvalue = $color->green ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::blue
=for signature integer = $color->blue
=for signature oldvalue = $color->blue ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Color::alpha
=for signature integer = $color->alpha
=for signature oldvalue = $color->alpha ($newvalue)
=for arg newvalue (integer)
=cut

guint8
red (ClutterColor *color, SV *newvalue = 0)
    ALIAS:
        Clutter::Color::green = 1
	Clutter::Color::blue  = 2
	Clutter::Color::alpha = 3
    CODE:
        switch (ix) {
		case 0: RETVAL = color->red;   break;
		case 1: RETVAL = color->green; break;
		case 2: RETVAL = color->blue;  break;
		case 3: RETVAL = color->alpha; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
                        break;
	}
	if (newvalue) {
	        switch (ix) {
			case 0: color->red   = SvIV (newvalue); break;
			case 1: color->green = SvIV (newvalue); break;
			case 2: color->blue  = SvIV (newvalue); break;
			case 3: color->alpha = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
                                break;
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (red, green, blue, alpha) = $color->values
=cut
void
values (ClutterColor *color)
    PPCODE:
        EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (color->red)));
	PUSHs (sv_2mortal (newSViv (color->green)));
	PUSHs (sv_2mortal (newSViv (color->blue)));
	PUSHs (sv_2mortal (newSViv (color->alpha)));

guint32
to_pixel (ClutterColor *color)
    CODE:
        RETVAL = clutter_color_to_pixel (color);
    OUTPUT:
        RETVAL


ClutterColor_copy *
from_pixel (class, guint32 pixel)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_color_from_pixel (&color, pixel);
        RETVAL = &color;
    OUTPUT:
        RETVAL

=for apidoc
=for signature (hue, luminance, saturation) = $color->to_hls
=cut
void
to_hls (ClutterColor *color)
    PREINIT:
        gfloat h, l, s;
    PPCODE:
        clutter_color_to_hls (color, &h, &l, &s);
        EXTEND (SP, 3);
        PUSHs (sv_2mortal (newSVnv (h)));
        PUSHs (sv_2mortal (newSVnv (l)));
        PUSHs (sv_2mortal (newSVnv (s)));

ClutterColor_copy *
from_hls (class, gfloat hue, gfloat luminance, gfloat saturation)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_color_from_hls (&color, hue, luminance, saturation);
        RETVAL = &color;
    OUTPUT:
        RETVAL

gboolean
equal (const ClutterColor *a, const ClutterColor *b)
    CODE:
        RETVAL = clutter_color_equal (a, b);
    OUTPUT:
        RETVAL

ClutterColor_copy *
add (const ClutterColor *a, const ClutterColor *b)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_color_add (a, b, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

ClutterColor_copy *
subtract (const ClutterColor *a, const ClutterColor *b)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_color_subtract (a, b, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

ClutterColor_copy *
lighten (ClutterColor *color)
    PREINIT:
        ClutterColor lighter = { 0, };
    CODE:
        clutter_color_lighten (color, &lighter);
        RETVAL = &lighter;
    OUTPUT:
        RETVAL

ClutterColor_copy *
darken (ClutterColor *color)
    PREINIT:
        ClutterColor darker = { 0, };
    CODE:
        clutter_color_darken (color, &darker);
        RETVAL = &darker;
    OUTPUT:
        RETVAL

ClutterColor_copy *
shade (ClutterColor *color, gdouble factor)
    PREINIT:
        ClutterColor shade = { 0, };
    CODE:
        clutter_color_shade (color, factor, &shade);
        RETVAL = &shade;
    OUTPUT:
        RETVAL

ClutterColor_copy *
from_string (class, const gchar *str)
    PREINIT:
        ClutterColor parsed = { 0, };
    CODE:
        clutter_color_from_string (&parsed, str);
        RETVAL = &parsed;
    OUTPUT:
        RETVAL

gchar_own *
to_string (ClutterColor *color)
    CODE:
        RETVAL = clutter_color_to_string (color);
    OUTPUT:
        RETVAL

MODULE = Clutter::Types		PACKAGE = Clutter::Geometry


ClutterGeometry_copy *
new (class, x, y, width, height)
	gint x
	gint y
	gint width
	gint height
    PREINIT:
        ClutterGeometry geometry;
    CODE:
        geometry.x = x;
	geometry.y = y;
	geometry.width = width;
	geometry.height = height;
    	RETVAL = &geometry;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Geometry::x
=for signature integer = $geometry->x
=for signature oldvalue = $geometry->x ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::y
=for signature integer = $geometry->y
=for signature oldvalue = $geometry->y ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::width
=for signature integer = $geometry->width
=for signature oldvalue = $geometry->width ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Geometry::height
=for signature integer = $geometry->height
=for signature oldvalue = $geometry->height ($newvalue)
=for arg newvalue (integer)
=cut

gint
x (ClutterGeometry *geometry, SV *newvalue = 0)
    ALIAS:
        Clutter::Geometry::y      = 1
	Clutter::Geometry::width  = 2
	Clutter::Geometry::height = 3
    CODE:
        switch (ix) {
		case 0: RETVAL = geometry->x;      break;
		case 1: RETVAL = geometry->y;      break;
		case 2: RETVAL = geometry->width;  break;
		case 3: RETVAL = geometry->height; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: geometry->x      = SvIV (newvalue); break;
			case 1: geometry->y      = SvIV (newvalue); break;
			case 2: geometry->width  = SvIV (newvalue); break;
			case 3: geometry->height = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x, y, width, height) = $geometry->values
=cut
void
values (ClutterGeometry *geometry)
    PPCODE:
        EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (geometry->x)));
	PUSHs (sv_2mortal (newSViv (geometry->y)));
	PUSHs (sv_2mortal (newSViv (geometry->width)));
	PUSHs (sv_2mortal (newSViv (geometry->height)));

MODULE = Clutter::Types		PACKAGE = Clutter::ActorBox

=for position DESCRIPTION

=head1 DESCRIPTION

The bounding box of an actor, represented by the coordinates of the
upper left and lower right corners:

  +-----------------------+
  | (x1,y1)               |
  |                       |
  |               (x2,y2) |
  +-----------------------+

=cut

ClutterActorBox_copy *
new (class, x1, y1, x2, y2)
	gfloat x1
	gfloat y1
	gfloat x2
	gfloat y2
    PREINIT:
        ClutterActorBox box;
    CODE:
        box.x1 = x1;
	box.y1 = y1;
	box.x2 = x2;
	box.y2 = y2;
    	RETVAL = &box;
    OUTPUT:
        RETVAL

=for apidoc Clutter::ActorBox::x1
=for signature integer = $box->x1
=for signature oldvalue = $box->x1 ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::ActorBox::y1
=for signature integer = $box->y1
=for signature oldvalue = $box->y1 ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::ActorBox::x2
=for signature integer = $box->x2
=for signature oldvalue = $box->x2 ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::ActorBox::y2
=for signature integer = $box->y2
=for signature oldvalue = $box->y2 ($newvalue)
=for arg newvalue (integer)
=cut

gfloat
x1 (ClutterActorBox *box, SV *newvalue = 0)
    ALIAS:
        Clutter::ActorBox::y1     = 1
	Clutter::ActorBox::x2     = 2
	Clutter::ActorBox::y2     = 3
    CODE:
        switch (ix) {
		case 0: RETVAL = box->x1; break;
		case 1: RETVAL = box->y1; break;
		case 2: RETVAL = box->x2; break;
		case 3: RETVAL = box->y2; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: box->x1 = SvNV (newvalue); break;
			case 1: box->y1 = SvNV (newvalue); break;
			case 2: box->x2 = SvNV (newvalue); break;
			case 3: box->y2 = SvNV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x1, y1, x2, y2) = $box->values
=cut
void
values (ClutterActorBox *box)
    PPCODE:
        EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSVnv (box->x1)));
	PUSHs (sv_2mortal (newSVnv (box->y1)));
	PUSHs (sv_2mortal (newSVnv (box->x2)));
	PUSHs (sv_2mortal (newSVnv (box->y2)));

=for apidoc
=for signature (x, y) = $box->origin
=cut
void
origin (ClutterActorBox *box)
    PPCODE:
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (box->x1)));
        PUSHs (sv_2mortal (newSVnv (box->y1)));


=for apidoc
=for signature (width, height) = $box->size
=cut
void
size (ClutterActorBox *box)
    PPCODE:
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (box->x2 - box->x1)));
        PUSHs (sv_2mortal (newSVnv (box->y2 - box->y1)));

=for apidoc Clutter::ActorBox::x
=for signature x = $box->x
=cut

=for apidoc Clutter::ActorBox::y
=for signature y = $box->y
=cut

=for apidoc Clutter::ActorBox::width
=for signature width = $box->width
=cut

=for apidoc Clutter::ActorBox::height
=for signature height = $box->height
=cut

gfloat
x (ClutterActorBox *box)
    ALIAS:
        Clutter::ActorBox::y      = 1
        Clutter::ActorBox::width  = 2
        Clutter::ActorBox::height = 3
    CODE:
        switch (ix) {
                case 0: RETVAL = box->x1;           break;
                case 1: RETVAL = box->y2;           break;
                case 2: RETVAL = box->x2 - box->x1; break;
                case 3: RETVAL = box->y2 - box->y1; break;
                default:
                        g_assert_not_reached ();
        }
    OUTPUT:
        RETVAL

gfloat
get_area (ClutterActorBox *box)
    CODE:
        RETVAL = clutter_actor_box_get_area (box);
    OUTPUT:
        RETVAL

gboolean
contains (ClutterActorBox *box, gfloat x, gfloat y)
    CODE:
        RETVAL = clutter_actor_box_contains (box, x, y);
    OUTPUT:
        RETVAL

MODULE = Clutter::Types		PACKAGE = Clutter::Knot


ClutterKnot_copy *
new (class, gint x, gint y)
    PREINIT:
        ClutterKnot knot;
    CODE:
        knot.x = x;
	knot.y = y;
    	RETVAL = &knot;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Knot::x
=for signature integer = $knot->x
=for signature oldvalue = $knot->x ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Knot::y
=for signature integer = $knot->y
=for signature oldvalue = $knot->y ($newvalue)
=for arg newvalue (integer)
=cut

gint
x (ClutterKnot *knot, SV *newvalue = 0)
    ALIAS:
        Clutter::Knot::y = 1
    CODE:
        switch (ix) {
		case 0: RETVAL = knot->x; break;
		case 1: RETVAL = knot->y; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: knot->x = SvIV (newvalue); break;
			case 1: knot->y = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x, y) = $knot->values
=cut
void
values (ClutterKnot *knot)
    PPCODE:
        EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (knot->x)));
	PUSHs (sv_2mortal (newSViv (knot->y)));

MODULE = Clutter::Types		PACKAGE = Clutter::Vertex


ClutterVertex_copy *
new (class, x, y, z)
	gint32 x
	gint32 y
        gint32 z
    PREINIT:
        ClutterVertex vertex;
    CODE:
        vertex.x = x;
	vertex.y = y;
        vertex.z = z;;
    	RETVAL = &vertex;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Vertex::x
=for signature integer = $vertex->x
=for signature oldvalue = $vertex->x ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Vertex::y
=for signature integer = $vertex->y
=for signature oldvalue = $vertex->y ($newvalue)
=for arg newvalue (integer)
=cut

=for apidoc Clutter::Vertex::z
=for signature integer = $vertex->z
=for signature oldvalue = $vertex->z ($newvalue)
=for arg newvalue (integer)
=cut

gint
x (ClutterVertex *vertex, SV *newvalue = 0)
    ALIAS:
        Clutter::Vertex::y = 1
        Clutter::Vertex::z = 2
    CODE:
        switch (ix) {
		case 0: RETVAL = vertex->x; break;
		case 1: RETVAL = vertex->y; break;
		case 2: RETVAL = vertex->z; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
	if (newvalue) {
	        switch (ix) {
			case 0: vertex->x = SvIV (newvalue); break;
			case 1: vertex->y = SvIV (newvalue); break;
			case 2: vertex->z = SvIV (newvalue); break;
			default:
				g_assert_not_reached ();
		}
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x, y, z) = $vertex->values
=cut
void
values (ClutterVertex *vertex)
    PPCODE:
        EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSViv (vertex->x)));
	PUSHs (sv_2mortal (newSViv (vertex->y)));
	PUSHs (sv_2mortal (newSViv (vertex->z)));

gboolean
equal (const ClutterVertex *a, const ClutterVertex *b)
    CODE:
        RETVAL = (a->x == b->x && a->y == b->y && a->z == b->z);
    OUTPUT:
        RETVAL

