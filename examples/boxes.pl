#!/usr/bin/perl

use warnings;
use strict;

use Glib qw( :constants );
use Clutter qw( :init );

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->new(0x00, 0x00, 0x00, 0xff));
$stage->signal_connect(key_press_event => sub { Clutter->main_quit(); });

my $vbox = Clutter::VBox->new();
$vbox->set_position(100, 100);
$vbox->set_spacing(10);

for (1 .. 3) {
    my $hbox = Clutter::HBox->new();
    $hbox->set_spacing(10);

    for (1 .. 3) {
        my $rect = Clutter::Rectangle->new();
        $rect->set_color(Clutter::Color->new(0xff, 0xff, 0xff, 0x99));
        $rect->set_size(100, 100);

        $hbox->pack_start($rect);
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
