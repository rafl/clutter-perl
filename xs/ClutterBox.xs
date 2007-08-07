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

ClutterBoxChild *
SvClutterBoxChild (SV *data)
{
        ClutterBoxChild *box_child;

        if ((!data) || (!SvOK (data)) || (!SvRV (data)))
                croak("Invalid scalar");

        if ((SvTYPE (SvRV (data)) != SVt_PVAV) ||
            (SvTYPE (SvRV (data)) != SVt_PVHV))
                croak("Either an arrayref or an hashref expected:\n"
                      "  list form:\n"
                      "    [ actor, child_coords, pack_type, padding, ]\n"
                      "  hash form:\n"
                      "    {\n"
                      "      actor        => $actor,\n"
                      "      child_coords => $actor_box,\n"
                      "      pack_type    => $pack_type,\n"
                      "      padding      => $padding,\n"
                      "    }\n"
                      "  ");

        box_child = g_slice_new0 (ClutterBoxChild);

        if (SvTYPE (SvRV (data)) == SVt_PVAV) {
                AV *a;
                SV **value;

                a = (AV *) SvRV (data);
                
                value = av_fetch (a, 0, 0);
                if (value && SvOK (*value))
                        box_child->actor = SvClutterActor (*value);
                
                value = av_fetch (a, 1, 0);
                if (value && SvOK (*value)) {
                        ClutterActorBox *box = SvClutterActorBox (*value);

                        memcpy (&(box_child->child_coords), box,
                                sizeof (ClutterActorBox));
                }

                value = av_fetch (a, 2, 0);
                if (value && SvOK (*value)) {
                        ClutterPackType type;
                        gint n;

                        if (looks_like_number (*value))
                                type = SvIV (*value);
                        else {
                                if (!gperl_try_convert_enum (CLUTTER_TYPE_PACK_TYPE, *value, &n))
                                        croak("SvClutterBoxChild: 'pack_type' "
                                              "should be an integer or a "
                                              "ClutterPackType");
                                
                                type = (ClutterPackType) n;
                        }

                        box_child->pack_type = type;
                }

                value = av_fetch (a, 3, 0);
                if (value && SvOK (*value)) {
                        ClutterPadding *padding = SvClutterPadding (*value);

                        memcpy (&(box_child->padding), padding,
                                sizeof (ClutterPadding));
                }
        }
        else {
                HV *h;
                SV **value;

                h = (HV *) SvRV (data);
                
                value = hv_fetch (h, "actor", 5, 0);
                if (value && SvOK (*value))
                        box_child->actor = SvClutterActor (*value);
                else
                        croak("SvClutterBoxChild: 'actor' key needed");

                value = hv_fetch (h, "child_coords", 12, 0);
                if (value && SvOK (*value)) {
                        ClutterActorBox *box = SvClutterActorBox (*value);

                        memcpy (&(box_child->child_coords), box,
                                sizeof (ClutterActorBox));
                }
                else
                        croak("SvClutterBoxChild: 'child_coords' key needed");

                value = hv_fetch (h, "pack_type", 9, 0);
                if (value && SvOK (*value)) {
                        ClutterPackType type;
                        gint n;

                        if (looks_like_number (*value))
                                type = SvIV (*value);
                        else {
                                if (!gperl_try_convert_enum (CLUTTER_TYPE_PACK_TYPE, *value, &n))
                                        croak("SvClutterBoxChild: 'pack_type' "
                                              "should be an integer or a "
                                              "ClutterPackType");

                                type = (ClutterPackType) n;
                        }

                        box_child->pack_type = type;
                }
                else
                        croak("SvClutterBoxChild: 'pack_type' key needed");
                
                value = hv_fetch (h, "padding", 7, 0);
                if (value && SvOK (*value)) {
                        ClutterPadding *padding = SvClutterPadding (*value);

                        memcpy (&(box_child->padding), padding,
                                sizeof (ClutterPadding));
                }
                else
                        croak("SvClutterBoxChild: 'padding' key needed");
        }

        return box_child;
}

SV *
newSVClutterBoxChild (ClutterBoxChild *box_child)
{
        HV *h;
        SV *sv;
        HV *stash;

        if (!box_child)
                return newSVsv (&PL_sv_undef);

        h = newHV ();
        sv = newRV_noinc ((SV *) h);

        hv_store (h, "actor", 5,
                  newSVClutterActor (box_child->actor), 0);

        hv_store (h, "child_coords", 12,
                  newSVClutterActorBox (&(box_child->child_coords)), 0);

        hv_store (h, "pack_type", 9,
                  newSVClutterPackType (box_child->pack_type), 0);

        hv_store (h, "padding", 7,
                  newSVClutterPadding (&(box_child->padding)), 0);

        /* bless this stuff */
        sv_bless (sv, gv_stashpv ("Clutter::BoxChild", TRUE));
        
        return sv;
}

