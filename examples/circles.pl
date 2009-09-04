use warnings;
use strict;

use Math::Trig qw( :pi );
use Glib qw( :constants );
use Clutter qw( :init );

use constant {
    N_CIRCLES   => 4,

    CIRCLE_W    => 128, # circle width
    CIRCLE_G    => 32,  # circle gap
    CIRCLE_S    => 4,   # circle segments

    SCREEN_W    => 640, # screen width
    SCREEN_H    => 480, # screen height
};

sub main {
    my $stage = Clutter::Stage->new();
    $stage->set_size(SCREEN_W, SCREEN_H);
    $stage->set_color(Clutter::Color->new(0xe0, 0xf2, 0xfc, 0xff));
    $stage->signal_connect(destroy => sub { Clutter->main_quit(); });

    my $timeline = Clutter::Timeline->new(5000);
    $timeline->set_loop(TRUE);

    foreach my $index (1 .. N_CIRCLES) {
        # we use rectangles because they are the perfect placeholder
        # for custom painting functions without requiring sub-classing
        # Clutter::Actor
        my $actor = Clutter::Rectangle->new();

        my $size = $index
                 * (CIRCLE_W + CIRCLE_G)
                 * 2;

        $actor->set_size($size, $size);
        $actor->set_position(
            SCREEN_W - $size / 2,
            SCREEN_H - $size / 2
        );

        $stage->add($actor);

        $actor->{angle} = rand(90.0);

        $actor->signal_connect(paint => sub {
            my $radius = $actor->get_width() / 2;

            # override the color of the material
            Clutter::Cogl->set_source_color([ 255, 255, 255, 224 ]);

            # draw each circle segment
            foreach my $i (1 .. CIRCLE_S) {
                $actor->{angle} += (pi2 / CIRCLE_S);

                my $a0 = $actor->{angle};
                my $a1 = $a0 + (pi2 / CIRCLE_S) / 2;

                # move to the segment start
                Clutter::Cogl::Path->move_to(
                    (($radius - CIRCLE_W) * cos($a0)) + $radius,
                    (($radius - CIRCLE_W) * sin($a0)) + $radius,
                );

                # upper arc
                Clutter::Cogl::Path->arc(
                    $radius,
                    $radius,
                    $radius,
                    $radius,
                    ($a0 * 180 / pi),
                    ($a1 * 180 / pi),
                );

                # line down
                Clutter::Cogl::Path->line_to(
                    (($radius - CIRCLE_W) * cos($a1)) + $radius,
                    (($radius - CIRCLE_W) * sin($a1)) + $radius,
                );

                # lower arc, backwards
                Clutter::Cogl::Path->arc(
                    $radius,
                    $radius,
                    $radius - CIRCLE_W,
                    $radius - CIRCLE_W,
                    ($a1 * 180 / pi),
                    ($a0 * 180 / pi),
                );

                # line up, by closing the path
                Clutter::Cogl::Path->close();

                # fill the shape using the default color
                Clutter::Cogl::Path->fill();

                # store the last angle for the next iteration
                $actor->{angle} = $a0;
            }

            # stop the signal emission here, to prevent the default
            # ::paint handler of Clutter::Rectangle from running
            $actor->signal_stop_emission_by_name('paint');
        });

        # let the actors spin
        my $behaviour = Clutter::Behaviour::Rotate->new(
            Clutter::Alpha->new($timeline, 'linear'),
            'z-axis',
            ($index % 2) ? 'cw' : 'ccw',
            0.0, 0.0,
        );
        $behaviour->set_center($size / 2, $size / 2, 0);
        $behaviour->apply($actor);

        # it's importat that we keep a back pointer here, to avoid
        # the behaviour reference to get out of scope and be collected
        $actor->{behaviour} = $behaviour;
    }

    $stage->show_all();

    $timeline->start();

    Clutter->main();

    0;
}

exit(main());
