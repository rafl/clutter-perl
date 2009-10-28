#!/usr/bin/perl

# hello.pl: Simple Hello, World application using Clutter
# Copyright (C) 2007  OpenedHand, Ltd.
# Author: Emmanuele Bassi
#
# This is free software. Permission to redistribute and/or modify it under
# the same terms of Perl itself.

use strict;
use warnings;

use constant FONT_DESC  => 'Sans 96px';

use Math::Trig qw( :pi );
use Glib qw( :constants );
use Clutter qw( :init );
use Clutter::Keysyms;

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->from_string('DarkSlateGray'));
$stage->signal_connect('button-press-event' => sub { Clutter->main_quit() });
$stage->signal_connect('key-press-event'    => sub {
    my ($stage, $event) = @_;

    Clutter->main_quit()
        if ($event->keyval == $Clutter::Keysyms{Escape});
});
$stage->set_size(800, 600);
$stage->show();

my $timeline = Clutter::Timeline->new(3000);
$timeline->set_loop(TRUE);

my $alpha = Clutter::Alpha->new($timeline);
$alpha->set_func(sub {
    return sin($alpha->get_timeline()->get_progress() * pi);
});

my $x_offset = 64;
my $y_offset = $stage->get_height() / 2;

my @str = split(//, 'hello, clutter!', -1);
my $idx = 0;
foreach my $char (@str) {
    my $color = Clutter::Color->new(
        int(rand(255)),
        int(rand(255)),
        int(rand(255)),
        255,
    );
    my $text = Clutter::Text->new(FONT_DESC, "$char", $color);

    $text->set_position($x_offset, $y_offset);
    $stage->add($text);

    my $behaviour;

    if ($idx % 7 == 0) {
        $behaviour = Clutter::Behaviour::Opacity->new(
            $alpha,
            255, int(rand(64)),
        );
    }
    elsif ($idx % 3 == 0) {
        $behaviour = Clutter::Behaviour::Rotate->new(
            $alpha,
            'z-axis',
            ($idx % 2) ? 'cw' : 'ccw',
            0.0, 0.0,
        );
        $behaviour->set_center(
            $text->get_width(),
            $text->get_height(),
            0,
        );
    }
    elsif ($idx % 2 == 0) {
        my $final = ($idx % 5) ? 1.0 + rand(1.0) : rand(0.8);
        $behaviour = Clutter::Behaviour::Scale->new(
            $alpha,
            1.0,    1.0,
            $final, $final,
        );
        $text->move_anchor_point_from_gravity('center');
    }
    else {
        my ($x, $y) = (int(rand(50)), int(rand(50)));
        $behaviour = Clutter::Behaviour::Path->new(
            $alpha,
            Clutter::Path->new(
                [ 'move-to', [ [ $x_offset     , $y_offset      ] ] ],
                [ 'line-to', [ [ $x_offset + $x, $y_offset - $y ] ] ],
                [ 'line-to', [ [ $x_offset + $x, $y_offset + $y ] ] ],
                [ 'line-to', [ [ $x_offset - $x, $y_offset + $y ] ] ],
            ),
        );
    }

    $behaviour->apply($text);
    $text->{behaviour} = $behaviour;

    $x_offset += $text->get_width() - 5;

    $idx += 1;
}

$timeline->start();

Clutter->main();

0;
