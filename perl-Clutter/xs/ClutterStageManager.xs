#include "clutter-perl-private.h"

MODULE = Clutter::StageManager  PACKAGE = Clutter::StageManager PREFIX = clutter_stage_manager_

=for object Clutter::StageManager - Manages the Clutter stages
=cut

ClutterStageManager_noinc *
clutter_stage_manager_get_default (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
This function is deprecated.
=cut
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
