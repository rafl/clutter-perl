#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use Glib qw( :constants );
use Clutter qw( :init );
use Clutter::Keysyms;

sub button_press_cb {
    my ($stage, $event) = @_;

    my ($x, $y) = $event->get_coords();
    print "*** Button ", $event->button, " pressed at ", $x, ", ", $y, "\n";

    my $actor = $stage->get_actor_at_pos ($x, $y);

    print Dumper($actor);
}

sub key_press_cb {
    my ($stage, $event) = @_;

    Clutter->main_quit() if $event->symbol eq $Clutter::Keysyms{Escape};

    print "*** Key ", $event->symbol,
          " ('", chr($event->unicode) , "') pressed\n";
}

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->new(0x00, 0x00, 0x00, 0xff));
$stage->signal_connect(button_press_event => \&button_press_cb);
$stage->signal_connect(key_press_event    => \&key_press_cb);

my $vbox = Clutter::VBox->new();
$vbox->set_default_padding(10, 0, 10, 0);
$vbox->set_position(100, 100);

for my $i (1 .. 3) {
    my $hbox = Clutter::HBox->new();

    for my $j (1 .. 3) {
        my $rect = Clutter::Rectangle->new();
        $rect->set_color(Clutter::Color->new(0xff, 0xff, 0xff, 0x99));
        $rect->set_size(100, 100);

        my $padding = Clutter::Padding->new(
            0,
            Clutter::Units->FROM_INT(10),
            0,
            Clutter::Units->FROM_INT(10),
        );

        $hbox->pack($rect, 'start', $padding);
        $rect->show();
    }

    $vbox->add($hbox);
    $hbox->show();
}

$stage->add($vbox);
$vbox->show();

$stage->show();

Clutter->main ();

0;
