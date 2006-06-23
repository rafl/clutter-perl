use Test::More tests => 5;

use Clutter;

my $rectangle = Clutter::Rectangle->new; 
isa_ok($rectangle, 'Clutter::Actor', 'is an actor');

my $color = Clutter::Color->new(255, 0, 0, 0);
$rectangle = Clutter::Rectangle->new($color);
is($rectangle->get_color->red, 255, 'check set color (red)');
is($rectangle->get_color->green, 0, 'check set color (green)');

$rectangle->set_size(800, 600);
is($rectangle->get_width, 800, 'check width');
isnt($rectangle->get_height, 800, 'check height');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
