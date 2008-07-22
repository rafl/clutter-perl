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

#define PREP(obj)                                       \
        dSP;                                            \
        ENTER;                                          \
        SAVETMPS;                                       \
        PUSHMARK(SP);                                   \
        PUSHs (newSVGObject ((GObject *) (obj)));

#define CALL_METHOD(name,flags)         \
        PUTBACK;                        \
        call_method ((name), (flags));  \
        SPAGAIN;

#define FINISH          \
        PUTBACK;        \
        FREETMPS;       \
        LEAVE;

static gboolean
clutterperl_model_iter_is_first (ClutterModelIter *iter)
{
  gboolean ret = FALSE;

  PREP (iter);

  CALL_METHOD ("IS_FIRST", G_SCALAR);

  ret = POPi;

  FINISH;

  return ret;
}

static gboolean
clutterperl_model_iter_is_last (ClutterModelIter *iter)
{
  gboolean ret = FALSE;

  PREP (iter);

  CALL_METHOD ("IS_FIRST", G_SCALAR);

  ret = POPi;

  FINISH;

  return ret;
}

static ClutterModelIter *
clutterperl_model_iter_next (ClutterModelIter *iter)
{
  PREP (iter);

  CALL_METHOD ("NEXT", G_VOID | G_DISCARD);

  FINISH;

  return iter;
}

static ClutterModelIter *
clutterperl_model_iter_prev (ClutterModelIter *iter)
{
  PREP (iter);

  CALL_METHOD ("PREV", G_VOID | G_DISCARD);

  FINISH;

  return iter;
}

static ClutterModel *
clutterperl_model_iter_get_model (ClutterModelIter *iter)
{
  ClutterModel *ret = NULL;
  SV *svret;

  PREP (iter);

  CALL_METHOD ("GET_MODEL", G_SCALAR);
  svret = POPs;
  PUTBACK;

  ret = SvClutterModel (svret);

  FREETMPS;
  LEAVE;

  return ret;
}

static guint
clutterperl_model_iter_get_row (ClutterModelIter *iter)
{
  guint ret = 0;

  PREP (iter);

  CALL_METHOD ("GET_ROW", G_SCALAR);
  ret = POPi;

  FINISH;

  return ret;
}

static void
clutterperl_model_iter_get_value (ClutterModelIter *iter,
                                  guint             column,
                                  GValue           *value)
{
  SV *svret;

  PREP (iter);
  XPUSHs (sv_2mortal (newSVuv (column)));

  CALL_METHOD ("GET_VALUE", G_SCALAR);
  svret = POPs;
  PUTBACK;

  gperl_value_from_sv (value, svret);

  FREETMPS;
  LEAVE;
}

static void
clutterperl_model_iter_set_value (ClutterModelIter *iter,
                                  guint             column,
                                  const GValue     *value)
{
  PREP (iter);

  XPUSHs (sv_2mortal (newSVuv (column)));
  XPUSHs (sv_2mortal (gperl_sv_from_value (value)));

  CALL_METHOD ("SET_VALUE", G_VOID | G_DISCARD);

  FINISH;
}

static void
clutterperl_model_iter_class_init (ClutterModelIterClass *klass)
{
  klass->get_model = clutterperl_model_iter_get_model;
  klass->get_row = clutterperl_model_iter_get_row;
  klass->is_first = clutterperl_model_iter_is_first;
  klass->is_last = clutterperl_model_iter_is_last;
  klass->prev = clutterperl_model_iter_prev;
  klass->next = clutterperl_model_iter_next;
  klass->get_value = clutterperl_model_iter_get_value;
  klass->set_value = clutterperl_model_iter_set_value;
}

MODULE = Clutter::Model::Iter   PACKAGE = Clutter::Model::Iter  PREFIX = clutter_model_iter_

=for apidoc
=for arg ... of column indices

Fetch and return the model's values in the row pointed to by I<iter>.
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

Sets the model's values in the row pointed to by I<iter>.

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

=for apidoc Clutter::Model::Iter::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterModelIterClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with GPerl", package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_MODEL)) {
                croak("package `%s' (%s) is not a Clutter::Model::Iter",
                      package,
                      g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s'",
                      g_type_name (gtype));
        }
        clutterperl_model_iter_class_init (klass);

