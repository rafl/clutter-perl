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

#include "clutter-perl-private.h"

MODULE = Clutter::ListModel     PACKAGE = Clutter::ListModel    PREFIX = clutter_list_model_

=for object Clutter::ListModel - List model implementation
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $model = Clutter::ListModel->new(
        # column type    column title
        'Glib::String',  'Full Name',
        'Glib::String',  'Address',
        'Glib::Uint',    'Age',
        'Glib::Boolean', 'Subscribed',
    );

=head1 DESCRIPTION

B<Clutter::ListModel> is a L<Clutter::Model> implementation provided by
Clutter. Clutter::ListModel uses a bilanced binary tree internally for
storing the values for each row, so it's optimized for insertion and look
up operations.

=cut

=for apidoc
=for signature model = Clutter::ListModel->new (type, name, ...)
=for arg type (string) type of the column
=for arg name (string) name of the column, or undef
=for arg ... (list) of type, name pairs
=cut
ClutterModel_noinc *
clutter_list_model_new (class, ...)
    PREINIT:
        GArray *types;
        GPtrArray *names;
        guint n_columns, i, pairs;
    CODE:
        /* we allow at least one pair */
        if (items < 3 || 0 != ((items - 1) % 2))
                croak("Usage: Clutter::Model::Default->new($type, $name, ...)");
        pairs = (items - 1) / 2;
        types = g_array_sized_new (FALSE, FALSE, sizeof (GType), pairs);
        names = g_ptr_array_sized_new (pairs);
        for (i = 1, n_columns = 0; i < items; i += 2, n_columns++) {
                gchar *package = SvPV_nolen (ST (i));
                gchar *name    = SvPV_nolen (ST (i + 1));
                GType t        = gperl_type_from_package (package);
                if (t == G_TYPE_INVALID) {
                        g_array_free (types, TRUE);
                        g_ptr_array_free (names, TRUE);
                        croak ("package `%s' is not registered with GPerl",
                               package);
                        g_assert ("not reached");
                }
                g_array_index (types, GType,  n_columns) = t;
                g_ptr_array_add (names, name);
        }
        RETVAL = clutter_list_model_newv (n_columns,
                                          (GType *) types->data,
                                          (const gchar **) names->pdata);
        g_array_free (types, TRUE);
        g_ptr_array_free (names, TRUE);
    OUTPUT:
        RETVAL

