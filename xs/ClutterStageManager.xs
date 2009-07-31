#include "clutterperl.h"

MODULE = Clutter::StageManager  PACKAGE = Clutter::StageManager PREFIX = clutter_stage_manager_

ClutterStageManager_noinc *
clutter_stage_manager_get_default (SV *class)
    C_ARGS:
        /* void */

void
clutter_stage_manager_set_default_stage (manager, stage)
        ClutterStageManager *manager
        ClutterStage *stage

ClutterStage_noinc *
clutter_stage_manager_get_default_stage (ClutterStageManager *manager)

void
clutter_stage_manager_list_stages (ClutterStageManager *manager)
    PREINIT:
        GSList *stages, *l;
    PPCODE:
        stages = clutter_stage_manager_list_stages (manager);
        for (l = stages; l != NULL; l = l->next) {
                XPUSHs (sv_2mortal (newSVClutterStage (l->data)));
        }
        g_slist_free (stages);
