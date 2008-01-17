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

static gint
clutterperl_model_sort_func (ClutterModel *model,
                             const GValue *value_a,
                             const GValue *value_b,
                             gpointer      data)
{
        GPerlCallback *callback = data;
        GValue value = { 0, };
        gboolean retval;

        g_value_init (&value, callback->return_type);

        gperl_callback_invoke (callback, &value, model, value_a, value_b);
        
        retval = g_value_get_int (&value);
        g_value_unset (&value);

        return retval;

}

static gboolean
clutterperl_model_filter_func (ClutterModel     *model,
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

static guint
clutterperl_model_get_n_rows (ClutterModel *model)
{
  guint ret = 0;

  PREP (model);

  CALL_METHOD ("GET_N_ROWS", G_SCALAR);
  ret = POPi;

  FINISH;

  return ret;
}

static guint
clutterperl_model_get_n_columns (ClutterModel *model)
{
  guint ret = 0;

  PREP (model);

  CALL_METHOD ("GET_N_COLUMNS", G_SCALAR);
  ret = POPi;

  FINISH;

  return ret;
}

static GType
clutterperl_model_get_column_type (ClutterModel *model,
                                   guint         column)
{
  GType ret;
  SV *svret;

  PREP (model);

  CALL_METHOD ("GET_COLUMN_TYPE", G_SCALAR);
  svret = POPs;
  PUTBACK;

  ret = gperl_type_from_package (SvPV_nolen (svret));
  if (!ret)
        croak("Package %s is not registered with GPerl", SvPV_nolen (svret));

  FREETMPS;
  LEAVE;

  return ret;
}

static const gchar *
clutterperl_model_get_column_name (ClutterModel *model,
                                   guint         column)
{
  gchar *ret;
  SV *svret;

  PREP (model);

  CALL_METHOD ("GET_COLUMN_NAME", G_SCALAR);
  svret = POPs;
  PUTBACK;

  /* the implementations are meant to keep the name stored somewhere,
   * so the code requires the returned pointer to live until we get
   * out of the GET_COLUMN_NAME sub; unfortunately, this doesn't work
   * well with Perl garbage collection, so we go a little bit crazy
   * and we store a copy of the pointer inside the model itself, and
   * we clear it at the next GET_COLUMN_NAME call or when the object
   * is destroyed (whichever comes first).
   */
  ret = g_strdup (SvGChar (svret));
  g_object_set_data_full (G_OBJECT (model),
                          "clutter-perl-model-last-column-name",
                          ret,
                          g_free);

  FREETMPS;
  LEAVE;

  return ret;
}

ClutterModelIter *
clutterperl_model_insert_row (ClutterModel *model,
                              gint          index_)
{
  ClutterModelIter *ret;
  SV *svret;

  PREP (model);
  XPUSHs (sv_2mortal (newSViv (index_)));

  CALL_METHOD ("INSERT_ROW", G_SCALAR);
  svret = POPs;
  PUTBACK;

  ret = SvClutterModelIter (svret);

  FREETMPS;
  LEAVE;

  return ret;
}

void
clutterperl_model_remove_row (ClutterModel *model,
                              guint         row)
{
  PREP (model);
  XPUSHs (sv_2mortal (newSVuv (row)));

  CALL_METHOD ("REMOVE_ROW", G_VOID | G_DISCARD);

  FINISH;
}

static void
clutterperl_model_class_init (ClutterModelClass *klass)
{
  klass->get_n_rows = clutterperl_model_get_n_rows;
  klass->get_n_columns = clutterperl_model_get_n_columns;
  klass->get_column_type = clutterperl_model_get_column_type;
  klass->get_column_name = clutterperl_model_get_column_name;
  klass->remove_row = clutterperl_model_remove_row;
}

MODULE = Clutter::Model         PACKAGE = Clutter::Model        PREFIX = clutter_model_

=for position post_methods

=head1 CREATING A CUSTOM MODEL

=head2 MODEL

  package MyModel;
  use Clutter;
  use Glib::Object::Subclass
      'Clutter::Model';

=over

=item rows = GET_N_ROWS ($model)

=item columns = GET_N_COLUMNS ($model)

=item type = GET_COLUMN_TYPE ($model)

=item name = GET_COLUMN_NAME ($model)

=item iterator = INSERT_ROW ($model, $position)

  sub INSERT_ROW {
      my ($model, $position) = @_;

      if ($position > 0)     {
        # if position is a positive integer, set at the given position
        @{$model->{data}}[$position] = { col1 => undef, col2 => "Default", };
      }
      elsif ($position == 0) {
        # if position is zero, then prepend
      }
      else                   {
        # if position is a negative integer, then append
        push @{$model->{data}}, { col1 => undef, col2 => undef, };
        $position = scalar @{$model->{data}};
      }

      # return the iterator for the new row
      return Glib::Object->new('MyModel::Iter',
                               model => $model,
                               row   => $position);
  }

=item REMOVE_ROW ($model, $position)

=item iterator = GET_ITER_AT_ROW ($model, $position)

=item RESORT ($model)

=head2 ITERATORS

  package MyModel::Iter;
  use Clutter;
  use MyModel;
  use Glib::Object::Subclass
      'Clutter::Model::Iter';

=over

=item boolean = IS_LAST ($iter)

=item NEXT ($iter)

=item boolean = IS_FIRST ($iter)

=item PREV ($iter)

=item model = GET_MODEL ($iter)

=item row = GET_ROW ($iter)

=item value = GET_VALUE ($iter, $column)

=item SET_VALUE ($iter, $column, $value)

=back

=cut

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
        guint *columns;
        GValueArray *values;
        const char *errfmt = "Usage: $model->insert ($row, $column, $value, ...)\n"
                             "     %s";
    CODE:
        if (items < 2 || 0 != (items % 2))
                croak (errfmt, "There must be a value for every column number");
        n_cols = clutter_model_get_n_columns (model);
        n_values = (items - 2) / 2;
        columns = g_new (guint, n_values);
        values = g_value_array_new (n_values);
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
                columns[i] = column;
                g_value_array_append (values, &value);
                g_value_unset (&value);
        }
        clutter_model_insertv (model, row, n_values, columns, values->values);
        g_free (columns);
        g_value_array_free (values);

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

