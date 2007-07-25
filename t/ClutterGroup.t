use Test::More tests => 5;

use Clutter;

Clutter->init();

my $group = Clutter::Group->new;
isa_ok($group, 'Clutter::Group', 'check ISA');

my @children = $group->get_children;
is(@children, 0, 'no children yet');

my $rectangle = Clutter::Rectangle->new;

$group->add($rectangle);
is($rectangle->get_parent, $group, 'check add');

@children = $group->get_children;
is(@children, 1, 'just one children');
eq_array(@children, [ $rectangle, ], 'check children');


$group->remove($rectangle);
@children = $group->get_children;
is(@children, 0, 'no children left');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
