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

MODULE = Clutter::Model         PACKAGE = Clutter::Model        PREFIX = clutter_model_

=for apidoc
=for signature model = Clutter::Model->new (type, name, ...)
=cut
ClutterModel_noinc *
clutter_model_new (class, ...)
    PREINIT:
        GArray *types;
        GPtrArray *names;
        guint n_columns, i, pairs;
    CODE:
        /* we allow at least one pair */
        if (items < 3 || 0 != ((items - 1) % 2))
                croak("Usage: Clutter::Model->new($type, $name, ...)");
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
        RETVAL = clutter_model_newv (n_columns,
                                     (GType *) types->data,
                                     (const gchar **) names->pdata);
        g_array_free (types, TRUE);
        g_ptr_array_free (names, TRUE);
    OUTPUT:
        RETVAL

=for apidoc Clutter::Model::append
=for signature boolean = $model->append ($column, $value, ...)
=cut

=for apidoc Clutter::Model::prepend
=for signature boolean = $model->prepend ($column, $value, ...)
=cut
void
clutter_model_prepend (ClutterModel *model, ...)
    ALIAS:
        Clutter::Model::append = 1
    PREINIT:
        gint n_cols, i;
        gint n_values;
        const char *errfmt = "Usage: $iter = $model->%s ($column, $value, ...)\n     %s";
    CODE:
        if (items < 1 || 0 != ((items - 1) % 2))
                croak (errfmt, (ax == 0 ? "prepend" : "append"),
                       "There must be a value for every column number");
        n_cols = clutter_model_get_n_columns (model);
        n_values = (items - 2) / 2;
        for (i = 0; i < n_values; i++) {
                gint position = -1;
                gint column = 0;
                GValue value = { 0, };
                gboolean res = FALSE;
                if (! looks_like_number (ST (1 + i * 2)))
                        croak (errfmt, (ax == 0 ? "prepend" : "append"),
                               "The first value in each pair must be a "
                               "column index number");
                column = SvIV (ST (1 + i * 2));
                if (! (column >= 0 && column < n_cols))
                        croak (errfmt, (ax == 0 ? "prepend" : "append"),
                               form ("Bad column index %d, model only has "
                                     "%d columns", column, n_cols));
                g_value_init (&value,
                              clutter_model_get_column_type (model, column));
                gperl_value_from_sv (&value, ST (1 + i * 2 + 1));
                if (ax == 0)
                        clutter_model_prepend_value (model, column, &value);
                else
                        clutter_model_append_value (model, column, &value);
                g_value_unset (&value);
        }

=for apidoc
=for signature $model->insert ($row, $column, $value, ...)
=cut
void
clutter_model_insert (ClutterModel *model, guint row, ...)
    PREINIT:
        gint n_cols, i;
        gint n_values;
        const char *errfmt = "Usage: $iter = $model->insert ($row, $column, $value, ...)\n     %s";
    CODE:
        if (items < 2 || 0 != (items % 2))
                croak (errfmt, "There must be a value for every column number");
        n_cols = clutter_model_get_n_columns (model);
        n_values = (items - 2) / 2;
        for (i = 0; i < n_values; i++) {
                gint column = 0;
                GValue value = { 0, };
                gboolean res = FALSE;
                if (! looks_like_number (ST (2 + i * 2)))
                        croak (errfmt, "The first value in each pair must be a column index number");
                column = SvIV (ST (2 + i * 2));
                if (! (column >= 0 && column < n_cols))
                        croak (errfmt, form ("Bad column index %d, model only has %d columns",
                                             column, n_cols));
                g_value_init (&value,
                              clutter_model_get_column_type (model, column));
                gperl_value_from_sv (&value, ST (2 + i * 2 + 1));
                clutter_model_insert_value (model, row, column, &value);
                g_value_unset (&value);
        }

void
clutter_model_remove (ClutterModel *model, guint row)

guint
clutter_model_get_n_rows (ClutterModel *model)

const gchar_ornull *
clutter_model_get_column_name (ClutterModel *model, guint column)

const gchar *
clutter_model_get_column_type (ClutterModel *model, guint column)
    PREINIT:
        GType t;
    CODE:
        t = clutter_model_get_column_type (model, column);
        RETVAL = gperl_package_from_type (t);
    OUTPUT:
        RETVAL

guint
clutter_model_get_n_columns (ClutterModel *model)