void
clutter_model_set_sort (model, column, func, data=NULL)
        ClutterModel *model
        guint column
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb;
        GType types[3];
    CODE:
        types[0] = CLUTTER_TYPE_MODEL;
        types[1] = G_TYPE_VALUE;
        types[2] = G_TYPE_VALUE;
        cb = gperl_callback_new (func, data,
                                 G_N_ELEMENTS (types), types,
                                 G_TYPE_INT);
        clutter_model_set_sort (model, column,
                                clutterperl_model_sort_func, cb,
                                (GDestroyNotify) gperl_callback_destroy);

void
clutter_model_set_filter (model, func, data=NULL)
        ClutterModel *model
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *cb;
        GType types[2];
    CODE:
        types[0] = CLUTTER_TYPE_MODEL;
        types[1] = CLUTTER_TYPE_MODEL_ITER;
        cb = gperl_callback_new (func, data,
                                 G_N_ELEMENTS (types), types,
                                 G_TYPE_BOOLEAN);
        clutter_model_set_filter (model,
                                  clutterperl_model_filter_func, cb,
                                  (GDestroyNotify) gperl_callback_destroy);


=for apidoc Clutter::Model::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterModelClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with GPerl", package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_MODEL)) {
                croak("package `%s' (%s) is not a Clutter::Model",
                      package,
                      g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s'",
                      g_type_name (gtype));
        }
        clutterperl_model_class_init (klass);

=for apidoc Clutter::Model::GET_N_ROWS __hide__
=cut

=for apidoc Clutter::Model::GET_N_COLUMNS __hide__
=cut

guint
GET_N_ROWS (ClutterModel *model)
    PREINIT:
        ClutterModelClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (model);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_MODEL)) {
                croak ("parent of %s is not a Clutter::Model",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->get_n_rows) {
                RETVAL = klass->get_n_rows (model);
        }
        else {
                RETVAL = 0;
        }
    OUTPUT:
        RETVAL

guint
GET_N_COLUMNS (ClutterModel *model)
    PREINIT:
        ClutterModelClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (model);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_MODEL)) {
                croak ("parent of %s is not a Clutter::Model",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->get_n_columns) {
                RETVAL = klass->get_n_columns (model);
        }
        else {
                RETVAL = 0;
        }
    OUTPUT:
        RETVAL

