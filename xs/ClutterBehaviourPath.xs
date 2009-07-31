#include "clutterperl.h"

#define HFETCHIV(hv,key) \
        (((svp = hv_fetch ((hv), (key), strlen ((key)), FALSE)) \
          && SvOK (*svp))                                       \
          ? SvIV (*svp)                                         \
          : 0)

#define AFETCHIV(av,index) \
        (((svp = av_fetch ((av), (index), FALSE))               \
          && SvOK (*svp))                                       \
          ? SvIV (*svp)                                         \
          : 0)

static GPerlBoxedWrapperClass clutter_knot_wrapper_class;

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

        av_push (av, newSVuv (knot->x));
        av_push (av, newSVuv (knot->y));

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

MODULE = Clutter::Behaviour::Path       PACKAGE = Clutter::Knot PREFIX = clutter_knot_

BOOT:
        PERL_UNUSED_VAR (file);
        clutter_knot_wrapper_class = * gperl_default_boxed_wrapper_class ();
        clutter_knot_wrapper_class.wrap = clutter_knot_wrap;
        clutter_knot_wrapper_class.unwrap = clutter_knot_unwrap;
        gperl_register_boxed (CLUTTER_TYPE_KNOT, "Clutter::Knot",
                              &clutter_knot_wrapper_class);

gboolean
clutter_knot_equal (ClutterKnot *knot_a, ClutterKnot *knot_b)


MODULE = Clutter::Behaviour::Path       PACKAGE = Clutter::Behaviour::Path      PREFIX = clutter_behaviour_path_

=for apidoc
=for signature behaviour = Clutter::Behaviour::Path->new ($alpha, ...)
=for arg knot (__hide__)
=for arg ... list of knots
=cut
ClutterBehaviour_noinc *
clutter_behaviour_path_new (class, alpha=NULL, path=NULL)
        ClutterAlpha_ornull *alpha
        ClutterPath_ornull *path
    CODE:
        RETVAL = clutter_behaviour_path_new (alpha, path);
    OUTPUT:
        RETVAL

ClutterPath_noinc *
clutter_behaviour_path_get_path (ClutterBehaviourPath *behaviour)

void
clutter_behaviour_path_set_path (ClutterBehaviourPath *behaviour, ClutterPath_ornull *path)
