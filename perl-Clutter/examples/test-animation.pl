#!/bin/perl

# simple example of the Clutter::Animation class

use warnings;
use strict;

use Glib ':constants';
use Clutter;

sub main {
    my $stage = Clutter::Stage->get_default();
    $stage->set_color(Clutter::Color->new(0x66, 0x66, 0xdd, 0xff));

    my $rect = Clutter::Rectangle->new();
    $rect->set_color(Clutter::Color->new(0x44, 0xdd, 0x44, 0xff));
    $stage->add($rect);

    $rect->set_size(50, 50);
    $rect->set_anchor_point(25, 25);
    $rect->set_position($stage->get_width() / 2, $stage->get_height() / 2);
    $rect->set_opacity(127);
    $rect->set_reactive(TRUE);
    $rect->{is_expanded} = FALSE;
    $rect->{animation} = undef;

    $rect->signal_connect("button-press-event" => sub {
        my ($actor, $event) = @_;

        return if defined $rect->{animation};

        # get the current state of the actor...
        my ($old_x, $old_y) = $rect->get_position();
        my ($old_w, $old_h) = $rect->get_size();

        my (
            $new_x,
            $new_y,
            $new_w,
            $new_h,
            $new_angle,
            $new_color,
        );

        # ... and compute the final state
        unless ($rect->{is_expanded}) {
            $new_x = $old_x - 100;
            $new_y = $old_y - 100;
            $new_w = $old_w + 200;
            $new_h = $old_h + 200;

            $new_angle = 360.0;

            $new_color = Clutter::Color->new(0xdd, 0x44, 0xdd, 255);
        }
        else {
            $new_x = $old_x + 100;
            $new_y = $old_y + 100;
            $new_w = $old_w - 200;
            $new_h = $old_h - 200;

            $new_angle = 0.0;

            $new_color = Clutter::Color->new(0x44, 0xdd, 0x44, 128);
        }

        # create the animation object and set up easing mode,
        # duration and the animated object
        my $animation = Clutter::Animation->new();
        $animation->set_mode('ease-in-expo');
        $animation->set_duration(2000);
        $animation->set_object($rect);

        # keep a reference, or the animation will disappear when out
        # of scope at the end of this callback
        $rect->{animation} = $animation;

        # properties that should not be animated
        $rect->set("rotation-center-z" => Clutter::Vertex->new($new_w / 2, $new_h / 2, 0));
        $rect->set("reactive" => FALSE);

        # Animation::bind() returns a pointer to the animation, so we
        # can chain up the bind() calls and have a nice compact way to
        # define an animation involving more than one property. I find
        # this pretty cute, actually
        $animation->bind("x", $new_x)
                  ->bind("y", $new_y)
                  ->bind("width", $new_w)
                  ->bind("height", $new_h)
                  ->bind("color", $new_color)
                  ->bind("rotation-angle-z", $new_angle)
                  ->signal_connect("completed" => sub {
            my ($animation) = @_;

            my $object = $animation->get_object();

            # update the state and remove the reference on the
            # animation when it's complete
            $object->set_reactive(TRUE);

            $object->{animation} = undef;
            $object->{is_expanded} = not $object->{is_expanded};
        });

        # start the animation by starting the timeline
        $animation->get_timeline()->start();

        return TRUE;
    });

    $stage->show();

    Clutter->main();

    0;
}

Clutter->init();

exit(main());
