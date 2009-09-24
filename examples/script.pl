#!/usr/bin/perl

use warnings;
use strict;

use Glib qw( :constants );
use Clutter qw( :init );

our $buffer =<<ENDUI;
[
  { "id" : "move-timeline",  "type" : "ClutterTimeline", "duration" : 2500 },
  { "id" : "scale-timeline", "type" : "ClutterTimeline", "duration" : 2000 },
  { "id" : "fade-timeline",  "type" : "ClutterTimeline", "duration" : 1500 },
  {
    "id" : "move-behaviour", "type" : "ClutterBehaviourPath",
    "alpha" : { "timeline" : "move-timeline", "mode" : "easeInSine" },
    "path" : "M 100,100 L 200,150"
  },
  {
    "id" : "scale-behaviour", "type" : "ClutterBehaviourScale",
    "x-scale-start" : 1.0, "x-scale-end" : 0.7,
    "y-scale-start" : 1.0, "y-scale-end" : 0.7,
    "alpha" : { "timeline" : "scale-timeline", "mode" : "easeInSine" }
  },
  {
    "id" : "fade-behaviour", "type" : "ClutterBehaviourOpacity",
    "opacity-start" : 255, "opacity-end" : 0,
    "alpha" : { "timeline" : "fade-timeline", "mode" : "linear" }
  },
  {
    "id" : "main-stage",
    "type" : "ClutterStage",
    "color" : "#ffffff",
    "visible" : true,
    "reactive" : true,
    "signals" : [
      { "name" : "key-press-event", "handler" : "do_quit" }
    ],
    "children" : [
      {
        "id" : "red-button",
        "type" : "ClutterRectangle",
        "visible" : true,
        "reactive" : true,
        "color" : "#dd0000",
        "opacity" : 255,
        "x" : 100, "y" : 100, "width" : 300, "height" : 300,
        "rotation" : [
          { "z-axis" : [ 45, [ 200, 200 ] ] }
        ],
        "signals" : [
          { "name" : "button-press-event", "handler" : "do_press" }
        ],
        "behaviours" : [ "move-behaviour", "scale-behaviour", "fade-behaviour" ]
      }
    ]
  }
]
ENDUI

our $script = Clutter::Script->new();
our $score  = undef;

sub do_quit  { Clutter->main_quit(); }
sub do_press {
    my ($actor, $event) = @_;

    $score->start();

    return TRUE;
}

eval { $script->load_from_data($buffer); };
if ($@) {
    warn "Unable to load the UI definition:\n$@";
    exit 1;
}

$script->connect_signals(undef);

my ($move_timeline, $scale_timeline, $fade_timeline) =
  $script->get_object('move-timeline', 'scale-timeline', 'fade-timeline');

$score = Clutter::Score->new();
$score->append(undef,           $move_timeline );
$score->append($move_timeline,  $scale_timeline);
$score->append($scale_timeline, $fade_timeline );
$score->signal_connect(completed => \&do_quit);

my $stage = $script->get_object('main-stage');
die "Unable to retrieve the 'main-stage' object\n" unless defined $stage;

$stage->show_all();

Clutter->main();

0;
