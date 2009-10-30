#include "clutter-gst-perl.h"

MODULE = Clutter::GStreamer::VideoSink  PACKAGE = Clutter::GStreamer::VideoSink PREFIX = clutter_gst_video_sink_

GstElement *clutter_gst_video_sink_new (class, ClutterTexture *texture);
    C_ARGS:
        texture

