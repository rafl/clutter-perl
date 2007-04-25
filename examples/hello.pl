#!/usr/bin/perl

# hello.pl: Simple Hello, World application using Clutter
# Copyright (C) 2007  OpenedHand, Ltd.
# Author: Emmanuele Bassi
#
# This is free software. Permission to redistribute and/or modify it under
# the same terms of Perl itself.

use strict;
use warnings;

use Clutter qw( :init );
use Clutter::Keysyms;

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->parse('DarkSlateGray'));
$stage->signal_connect('button-press-event' => sub { Clutter->main_quit() });
$stage->signal_connect('key-press-event'    => sub {
    my ($stage, $event) = @_;

    Clutter->main_quit() if ($event->keyval == $Clutter::Keysyms{Escape});
});
$stage->set_size(800, 600);

my $label = Clutter::Label->new("Sans 30", "Hello, Clutter!");
$label->set_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xdd));
$label->set_position(($stage->get_width()  - $label->get_width())  / 2,
                     ($stage->get_height() - $label->get_height()) / 2);
$stage->add($label);
$stage->show_all();

Clutter->main();

0;
