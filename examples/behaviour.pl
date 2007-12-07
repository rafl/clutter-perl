package Clutter::Ex::Behaviour::Rotate;

# behaviour.pl: Example showing the behaviours API in Clutter
# Copyright (C) 2007  OpenedHand, Ltd.
# Author: Emmanuele Bassi
#
# This is free software. Permission to redistribute and/or modify it under
# the same terms of Perl itself.

use strict;
use warnings;

use Glib;
use Clutter;

# we need to register these enums first hand, so that the
# object registering code can find them when defining the
# properties of the Clutter::Ex::Behaviour::Rotate.
sub BEGIN {
    Glib::Type->register_enum(
        'Clutter::Ex::RotateDirection',
        'clockwise',
        'anticlockwise',
    );

    Glib::Type->register_enum(
        'Clutter::Ex::RotateAxis',
        'x',
        'y',
        'z',
    );
}

use Glib::Object::Subclass
    'Clutter::Behaviour',
    signals => { },
    properties => [
        Glib::ParamSpec->double(
            'angle-start',
            'Angle Start',
            'Initial angle value',
            0.0, 359.0, 0.0,
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->double(
            'angle-end',
            'Angle End',
            'Final angle value',
            0.0, 359.0, 359.0,
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->enum(
            'direction',
            'Direction',
            'Direction of the rotation',
            'Clutter::Ex::RotateDirection',
            'clockwise',
            [ qw( readable writable ) ],
        ),
        Glib::ParamSpec->enum(
            'axis',
            'Axis',
            'Axis of the rotation',
            'Clutter::Ex::RotateAxis',
            'z',
            [ qw( readable writable ) ],
        ),
    ]
    ;

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{angle_start} =   0.0;
    $self->{angle_end}   = 359.0;
    $self->{direction}   = 'clockwise';
    $self->{axis}        = 'z';
}

sub ALPHA_NOTIFY {
    my ($self, $alpha_value) = @_;

    my $angle = $alpha_value
              * ($self->{angle_end} - $self->{angle_start})
              / Clutter::Alpha->MAX_ALPHA;

    my @actors = $self->get_actors();
    return unless scalar @actors;

    foreach my $actor (@actors) {
        $actor->set_rotation('z-axis', $angle,
                             $actor->get_x() - 100,
                             $actor->get_y() - 100,
                             0);
    }
}

package main;

use strict;
use warnings;

use Glib qw( :constants );
use Gtk2;
use Clutter qw( :init );

my $stage = Clutter::Stage->get_default();
$stage->set_color(Clutter::Color->new(0xcc, 0xcc, 0xcc, 0xff));
$stage->signal_connect(key_press_event => sub { Clutter->main_quit(); });

my $group = Clutter::Group->new();
$stage->add($group);
$group->show();

my $rect = Clutter::Rectangle->new();
$rect->set_size(100, 100);
$rect->set_position(0, 0);
$rect->set_color(Clutter::Color->new(0x33, 0x22, 0x22, 0xff));
$rect->set_border_width(10);
$rect->set_border_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xff));

$group->add($rect);
$rect->show();

my $pixbuf;
eval { $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file('redhand.png'); };
if ($@) {
    warn ("Unable to load 'redhand.png': $@");
}
else {
    my $hand = Clutter::Texture->new($pixbuf);
    $hand->set_position(5, 5);

    $rect->set_size($pixbuf->get_width()  + 5,
                    $pixbuf->get_height() + 5);

    $group->add($hand);
    $hand->show();
}

my $timeline = Clutter::Timeline->new(100, 26);
$timeline->set(loop => TRUE);

my $alpha = Clutter::Alpha->new($timeline, \&Clutter::Alpha::sine);
my $o_behave = Clutter::Behaviour::Opacity->new($alpha, 0x33, 0xff);
$o_behave->apply($group);

my $p_behave
    = Clutter::Behaviour::Path->new($alpha,
        [   0,   0 ],
        [   0, 300 ],
        [ 300, 300 ],
        [ 300,   0 ],
        [   0,   0 ],
      );
$p_behave->apply($group);

my $r_behave
    = Clutter::Ex::Behaviour::Rotate->new(alpha => $alpha);
$r_behave->apply($group);

$timeline->start();

$stage->show();

Clutter->main();

0;
