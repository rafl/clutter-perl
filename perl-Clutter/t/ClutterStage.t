use Clutter::TestHelper tests => 7;

my $stage = Clutter::Stage->get_default;
isa_ok($stage, 'Clutter::Actor', 'is a bird');
isa_ok($stage, 'Clutter::Group', 'is a plane');
isa_ok($stage, 'Clutter::Stage', 'no, is a Clutter::Stage');

my $color = Clutter::Color->new(255, 0, 0, 0);
$stage->set_color($color);
is($stage->get_color->red, 255, 'check set color (red)');
isnt($stage->get_color->green, 255, 'check set color (green)');

$stage->set_size(800, 600);
is($stage->get_width, 800, 'check width');
isnt($stage->get_height, 800, 'check height');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
