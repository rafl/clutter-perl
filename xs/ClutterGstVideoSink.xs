#include "clutterperl.h"

MODULE = Clutter::Gst::VideoSink        PACKAGE = Clutter::Gst::VideoSink       PREFIX = clutter_gst_video_sink_

GstElement *
clutter_gst_video_sink_new (class, ClutterTexture *texture)
    C_ARGS:
        texture
