use Test::More tests => 4;

use Clutter '-init';

isa_ok(Clutter::Label->new, 'Clutter::Label', 'check isa');

my $label = Clutter::Label->new;

$label->set_font_name('Sans 24');
is($label->get_font_name, 'Sans 24', 'check font name');

$label->set_text('Hello, World');
is($label->get_text, 'Hello, World', 'check text');

$label = Clutter::Label->new('Sans 10', 'Hello, Clutter');
my $color = Clutter::Color->new(0xdd, 0, 0, 0x66);
$label->set_color($color);
is($label->get_color->red, 0xdd, 'check color');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
