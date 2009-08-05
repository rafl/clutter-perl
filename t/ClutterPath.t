use Clutter::TestHelper tests => 21;

my $path = Clutter::Path->new();
isa_ok($path, 'Clutter::Path', 'is a path');

$path->add_move_to(10, 10);
is($path->get_n_nodes(), 1, 'one node');

$path->add_line_to(10, 20);
is($path->get_n_nodes(), 2, 'two nodes');

$path->add_close();
is($path->get_n_nodes(), 3, 'three nodes');

my $node;

$node = $path->get_node(0);
is($node->[0], 'move-to', 'first node');
is(scalar @{$node}, 2, 'type and points');
is_deeply($node->[1], [ 10, 10 ], 'third node coordinates');

$node = $path->get_node(1);
is($node->[0], 'line-to', 'second node');
is(scalar @{$node}, 2, 'type and points');
is_deeply($node->[1], [ 10, 20 ], 'third node coordinates');

$node = $path->get_node(2);
is($node->[0], 'close', 'third node');

$path->replace_node(2, [ 'line-to', { x => 20, y => 20 } ]);
is($path->get_n_nodes(), 3, 'still three nodes');
$node = $path->get_node(2);
is($node->[0], 'line-to', 'third node');
is_deeply($node->[1], [ 20, 20 ], 'third node coordinates');

$path->add_string("C 20,10 20,10 10,10");
is($path->get_n_nodes(), 4, 'four nodes');
$node = $path->get_node(3);
is($node->[0], 'curve-to', 'fourth node');
my $points = $node->[1];
is(scalar @{$points}, 3, 'three knots');
is_deeply($points, [ [ 20, 10 ], [ 20, 10 ], [ 10, 10 ] ], 'curve points');

$path->add_close();
is($path->get_n_nodes(), 5, 'five nodes');
$node = $path->get_node(4);
is($node->[0], 'close', 'last node');
is(scalar @{$node}, 1, 'just type');
