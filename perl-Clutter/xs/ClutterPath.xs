#include "clutter-perl-private.h"

#define HFETCHIV(hv,key) \
        (((svp = hv_fetch ((hv), (key), strlen ((key)), FALSE)) \
          && gperl_sv_is_defined (*svp)                         \
          && SvIOK (*svp))                                      \
          ? SvIV (*svp)                                         \
          : 0)

#define AFETCHIV(av,index) \
        (((svp = av_fetch ((av), (index), FALSE))               \
          && gperl_sv_is_defined (*svp)                         \
          && SvIOK (*svp))                                      \
          ? SvIV (*svp)                                         \
          : 0)

static GPerlBoxedWrapperClass clutter_knot_wrapper_class;
static GPerlBoxedWrapperClass clutter_path_node_wrapper_class;

static ClutterPathNodeType
get_path_node_type_from_sv (SV *sv)
{
        gint retval = 0;

        if (!gperl_sv_is_defined (sv))
                croak ("Undefined node type");

        if (looks_like_number (sv)) {
                retval = SvIV (sv);
        }
        else {
                gboolean res;
                
                res = gperl_try_convert_enum (CLUTTER_TYPE_PATH_NODE_TYPE, sv, &retval);
                if (!res) {
                        croak ("Unable to convert node type");
                }
        }

        return retval;
}

static void
get_path_node_points_from_sv (SV *sv, ClutterPathNode *node)
{
        gint n_points, i;
        AV *av;

        if (node->type == CLUTTER_PATH_CLOSE)
                return;

        if (!sv || !SvOK (sv) || !SvRV (sv))
                croak ("The points of a path node must either be a single "
                       "ClutterKnot or a reference to an array of "
                       "ClutterKnots");

        n_points = 0;
        switch (node->type) {
                case CLUTTER_PATH_MOVE_TO:
                case CLUTTER_PATH_REL_MOVE_TO:
                        n_points = 1;
                        break;

                case CLUTTER_PATH_LINE_TO:
                case CLUTTER_PATH_REL_LINE_TO:
                        n_points = 1;
                        break;

                case CLUTTER_PATH_CURVE_TO:
                case CLUTTER_PATH_REL_CURVE_TO:
                        n_points = 3;
                        break;

                case CLUTTER_PATH_CLOSE:
                        g_assert_not_reached ();
                        return;
        }

        av = (AV *) SvRV (sv);

        if (av_len (av) != (n_points - 1))
                croak ("The path node requires %d %s",
                       n_points,
                       n_points > 1 ? "knots" : "knot");

        for (i = 0; i < n_points; i++) {
                SV **svp = av_fetch (av, i, 0);
                ClutterKnot *knot;

                knot = SvClutterKnot (*svp);
                node->points[i] = *knot;
        }
}

static SV *
clutter_knot_wrap (GType        gtype,
                   const gchar *package,
                   gpointer     boxed,
                   gboolean     own)
{
        ClutterKnot *knot = boxed;
        AV *av;

        if (!knot)
                return &PL_sv_undef;

        av = newAV ();
        av_push (av, newSViv (knot->x));
        av_push (av, newSViv (knot->y));

        if (own)
                clutter_knot_free (knot);
        
        return newRV_noinc ((SV *) av);
}

static void *
clutter_knot_unwrap (GType        gtype,
                     const gchar *package,
                     SV          *sv)
{
        ClutterKnot *knot;
        SV **svp;

        if (!sv || !SvOK (sv) || !SvRV (sv))
                return NULL;

        knot = gperl_alloc_temp (sizeof (ClutterKnot));

        switch (SvTYPE (SvRV (sv))) {
                case SVt_PVHV:
                {
                        HV *hv = (HV *) SvRV (sv);
                        knot->x = HFETCHIV (hv, "x");
                        knot->y = HFETCHIV (hv, "y");
                }
                        break;
                case SVt_PVAV:
                {
                        AV *av = (AV *) SvRV (sv);
                        knot->x = AFETCHIV (av, 0);
                        knot->y = AFETCHIV (av, 1);
                }
                        break;
                default:
                        croak ("a ClutterKnot must either be an array "
                               "or an hash with two values: x and y");
                        break;
       }

       return knot;
}

