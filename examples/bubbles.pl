use warnings;
use strict;

use Math::Trig qw( :pi );
use Cairo;
use Glib qw( :constants );
use Clutter qw( :init );

use constant {
    N_BUBBLES   => 50,

    BUBBLE_R    => 128, # bubble radius
    BUBBLE_D    => 10,  # bubble delta

    SCREEN_W    => 640, # stage width
    SCREEN_H    => 480, # stage height
};

sub bubble_y_notify {
    my ($actor, $pspec, $stage) = @_;

    return if $actor->get_y() > -$actor->get_height();

    my $size = BUBBLE_R / 4 + int(rand(BUBBLE_R * 2));
    $actor->set_size($size, $size);
    $actor->set_rotation('z-axis', rand(360), $size / 2, $size / 2, 0);
    $actor->set_position(
        rand(SCREEN_W - BUBBLE_R),
        SCREEN_H * 2 + rand(SCREEN_H * 3),
    );

    $actor->{linear}  =  0.5 + rand(3.0);
    $actor->{angular} = -0.5 + rand(0.5);
}

sub create_bubble {
    my $bubble = Clutter::CairoTexture->new(
        BUBBLE_R * 2,
        BUBBLE_R * 2,
    );

    my $cr = $bubble->create_context();

    $cr->set_operator('clear');
    $cr->paint();

    $cr->set_operator('add');

    $cr->arc(BUBBLE_R, BUBBLE_R, BUBBLE_R, 0.0, pi2);

    my $pattern = Cairo::RadialGradient->create(
        BUBBLE_R,
        BUBBLE_R,
        0.0,
        BUBBLE_R,
        BUBBLE_R,
        BUBBLE_R,
    );
    $pattern->add_color_stop_rgba(0  , 0.88, 0.95, 0.99, 0.1);
    $pattern->add_color_stop_rgba(0.6, 0.88, 0.95, 0.99, 0.1);
    $pattern->add_color_stop_rgba(0.8, 0.67, 0.83, 0.91, 0.2);
    $pattern->add_color_stop_rgba(0.9, 0.50, 0.67, 0.88, 0.7);
    $pattern->add_color_stop_rgba(1.0, 0.30, 0.43, 0.69, 0.8);

    $cr->set_source($pattern);
    $cr->fill_preserve();

    $pattern = Cairo::LinearGradient->create(
        0,
        0,
        BUBBLE_R * 2,
        BUBBLE_R * 2,
    );
    $pattern->add_color_stop_rgba(0.00, 1.0, 1.0, 1.0, 0.00);
    $pattern->add_color_stop_rgba(0.15, 1.0, 1.0, 1.0, 0.95);
    $pattern->add_color_stop_rgba(0.30, 1.0, 1.0, 1.0, 0.00);
    $pattern->add_color_stop_rgba(0.70, 1.0, 1.0, 1.0, 0.00);
    $pattern->add_color_stop_rgba(0.85, 1.0, 1.0, 1.0, 0.95);
    $pattern->add_color_stop_rgba(1.00, 1.0, 1.0, 1.0, 0.00);

    $cr->set_source($pattern);
    $cr->fill();

    $cr = undef;    # uload the contents

    return $bubble;
}

sub main {
    my $stage = Clutter::Stage->new();
    $stage->set_size(SCREEN_W, SCREEN_H);
    $stage->set_color(Clutter::Color->new(0xe0, 0xf2, 0xfc, 0xff));
    $stage->signal_connect(destroy => sub { Clutter->main_quit(); });

    my $timeline = Clutter::Timeline->new(5000);
    $timeline->set_loop(TRUE);

    # the original bubble; we will be cloning it to avoid creating
    # all the textures, so we need to hide it after adding it to
    # the stage
    my $bubble = create_bubble();
    $stage->add($bubble);
    $bubble->hide();

    my @bubbles = ();
    foreach my $index (1 .. N_BUBBLES) {
        my $actor = Clutter::Clone->new($bubble);

        $actor->set_position(
            $index * BUBBLE_R * 2,
                -1 * BUBBLE_R * 2,
        );
        $actor->signal_connect("notify::y" => \&bubble_y_notify, $stage);

        $stage->add($actor);

        bubble_y_notify($actor, undef, $stage);

        push @bubbles, $actor;
    }

    $timeline->signal_connect(new_frame => sub {
        my ($t, $elapsed) = @_;

        foreach my $b (@bubbles) {
            my $linear  = $b->{linear};
            my $angular = $b->{angular};

            $angular *= BUBBLE_D;

            $b->set_y($b->get_y() - ($linear * BUBBLE_D));
            $b->set_x($b->get_x() - $angular);

            $angular += ($b->get_rotation('z-axis'))[0];

            if    ($angular > 360) {
                $angular -= 360;
            }
            elsif ($angular <   0) {
                $angular += 360;
            }

            my $radius = $b->get_width() / 2;
            $b->set_rotation('z-axis', $angular, $radius, $radius, 0);
        }
    });
    $timeline->start();

    $stage->show();

    Clutter->main();

    0;
}

exit(main());
