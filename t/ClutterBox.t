use Clutter::TestHelper tests => 2;

my $box = Clutter::HBox->new();
isa_ok($box, 'Clutter::Box', 'is a box');
isa_ok($box, 'Clutter::Actor', 'is an actor');

$box->set_default_padding(0, 1, 2, 3);

my ($top, $right, $bottom, $left) = $box->get_default_padding();
eq_array([ $top, $right, $bottom, $left ], [ 0, 1, 2, 3 ], 'default padding');

$box->set_margin(Clutter::Margin->new(0, 10, 0, 10));

my @margins = $box->get_margin()->values();
eq_array(@margins, [ 0, 10, 0, 10 ], 'margin');

$box->set_color(Clutter::Color->new(0xff, 0x00, 0x00, 0xff));
my $color = $box->get_color();
eq_array($color->values(), [ 0xff, 0x00, 0x00, 0xff ], 'color');
use Clutter::TestHelper tests => 2;

my $box = Clutter::HBox->new();
isa_ok($box, 'Clutter::Box', 'is a box');
isa_ok($box, 'Clutter::Actor', 'is an actor');

$box->set_default_padding(0, 1, 2, 3);

my ($top, $right, $bottom, $left) = $box->get_default_padding();
eq_array([ $top, $right, $bottom, $left ], [ 0, 1, 2, 3 ], 'default padding');

$box->set_margin(Clutter::Margin->new(0, 10, 0, 10));

my @margins = $box->get_margin()->values();
eq_array(@margins, [ 0, 10, 0, 10 ], 'margin');

$box->set_color(Clutter::Color->new(0xff, 0x00, 0x00, 0xff));
my $color = $box->get_color();
eq_array($color->values(), [ 0xff, 0x00, 0x00, 0xff ], 'color');
