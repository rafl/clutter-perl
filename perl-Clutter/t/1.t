use Test::More tests => 14;

use Clutter;

my $color = Clutter::Color->new(0x00, 0x00, 0x00, 0x00);
isa_ok($color, 'Clutter::Color', 'color is a Clutter::Color');
is($color->red, 0x00, 'no red');
is($color->blue, 0x00, 'no blue');
is($color->green, 0x00, 'no green');
isnt($color->alpha, 255, 'no alpha');
eq_array($color->values, [ 0x00, 0x00, 0x00, 0x00 ], 'black');

is($color->red(255), 0, 'change red');
is($color->red, 255, 'check change');

my $geometry = Clutter::Geometry->new(0, 0, 100, 100);
isa_ok($geometry, 'Clutter::Geometry', 'geometry is a Clutter::Geometry');
is($geometry->x, 0, 'right');
is($geometry->y, 0, 'up');
is($geometry->width, 100, 'width');
is($geometry->height, 100, 'height');

is($geometry->width(200), 100, 'change width');
isnt($geometry->width, 100, 'check change');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
