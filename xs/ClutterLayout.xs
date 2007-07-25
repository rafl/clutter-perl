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
clutterperl_call_method (GType       gtype,
                         const char *method,
                         gint        flags)
{
        HV *stash;
        GV *slot;

        stash = gperl_object_stash_from_type (gtype);
        slot = gv_fetchmethod (stash, method);

        if (slot && GvCV (slot)) {
                call_sv ((SV *) GvCV (slot), flags);
        }
}

static ClutterLayoutFlags
clutterperl_layout_get_layout_flags (ClutterLayout *layout)
{
  SV *ret_sv;
  dSP;
  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  PUSHs (sv_2mortal (newSVGObject (G_OBJECT (layout))));

  PUTBACK;
        
  clutterperl_call_method (G_OBJECT_TYPE (layout), "GET_LAYOUT_FLAGS", G_SCALAR);

  SPAGAIN;
        
  ret_sv = POPs;
  SvREFCNT_inc (ret_sv);
        
  PUTBACK;

  FREETMPS;
  LEAVE;

  sv_2mortal (ret_sv);
  return SvClutterLayoutFlags (ret_sv);
}

static void
clutterperl_layout_width_for_height (ClutterLayout *layout,
                                     ClutterUnit   *width,
                                     ClutterUnit    height)
{
  ClutterUnit ret_width;
  dSP;
  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  EXTEND (SP, 2);
  PUSHs (sv_2mortal (newSVGObject (G_OBJECT (layout))));
  PUSHs (sv_2mortal (newSViv (height)));

  PUTBACK;
        
  clutterperl_call_method (G_OBJECT_TYPE (layout), "WIDTH_FOR_HEIGHT", G_SCALAR);

  SPAGAIN;
        
  ret_width = POPi; if (width) *width = ret_width;
        
  PUTBACK;

  FREETMPS;
  LEAVE;
}

static void
clutterperl_layout_height_for_width (ClutterLayout *layout,
                                     ClutterUnit    width,
                                     ClutterUnit   *height)
{
  ClutterUnit ret_height;
  dSP;
  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  EXTEND (SP, 2);
  PUSHs (sv_2mortal (newSVGObject (G_OBJECT (layout))));
  PUSHs (sv_2mortal (newSViv (width)));

  PUTBACK;
        
  clutterperl_call_method (G_OBJECT_TYPE (layout), "HEIGHT_FOR_WIDTH", G_SCALAR);

  SPAGAIN;
        
  ret_height = POPi; if (height) *height = ret_height;
        
  PUTBACK;

  FREETMPS;
  LEAVE;
}

static void
clutterperl_layout_natural_request (ClutterLayout *layout,
                                    ClutterUnit   *width,
                                    ClutterUnit   *height)
{
  ClutterUnit ret_width, ret_height;
  dSP;
  ENTER;
  SAVETMPS;
  PUSHMARK (SP);

  PUSHs (sv_2mortal (newSVGObject (G_OBJECT (layout))));

  PUTBACK;
        
  clutterperl_call_method (G_OBJECT_TYPE (layout), "NATURAL_REQUEST", G_ARRAY);

  SPAGAIN;
  
  ret_width  = POPi; if (width)  *width  = ret_width;
  ret_height = POPi; if (height) *height = ret_height;
        
  PUTBACK;

  FREETMPS;
  LEAVE;
}

static void
clutterperl_layout_init (ClutterLayoutIface *iface)
{
  iface->get_layout_flags = clutterperl_layout_get_layout_flags;
  iface->width_for_height = clutterperl_layout_width_for_height;
  iface->height_for_width = clutterperl_layout_height_for_width;
  iface->natural_request = clutterperl_layout_natural_request;
}

MODULE = Clutter::Layout        PACKAGE = Clutter::Layout       PREFIX = clutter_layout_

=for position DESCRIPTION

=head1 DESCRIPTION

FIXME

=cut

=for position post_methods

=head1 CREATING A CUSTOM LAYOUT

  package MyLayout;
  use Clutter;
  use Glib::Object::Subclass
      'Clutter::Actor',
      interfaces => [ qw( Clutter::Layout ) ];

=head2 Virtual Methods

=over

=item flags = GET_LAYOUT_FLAGS ($layout)

=item width = WIDTH_FOR_HEIGHT ($layout, $height)

=item height = HEIGHT_FOR_WIDTH ($layout, $width)

=item (width, height) = NATURAL_REQUEST ($layout)

=back

=cut

=for apidoc __hide__
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
          (GInterfaceInitFunc) clutterperl_layout_init,
          NULL,
          NULL
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface (gtype, CLUTTER_TYPE_LAYOUT, &iface_info);
    }

ClutterLayoutFlags
clutter_layout_get_layout_flags (ClutterLayout *layout)

gint
clutter_layout_width_for_height (ClutterLayout *layout, gint height)

gint
clutter_layout_height_for_width (ClutterLayout *layout, gint width)

=for apidoc
=for signature (width, height) = $layout->natural_request
=cut
void
clutter_layout_natural_request (ClutterLayout *layout)
    PREINIT:
        gint width, height;
    PPCODE:
        clutter_layout_natural_request (layout, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (width)));
        PUSHs (sv_2mortal (newSViv (height)));

=for apidoc
=for signature (width, height) = $layout->tune_request ($given_width, $given_height)
=for arg given_width (integer)
=for arg given_height (integer)
=cut
void
clutter_layout_tune_request (ClutterLayout *layout, gint given_width, gint given_height)
    PREINIT:
        gint width, height;
    PPCODE:
        clutter_layout_tune_request (layout,
                                     given_width, given_height,
                                     &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (width)));
        PUSHs (sv_2mortal (newSViv (height)));