static SV *
clutter_path_node_wrap (GType        gtype,
                        const gchar *package,
                        gpointer     boxed,
                        gboolean     own)
{
        ClutterPathNode *node = boxed;
        SV *sv;
        HV *hv;
        AV *points = NULL;

        if (!node)
                return &PL_sv_undef;

        hv = newHV ();

        sv = newSVClutterPathNodeType (node->type);
        (void) hv_store (hv, "type", 4, sv, 0);

        switch (node->type) {
                case CLUTTER_PATH_MOVE_TO:
                case CLUTTER_PATH_REL_MOVE_TO:
                        points = newAV ();
                        av_push (points, newSVClutterKnot_copy (&node->points[0]));
                        break;

                case CLUTTER_PATH_LINE_TO:
                case CLUTTER_PATH_REL_LINE_TO:
                        points = newAV ();
                        av_push (points, newSVClutterKnot_copy (&node->points[0]));
                        break;

                case CLUTTER_PATH_CURVE_TO:
                case CLUTTER_PATH_REL_CURVE_TO:
                        points = newAV ();
                        av_push (points, newSVClutterKnot_copy (&node->points[0]));
                        av_push (points, newSVClutterKnot_copy (&node->points[1]));
                        av_push (points, newSVClutterKnot_copy (&node->points[2]));
                        break;

                case CLUTTER_PATH_CLOSE:
                        points = newAV ();
                        break;
        }

        sv = newRV_noinc ((SV *) points);
        (void) hv_store (hv, "points", 6, sv, 0);

        if (own)
                clutter_path_node_free (node);
        
        return newRV_noinc ((SV *) hv);
}

static void *
clutter_path_node_unwrap (GType        gtype,
                          const gchar *package,
                          SV          *sv)
{
        ClutterPathNode *node;

        if (!sv || !SvOK (sv) || !SvRV (sv))
                return NULL;

        node = gperl_alloc_temp (sizeof (ClutterPathNode));

        switch (SvTYPE (SvRV (sv))) {
                case SVt_PVHV:
                {
                        HV *hv = (HV *) SvRV (sv);
                        SV **svp;

                        svp = hv_fetch (hv, "type", 4, FALSE);
                        node->type = get_path_node_type_from_sv (*svp);

                        if (node->type == CLUTTER_PATH_CLOSE)
                                break;
                        else {
                                if (!hv_exists (hv, "points", 6)) {
                                        croak ("A node without points can only "
                                               "be of type 'close'");
                                }
                        }

                        svp = hv_fetch (hv, "points", 6, FALSE);
                        get_path_node_points_from_sv (*svp, node);
                }
                        break;

                case SVt_PVAV:
                {
                        AV *av = (AV *) SvRV (sv);
                        SV **svp;

                        svp = av_fetch (av, 0, 0);
                        node->type = get_path_node_type_from_sv (*svp);

                        if (node->type == CLUTTER_PATH_CLOSE)
                                break;
                        else {
                                if (av_len (av) == 0) {
                                        croak ("A node without points can only "
                                               "be of type 'close'");
                                }
                        }

                        svp = av_fetch (av, 1, 0);
                        get_path_node_points_from_sv (*svp, node);
                }
                        break;

                default:
                        croak ("a ClutterPathNode must either be an array or a hash");
                        break;
       }

       return node;
}

static void
clutterperl_path_sink (GObject *object)
{
        g_object_ref_sink (object);
        g_object_unref (object);
}

static GPerlCallback *
clutterperl_path_foreach_func_create (SV *func, SV *data)
{
        GType param_types[1];

        param_types[0] = CLUTTER_TYPE_PATH_NODE;

        return gperl_callback_new (func, data, 1, param_types, 0);
}

static void
clutterperl_path_foreach_func (const ClutterPathNode *node,
                               gpointer               data)
{
        gperl_callback_invoke ((GPerlCallback *) data, NULL, node);
}

MODULE = Clutter::Path  PACKAGE = Clutter::Knot PREFIX = clutter_knot_

BOOT:
        PERL_UNUSED_VAR (file);
        clutter_knot_wrapper_class = * gperl_default_boxed_wrapper_class ();
        clutter_knot_wrapper_class.wrap = clutter_knot_wrap;
        clutter_knot_wrapper_class.unwrap = clutter_knot_unwrap;
        gperl_register_boxed (CLUTTER_TYPE_KNOT, "Clutter::Knot",
                              &clutter_knot_wrapper_class);


