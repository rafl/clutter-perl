use Clutter::TestHelper tests => 3;

my $box = Clutter::VBox->new();
isa_ok($box, 'Clutter::VBox', 'is a vbox');
isa_ok($box, 'Clutter::Box', 'is a box');
isa_ok($box, 'Clutter::Actor', 'is an actor');
