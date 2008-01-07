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

static gboolean
clutterperl_model_foreach_func (ClutterModel     *model,
                                ClutterModelIter *iter,
                                gpointer          data)
{
        GPerlCallback *callback = data;
        GValue value = { 0, };
        gboolean retval;

        g_value_init (&value, callback->return_type);

        gperl_callback_invoke (callback, &value, model, iter);
        
        retval = g_value_get_boolean (&value);
        g_value_unset (&value);

        return retval;

}

MODULE = Clutter::Model         PACKAGE = Clutter::Model        PREFIX = clutter_model_

=for apidoc Clutter::Model::append
=for signature boolean = $model->append ($column, $value, ...)
=cut
void
clutter_model_append (ClutterModel *model, ...)
    PREINIT:
        gint n_cols, i;
        gint n_values;
        guint *columns;
        GValueArray *values;
        const char *errfmt = "Usage: $model->append ($column, $value, ...)\n"
                             "     %s";
    CODE:
        if (items < 1 || 0 != ((items - 1) % 2))
                croak (errfmt,
                       "There must be a value for every column number");
        n_cols = clutter_model_get_n_columns (model);
        n_values = (items - 2) / 2;
        columns = g_new (guint, n_values);
        values = g_value_array_new (n_values);
        for (i = 0; i < n_values; i++) {
                gint position = -1;
                gint column = 0;
                GValue value = { 0, };
                gboolean res = FALSE;
                if (! looks_like_number (ST (1 + i * 2)))
                        croak (errfmt,
                               "The first value in each pair must be a "
                               "column index number");
                column = SvIV (ST (1 + i * 2));
                if (! (column >= 0 && column < n_cols))
                        croak (errfmt,
                               form ("Bad column index %d, model only has "
                                     "%d columns", column, n_cols));
                g_value_init (&value,
                              clutter_model_get_column_type (model, column));
                gperl_value_from_sv (&value, ST (1 + i * 2 + 1));
                columns[i] = column;
                g_value_array_append (values, &value);
                g_value_unset (&value);
        }
        clutter_model_appendv (model, n_values, columns, values->values);
        g_free (columns);
        g_value_array_free (values);

=for apidoc Clutter::Model::prepend
=for signature boolean = $model->prepend ($column, $value, ...)
=cut
void
clutter_model_prepend (ClutterModel *model, ...)
    PREINIT:
        gint n_cols, i;
        gint n_values;
        guint *columns;
        GValueArray *values;
        const char *errfmt = "Usage: $model->prepend ($column, $value, ...)\n"
                             "     %s";
    CODE:
        if (items < 1 || 0 != ((items - 1) % 2))
                croak (errfmt,
                       "There must be a value for every column number");
        n_cols = clutter_model_get_n_columns (model);
        n_values = (items - 2) / 2;
        columns = g_new (guint, n_values);
        values = g_value_array_new (n_values);
        for (i = 0; i < n_values; i++) {
                gint position = -1;
                gint column = 0;
                GValue value = { 0, };
                gboolean res = FALSE;
                if (! looks_like_number (ST (1 + i * 2)))
                        croak (errfmt,
                               "The first value in each pair must be a "
                               "column index number");
                column = SvIV (ST (1 + i * 2));
                if (! (column >= 0 && column < n_cols))
                        croak (errfmt,
                               form ("Bad column index %d, model only has "
                                     "%d columns", column, n_cols));
                g_value_init (&value,
                              clutter_model_get_column_type (model, column));
                gperl_value_from_sv (&value, ST (1 + i * 2 + 1));
                columns[i] = column;
                g_value_array_append (values, &value);
                g_value_unset (&value);
        }
        clutter_model_prependv (model, n_values, columns, values->values);
        g_free (columns);
        g_value_array_free (values);

=for apidoc
=for signature $model->insert ($row, $column, $value, ...)
=cut
void
clutter_model_insert (ClutterModel *model, guint row, ...)
    PREINIT:
        gint n_cols, i;
        gint n_values;
        const char *errfmt = "Usage: $model->insert ($row, $column, $value, ...)\n     %s";
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

ClutterModelIter_noinc *
clutter_model_get_first_iter (ClutterModel *model)

ClutterModelIter_noinc *
clutter_model_get_last_iter (ClutterModel *model)

ClutterModelIter_noinc *
clutter_model_get_iter_at_row (ClutterModel *model, guint row)

void
clutter_model_set_sorting_column (ClutterModel *model, gint column)

gint
clutter_model_get_sorting_column (ClutterModel *model)

gboolean
clutter_model_filter_row (ClutterModel *model, guint row)

gboolean
clutter_model_filter_iter (ClutterModel *model, ClutterModelIter *iter)

void
clutter_model_resort (ClutterModel *model)

void
clutter_model_foreach (ClutterModel *model, SV *func, SV *data=NULL)
    PREINIT:
        GPerlCallback *cb;
        GType types[2];
    CODE:
        types[0] = CLUTTER_TYPE_MODEL;
        types[1] = CLUTTER_TYPE_MODEL_ITER;
        cb = gperl_callback_new (func, data,
                                 G_N_ELEMENTS (types), types,
                                 G_TYPE_BOOLEAN);
        clutter_model_foreach (model, clutterperl_model_foreach_func, cb);
        gperl_callback_destroy (cb);