gboolean clutter_knot_equal (ClutterKnot *knot_a, ClutterKnot *knot_b);


MODULE = Clutter::Path  PACKAGE = Clutter::Path::Node   PREFIX = clutter_path_node_

BOOT:
        PERL_UNUSED_VAR (file);
        clutter_path_node_wrapper_class = * gperl_default_boxed_wrapper_class ();
        clutter_path_node_wrapper_class.wrap = clutter_path_node_wrap;
        clutter_path_node_wrapper_class.unwrap = clutter_path_node_unwrap;
        gperl_register_boxed (CLUTTER_TYPE_PATH_NODE, "Clutter::Path::Node",
                              &clutter_path_node_wrapper_class);

=for position DESCRIPTION

=head1 DESCRIPTION

A B<Clutter::Path::Node> is a node inside a L<Clutter::Path>. Each node
is represented by a hash reference with two keys: I<type> and I<points>.
The value for I<type> can be one of the following:

=over

=item B<move-to>

=item B<line-to>

=item B<curve-to>

=item B<close>

=back

The value for I<points> is an array reference which contains zero or
more points. Points are represented by either a hash reference with two
keys I<x> and I<y>, or by an array reference that contains two doubles.

The necessary number of points depends on the I<type> of the path node:

=over

=item move-to: 1 point

=item line-to: 1 point

=item curve-to: 3 points

=item close: 0 points

=back

The semantics and ordering of the coordinate values are consistent with
Clutter::Path::add_move_to(), Clutter::Path::add_line_to(),
Clutter::Path::add_curve_to() and Clutter::Path::add_close().

=cut

=for enum Clutter::Path::NodeType
=cut

gboolean clutter_path_node_equal (ClutterPathNode *node_a, ClutterPathNode *node_b);


MODULE = Clutter::Path  PACKAGE = Clutter::Path PREFIX = clutter_path_

BOOT:
        gperl_register_sink_func (CLUTTER_TYPE_PATH, clutterperl_path_sink);

=for object Clutter::Path - An object describing a path
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

A B<Clutter::Path> contains a description of a path consisting of straight
lines and Bezier curves. This can be used in a L<Clutter::BehaviourPath> to
animate an actor moving along the path.

The path consists of a series of nodes; see L<Clutter::PathNode> for more
information on the node notation.

You can build a path using the node adding functions such as
Clutter::Path::add_line_to() or Clutter::Path::add_curve_to()

Alternatively the path can be described in a string using a subset of the SVG
path syntax. See Clutter::Path::add_string() for details.
=cut

=for apidoc
=for signature path = Clutter::Path->new ()
=for signature path = Clutter::Path->new ($description)
=for signature path = Clutter::Path->new ($node, ...)
=for arg ... (__hide__)
Creates a new path.

The optional arguments can be a stringified definition of the path, using
a subset of the SVG path syntax or a list of nodes, e.g.:

    Clutter::Path->new("M 10,10 L 200,200 z");

    # or the equivalent

    Clutter::Path->new(
        [ 'move-to', [ [ 10, 10 ] ] ],
        [ 'line-to', [ [ 200, 200 ] ] ],
        [ 'close' ],
    );
=cut
ClutterPath_noinc *clutter_path_new (class, ...);
    CODE:
        RETVAL = clutter_path_new ();
        if (items == 2) {
                if (SvTYPE (ST (1)) == SVt_PV) {
                        clutter_path_set_description (RETVAL, SvPV_nolen (ST (1)));
                }
        }
        else {
                gint i;
                for (i = 1; i < items; i++) {
                        ClutterPathNode *node = SvClutterPathNode (ST (i));
                        clutter_path_add_node (RETVAL, node);
                }
        }
    OUTPUT:
        RETVAL

=for apidoc
Replaces all the nodes in the I<path> with nodes described in I<description>.

See Clutter::Path::add_string() for the format of the path description.
=cut
gboolean clutter_path_set_description (ClutterPath *path, const gchar *description);

const gchar_ornull *clutter_path_get_description (ClutterPath *path);

=for apidoc
Draws I<path> on a Cairo::Context using the Cairo API

