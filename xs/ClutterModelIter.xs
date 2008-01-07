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

MODULE = Clutter::Model::Iter   PACKAGE = Clutter::Model::Iter  PREFIX = clutter_model_iter_

=for apidoc
=for arg ... of column indices

Fetch and return the model's values in the row pointed to by I<$iter>.
If you specify no column indices, it returns the values for all of the
columns, otherwise, returns just those columns' values (in order).

=cut
void
clutter_model_iter_get_values (ClutterModelIter *iter, ...)
    PREINIT:
        int i;
    PPCODE:
        if (items > 1) {
                for (i = 1 ; i < items ; i++) {
                        GValue gvalue = { 0, };
                        clutter_model_iter_get_value (iter,
                                                      SvIV (ST (i)),
                                                      &gvalue);
                        XPUSHs (sv_2mortal (gperl_sv_from_value (&gvalue)));
                        g_value_unset (&gvalue);
                }
        }
        else {
                ClutterModel *model = clutter_model_iter_get_model (iter);
                guint n_columns = clutter_model_get_n_columns (model);
                for( i = 0; i < n_columns; i++ ) {
                        GValue gvalue = { 0, };
                        clutter_model_iter_get_value (iter, i, &gvalue);
                        XPUSHs (sv_2mortal (gperl_sv_from_value (&gvalue)));
                        g_value_unset (&gvalue);
                }
        }

=for apidoc
=for arg ... of column, value pairs

Sets the model's values in the row pointed to by I<$iter>.

=cut
void
clutter_model_iter_set_values (ClutterModelIter *iter, ...)
    PREINIT:
        ClutterModel *model;
        guint n_cols;
        int i;
        const char *errfmt = "Usage: $iter->set_values ($column, $value, ...)\n"
                             "     %s";
    CODE:
        if (items < 1 || 0 != ((items - 1) % 2))
                croak (errfmt, "There must be a value for every column number");
        model = clutter_model_iter_get_model (iter);
        n_cols = clutter_model_get_n_columns (model);
        for (i = 1 ; i < (items - 1); i++) {
                GValue gvalue = { 0, };
                GType t = G_TYPE_INVALID;
                gint column = 0;
                if (! looks_like_number (ST (1 + i * 2)))
                        croak (errfmt, "The first value in each pair must be "
                                       "a column index number");
                column = SvIV (ST (1 + i * 2));
                if (! (column >= 0 && column < n_cols))
                        croak (errfmt, form ("Bad column index %d, model only "
                                             "has %d columns",
                                             column, n_cols));
                t = clutter_model_get_column_type (model, column);
                if (t == G_TYPE_INVALID)
                        croak (errfmt, form ("Invalid type for column "
                                             "index %d (internal error)",
                                             column));
                g_value_init (&gvalue, t);
                gperl_value_from_sv (&gvalue, ST ((1 + i * 2) + 1));
                clutter_model_iter_set_value (iter, column, &gvalue);
                g_value_unset (&gvalue);
        }

gboolean
clutter_model_iter_is_first (ClutterModelIter *iter)

gboolean
clutter_model_iter_is_last (ClutterModelIter *iter)

ClutterModelIter_noinc *
clutter_model_iter_next (ClutterModelIter *iter)

ClutterModelIter_noinc *
clutter_model_iter_prev (ClutterModelIter *iter)

ClutterModel_noinc *
clutter_model_iter_get_model (ClutterModelIter *iter)

guint
clutter_model_iter_get_row (ClutterModelIter *iter)