static void
clutterperl_box_pack_child (ClutterBox      *box,
                            ClutterBoxChild *child)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (box));
        GV *slot = gv_fetchmethod (stash, "PACK_CHILD");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterBox (box));
                PUSHs (newSVClutterBoxChild (child));

                PUTBACK;

                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

                SPAGAIN;

                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_box_unpack_child (ClutterBox      *box,
                              ClutterBoxChild *child)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (box));
        GV *slot = gv_fetchmethod (stash, "UNPACK_CHILD");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterBox (box));
                PUSHs (newSVClutterBoxChild (child));

                PUTBACK;

                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

                SPAGAIN;

                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_box_class_init (ClutterBoxClass *klass)
{
  klass->pack_child = clutterperl_box_pack_child;
  klass->unpack_child = clutterperl_box_unpack_child;
}

MODULE = Clutter::Box   PACKAGE = Clutter::Box  PREFIX = clutter_box_

=for enum Clutter::PackType
=cut

void
clutter_box_set_color (ClutterBox *box, const ClutterColor *color)

ClutterColor_copy *
clutter_box_get_color (ClutterBox *box)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_box_get_color (box, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

void
clutter_box_set_margin (ClutterBox *box, const ClutterMargin *margin)

ClutterMargin_copy *
clutter_box_get_margin (ClutterBox *box)
    PREINIT:
        ClutterMargin margin = { 0, };
    CODE:
        clutter_box_get_margin (box, &margin);
        RETVAL = &margin;
    OUTPUT:
        RETVAL

void
clutter_box_set_default_padding (box, top=0, right=0, bottom=0, left=0)
        ClutterBox *box
        gint top
        gint right
        gint bottom
        gint left

=for apidoc
=for signature (top, right, bottom, left) = $box->get_default_padding
=cut
void
clutter_box_get_default_padding (ClutterBox *box)
    PREINIT:
        gint top, right, bottom, left;
    PPCODE:
        clutter_box_get_default_padding (box, &top, &right, &bottom, &left);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSViv (top)));
        PUSHs (sv_2mortal (newSViv (right)));
        PUSHs (sv_2mortal (newSViv (bottom)));
        PUSHs (sv_2mortal (newSViv (left)));

void
clutter_box_pack_defaults (ClutterBox *box, ClutterActor *actor)

void
clutter_box_pack (box, actor, pack_type, padding)
        ClutterBox *box
        ClutterActor *actor
        ClutterPackType pack_type
        ClutterPadding *padding

void
clutter_box_remove_all (ClutterBox *box)

=for apidoc
=for signature (actor, coords, pack_type, padding) = $box->query_child ($actor)
Queries I<box> for its child. If I<actor> is a child of I<box>, a list
containing a reference to the actor and the pack type is returned.
=cut
void
clutter_box_query_child (ClutterBox *box, ClutterActor *actor)
    PREINIT:
        ClutterBoxChild query;
    PPCODE:
        if (clutter_box_query_child (box, actor, &query))
                PUSHs (sv_2mortal (newSVClutterBoxChild (&query)));

=for apidoc
=for signature box_child = $box->query_nth_child ($index)
=for arg index (integer)
Queries I<box> for its child at I<index>.
=cut
void
clutter_box_query_nth_child (ClutterBox *box, guint index)
    PREINIT:
        ClutterBoxChild query;
    PPCODE:
        if (clutter_box_query_nth_child (box, index, &query))
                PUSHs (sv_2mortal (newSVClutterBoxChild (&query)));

=for apidoc Clutter::Box::PACK_CHILD __hide__
=cut

=for apidoc Clutter::Box::UNPACK_CHILD __hide__
=cut

void
PACK_CHILD (ClutterBox *box, SV *child)
    PREINIT:
        ClutterBoxClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
        ClutterBoxChild *box_child;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (box);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_BOX)) {
                croak ("parent of %s is not a Clutter::Box",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->pack_child) {
                box_child = SvClutterBoxChild (child);
                klass->pack_child (box, box_child);
                g_slice_free (ClutterBoxChild, box_child);
        }

void
UNPACK_CHILD (ClutterBox *box, SV *child)
    PREINIT:
        ClutterBoxClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
        ClutterBoxChild *box_child;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (box);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_BOX)) {
                croak ("parent of %s is not a Clutter::Box",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->unpack_child) {
                box_child = SvClutterBoxChild (child);
                klass->unpack_child (box, box_child);
                g_slice_free (ClutterBoxChild, box_child);
        }

=for apidoc Clutter::Box::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterBoxClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with Clutter-Perl",
                      package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_BOX)) {
                croak("package `%s' (%s) is not a Clutter::Box",
                      package, g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s' (%d)",
                      g_type_name (gtype), gtype);
        }
        clutterperl_box_class_init (klass);