This method is useful in case you store a path as Clutter::Path and wish
to paint it on a Clutter::CairoTexture
=cut
void clutter_path_to_cairo_path (ClutterPath *path, cairo_t *cr);

=for apidoc
Invokes the code reference inside I<func> for each node inside I<path>.

The function will have the following parameters:

=over

=item B<node>

The current node in the path

=item B<data>

The data passed to Clutter::Path::foreach()

=back
=cut
void clutter_path_foreach (ClutterPath *path, SV *func, SV *data=NULL);
    PREINIT:
        GPerlCallback *cb;
    CODE:
        cb = clutterperl_path_foreach_func_create (func, data);
        clutter_path_foreach (path, clutterperl_path_foreach_func, cb);
        gperl_callback_destroy (cb);

=for apidoc
Clears the I<path> and removes all the nodes inside it
=cut
void clutter_path_clear (ClutterPath *path);

=for apidoc
=for signature index = $path->get_position ($progress)
=for signature (index, knot) = $path->get_position ($progress)
Retrieves the index of the node inside I<path> at the relative position
expressed as the I<progress> over the current path's length

In array context this method will also return the knot with the position
on the path given the value of I<progress>.

The I<progress> is a floating point value between 0.0 and 1.0; it usually
comes from a Clutter::Alpha or a Clutter::Interval.
=cut
void clutter_path_get_position (ClutterPath *path, gdouble progress);
    PREINIT:
        guint index_;
        ClutterKnot knot;
    PPCODE:
        index_ = clutter_path_get_position (path, progress, &knot);
        XPUSHs (sv_2mortal (newSVuv (index_)));
        if (GIMME_V == G_ARRAY) {
                XPUSHs (sv_2mortal (newSVClutterKnot (&knot)));
        }

=for apidoc
Inserts the given I<node> at the given I<index>
=cut
void clutter_path_insert_node (ClutterPath *path, gint index, ClutterPathNode *node);

=for apidoc
Removes the node at the given I<index>
=cut
void clutter_path_remove_node (ClutterPath *path, gint index);

=for apidoc
Replaces the current node at the given I<index> with a new node
=cut
void clutter_path_replace_node (ClutterPath *path, gint index, ClutterPathNode *node);

=for apidoc
Retrieves an approximation of the total length of the path
=cut
guint clutter_path_get_length (ClutterPath *path);

=for apidoc
Retrieves the node at the given I<index>
=cut
ClutterPathNode_copy *clutter_path_get_node (ClutterPath *path, guint index);
    PREINIT:
        ClutterPathNode node;
    CODE:
        clutter_path_get_node (path, index, &node);
        RETVAL = &node;
    OUTPUT:
        RETVAL

=for apidoc
=for signature (nodes) = $path->get_nodes ()
Retrieves a list of all the nodes inside I<path>
=cut
void clutter_path_get_nodes (ClutterPath *path);
    PREINIT:
        GSList *nodes, *l;
    PPCODE:
        nodes = clutter_path_get_nodes (path);
        EXTEND (SP, g_slist_length (nodes));
        for (l = nodes; l != NULL; l = l->next) {
                PUSHs (sv_2mortal (newSVClutterPathNode (l->data)));
        }
        g_slist_free (nodes);

=for apidoc
Retrieves the number of nodes inside I<path>
=cut
guint clutter_path_get_n_nodes (ClutterPath *path);

=for apidoc Clutter::Path::add_move_to
=for signature $path->add_move_to ($x, $y)
=for arg ... (__hide__)
Appends a 'move-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_rel_move_to
=for signature $path->add_rel_move_to ($x, $y)
=for arg ... (__hide__)
Appends a 'rel-move-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_line_to
=for signature $path->add_line_to ($x, $y)
=for arg ... (__hide__)
Appends a 'line-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_rel_line_to
=for signature $path->add_rel_line_to ($x, $y)
=for arg ... (__hide__)
Appends a 'rel-line-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_curve_to
=for signature $path->add_curve_to ($x1, $y1, $x2, $y2, $x3, $y3)
=for arg ... (__hide__)
Appends a 'curve-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_rel_curve_to
=for signature $path->add_rel_curve_to ($x1, $y1, $x2, $y2, $x3, $y3)
=for arg ... (__hide__)
Appends a 'rel-curve-to' node to I<path>
=cut

