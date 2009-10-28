use warnings;
use strict;

use Math::Trig ':pi';
use Cairo;
use Clutter ':init';

sub main {
    my $stage = Clutter::Stage->get_default();
    $stage->set_color(Clutter::Color->new(0xff, 0xcc, 0xcc, 0xff));
    $stage->set_title('Clutter::Cairo');
    $stage->set_size(400, 300);

    my $texture = Clutter::CairoTexture->new(200, 200);
    $texture->set_position(($stage->get_width()  - 200) / 2,
                           ($stage->get_height() - 200) / 2);

    my $cr = $texture->create_context();
    $cr->scale(200, 200);

    $cr->set_line_width(0.1);
    $cr->set_source_rgba(0, 0, 0, 1);
    $cr->translate(0.5, 0.5);
    $cr->arc(0, 0, 0.4, 0, pi2);
    $cr->stroke();
    $cr = undef;

    $texture->set_rotation('y-axis', 45.0,
                           $texture->get_width()  / 2,
                           0,
                           $texture->get_height() / 2);
    
    $stage->add($texture);
    $texture->show();
    $stage->show();

    Clutter->main();

    return 0;
}

exit(main());
