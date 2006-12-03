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

static void
read_knot_from_sv (SV *sv, ClutterKnot *knot)
{
        SV **svp;

        if (!sv || !SvOK (sv) || !SvROK (sv))
                croak ("invalid knot");

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
                        croak ("a knot must either be an array or a hash");
                        break;
       }
}

MODULE = Clutter::Behaviour::Path       PACKAGE = Clutter::Behaviour::Path      PREFIX = clutter_behaviour_path_

ClutterBehaviour_noinc *
clutter_behaviour_path_new (class, alpha=NULL, knots=NULL)
        ClutterAlpha_ornull *alpha
        SV *knots
    PREINIT:
        AV *av;
        ClutterKnot *k;
        gint n_knots, i;
        ClutterBehaviour *behaviour;
        ClutterBehaviourPath *path_b;
    CODE:
        if (!knots) {
                RETVAL = clutter_behaviour_path_new (alpha, NULL, 0);
        }
        else {
                if (!SvOK (knots) ||
                    !SvROK (knots) ||
                    SvTYPE (SvRV (knots)) != SVt_PVAV) {
                        croak ("knots must be a reference to an array of knots");
                }
                
                av = (AV *) SvRV (knots);
                n_knots = av_len (av) + 1;
                if (n_knots < 1) {
                        croak ("knots array is empty");
                }
                k = gperl_alloc_temp (sizeof (ClutterKnot) * n_knots);
                for (i = 0; i < n_knots; i++) {
                        SV **svp = av_fetch (av, i, 0);
                        read_knot_from_sv (*svp, k + i);
                }
                behaviour = clutter_behaviour_path_new (alpha, NULL, 0);
                RETVAL = behaviour;
                path_b = CLUTTER_BEHAVIOUR_PATH (behaviour);
                for (i = 0; i < n_knots; i++) {
                        clutter_behaviour_path_append_knot (path_b, &(k[i]));
                }
        }
    OUTPUT:
        RETVAL

void
clutter_behaviour_path_append_knot (behaviour, knot)
        ClutterBehaviourPath *behaviour
        ClutterKnot *knot

void
clutter_behavuour_path_append_knots (behaviour, knots)
        ClutterBehaviourPath *behaviour
        SV *knots
    PREINIT:
        AV *av;
        ClutterKnot *k;
        gint n_knots, i;
    CODE:
        if (!knots ||
            !SvOK (knots) ||
            !SvROK (knots) ||
            SvTYPE (SvRV (knots)) != SVt_PVAV) {
                croak ("knots must be a reference to an array of knots");
        }
        av = (AV *) SvRV (knots);
        n_knots = av_len (av) + 1;
        if (n_knots < 1) {
                croak ("knots array is empty");
        }
        k = gperl_alloc_temp (sizeof (ClutterKnot) * n_knots);
        for (i = 0; i < n_knots; i++) {
                SV **svp = av_fetch (av, i, 0);
                read_knot_from_sv (*svp, k + i);
        }
        for (i = 0; i < n_knots; i++) {
                clutter_behaviour_path_append_knot (behaviour, &(k[i]));
        }

void
clutter_behaviour_path_insert_knot (behaviour, offset, knot)
        ClutterBehaviourPath *behaviour
        guint offset
        ClutterKnot *knot

void
clutter_behaviour_path_remove_knot (behaviour, offset)
        ClutterBehaviourPath *behaviour
        guint offset

void
clutter_behaviour_path_get_knots (behaviour)
        ClutterBehaviourPath *behaviour
    PREINIT:
        GSList *knots, *l;
    PPCODE:
        knots = clutter_behaviour_path_get_knots (behaviour);
        for (l = knots; l; l = l->next) {
                XPUSHs (sv_2mortal (newSVClutterKnot (l->data)));
        }
        g_slist_free (knots);

void
clutter_behaviour_path_clear (behaviour)
        ClutterBehaviourPath *behaviour