=for apidoc Clutter::Path::add_close
=for signature $path->add_close
=for arg ... (__hide__)
Appends a 'close' node to I<path>
=cut

=for apidoc Clutter::Path::add_string
=for signature $path->add_string ($description)
=for arg ... (__hide__)
Adds new nodes to the end of the path as described in I<description>.

The format is a subset of the SVG path format. Each node is represented
by a letter and is followed by zero, one or three pairs of coordinates.
The coordinates can be separated by spaces or a comma.

The types are:

=over

=item M - equivalent 'move-to'/'CLUTTER_PATH_MOVE_TO'
=item m - equivalent 'rel-move-to'/'CLUTTER_PATH_REL_MOVE_TO'

Take one pair of coordinates

=item L - equivalent to 'line-to'/'CLUTTER_PATH_LINE_TO'
=item l - equivalent to 'rel-line-to'/'CLUTTER_PATH_REL_LINE_TO'

Take one pair of coordinates

=item C - equivalent to 'curve-to'/'CLUTTER_PATH_CURVE_TO'
=item c - equivalent to 'rel-curve-to'/'CLUTTER_PATH_REL_CURVE_TO'

Take three pairs of coordinates

=item z - equivalent to 'close'/'CLUTTER_PATH_CLOSE'

No coordinates needed

=back

For example, to move an actor in a 100 by 100 pixel square, centered
on the point 300, 300, you could use the following path:

  M 250,350 l 0 -100 L 350,250 l 0 100 z

This function may croak on failure.
=cut

void clutter_path_add_move_to (ClutterPath *path, ...);
    ALIAS:
        Clutter::Path::add_rel_move_to  = 1
        Clutter::Path::add_line_to      = 2
        Clutter::Path::add_rel_line_to  = 3
        Clutter::Path::add_curve_to     = 4
        Clutter::Path::add_rel_curve_to = 5
        Clutter::Path::add_close        = 6
        Clutter::Path::add_string       = 7
    CODE:
        switch (ix) {
                case 0: /* move-to */
                case 1: /* rel-move-to */
                        if (items != 3) {
                                croak ("Usage: Clutter::Path::add_move_to (path, x, y)");
                        }
                        if (ix == 0) {
                                clutter_path_add_move_to (path,
                                                          SvIV (ST (1)),
                                                          SvIV (ST (2)));
                        }
                        else {
                                clutter_path_add_rel_move_to (path,
                                                              SvIV (ST (1)),
                                                              SvIV (ST (2)));
                        }
                        break;
                case 2: /* line-to */
                case 3: /* rel-line-to */
                        if (items != 3) {
                                croak ("Usage: Clutter::Path::add_line_to (path, x, y)");
                        }
                        if (ix == 2) {
                                clutter_path_add_line_to (path,
                                                          SvIV (ST (1)),
                                                          SvIV (ST (2)));
                        }
                        else {
                                clutter_path_add_rel_line_to (path,
                                                              SvIV (ST (1)),
                                                              SvIV (ST (2)));
                        }
                        break;
                case 4: /* curve-to */
                case 5: /* rel-curve-to */
                        if (items != 7) {
                                croak ("Usage: Clutter::Path::add_curve_to (path, "
                                       "x1, y1, x2, y2, x3, y3)");
                        }
                        if (ix == 4) {
                                clutter_path_add_curve_to (path,
                                                           SvIV (ST (1)),
                                                           SvIV (ST (2)),
                                                           SvIV (ST (3)),
                                                           SvIV (ST (4)),
                                                           SvIV (ST (5)),
                                                           SvIV (ST (6)));
                        }
                        else {
                                clutter_path_add_rel_curve_to (path,
                                                               SvIV (ST (1)),
                                                               SvIV (ST (2)),
                                                               SvIV (ST (3)),
                                                               SvIV (ST (4)),
                                                               SvIV (ST (5)),
                                                               SvIV (ST (6)));
                        }
                        break;
                case 6:
                        if (items != 1) {
                                croak ("Usage: Clutter::Path::add_close (path)");
                        }
                        clutter_path_add_close (path);
                        break;
                case 7:
                        if (items != 2) {
                                croak ("Usage: Clutter::Path::add_string (path, string)");
                        }
                        if (!clutter_path_add_string (path, SvPV_nolen (ST (1))))
                            croak ("Invalid path description");
                        break;
        }
