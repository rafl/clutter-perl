use Math::Trig;
use Glib ':constants';
use Cairo;
use Clutter ':init';

my @easing_modes = (
);

my $current_mode = 0;

sub make_bouncer {
    my ($color, $width, $height) = @_;

    my $res = Clutter::CairoTexture->new($width, $height);
    my $cr = $res->create_context();

    $cr->set_operator('clear');
    $cr->paint();
    $cr->set_operator('add');

    my $radius = $width > $height ? $width : $height;

    $cr->arc($radius / 2, $radius / 2, $radius / 2, 0.0, 2.0 * pi);

    my $pattern = Cairo::RadialGradient->create(
        $radius / 2,
        $radius / 2,
        0.0,
        $radius,
        $radius,
        $radius
    );
    $pattern->add_color_stop_rgba(
        0.0,
        $color->red / 255,
        $color->green / 255,
        $color->blue / 255,
        $color->alpha / 255,
    );
    $pattern->add_color_stop_rgba(
        0.9,
        $color->red / 255,
        $color->green / 255,
        $color->blue / 255,
        $color->alpha / 255,
    );

    $cr->set_source($pattern);
    $cr->fill_preserve();

    $res->set_name("bouncer");
    $res->set_size($width, $height);

    return $res;
}

sub main {
    my @modes = qw(
        quad
        cubic
        quart
        quint
        sine
        expo
        circ
        elastic
        back
        bounce
    );

    foreach my $mode (@modes) {
        foreach my $variant (qw/ in out in-out /) {
            push @easing_modes, {
                name  => "$variant $mode",
                value => 'ease-' . $variant . '-' . $mode,
            }
        }
    }

    unshift @easing_modes, { name => 'linear', value => 'linear' };

    my $stage = Clutter::Stage->get_default();
    $stage->set_color(Clutter::Color->new(0x88, 0x88, 0xdd, 0xff));

    my ($stage_width, $stage_height) = $stage->get_size();

    my $bounce = make_bouncer (Clutter::Color->new(0xee, 0x33, 0, 0xff), 50, 50);
    $stage->add($bounce);
    $bounce->set_anchor_point(50 / 2, 50 / 2);
    $bounce->set_position($stage_width / 2, $stage_height / 2);

    my $text = "Easing mode: " . $easing_modes[$current_mode]->{name} . "\n"
             . "Right click to change the easing mode";

    my $label = Clutter::Text->new("Sans 18px", $text);
    $stage->add($label);
    $label->set_position($stage_width - $label->get_width() - 10,
                         $stage_height - $label->get_height() - 10);

    $stage->signal_connect("button-press-event" => sub {
        my ($actor, $event) = @_;

        if ($event->button == 3) {
            $current_mode = ($current_mode + 1 < scalar @easing_modes)
                          ? $current_mode + 1
                          : 0;

            my $text = "Easing mode: " . $easing_modes[$current_mode]->{name} . "\n"
                     . "Right click to change the easing mode";
            $label->set_text($text);
            $label->set_position($stage_width - $label->get_width() - 10,
                                 $stage_height - $label->get_height() - 10);

            return TRUE;
        }
        elsif ($event->button == 1) {
            my $cur_mode = $easing_modes[$current_mode]->{value};

            $bounce->animate($cur_mode, 1000, x => $event->x, y => $event->y);

            return TRUE;
        }
        else {
            return FALSE;
        }
    });

    $stage->show();

    Clutter->main();
}

exit(main());
