use Test::More tests => 8;

use Clutter '-init';

my $group = Clutter::Group->new;
isa_ok($group, 'Clutter::Group', 'check ISA');

$group->set_size(800, 600);
is($group->get_width, 800, 'check width');
isnt($group->get_height, 800, 'check height');

my @children = $group->get_children;
is(@children, 0, 'no children yet');

my $rectangle = Clutter::Rectangle->new;
$group->add($rectangle);

@children = $group->get_children;
is(@children, 1, 'just one children');
eq_array(@children, [ $rectangle, ], 'check children');

is($rectangle->get_parent, $group, 'check add');

$group->remove($rectangle);
isnt($rectangle->get_parent, $group, 'check remove');

@children = $group->get_children;
is(@children, 0, 'no children left');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
