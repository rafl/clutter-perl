use Test::More tests => 9;
use Clutter;

Clutter->init();

my $behaviour = Clutter::Behaviour::Path->new();
isa_ok($behaviour, 'Clutter::Behaviour::Path', 'is a path');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

$behaviour = Clutter::Behaviour::Path->new(undef, [
        [   0,   0 ],
        [ 100,   0 ],
        [ 100, 100 ],
        [   0, 100 ],
    ]);
isa_ok($behaviour, 'Clutter::Behaviour::Path', 'ctor with array knots');

$behaviour = Clutter::Behaviour::Path->new(undef, [
        { x =>   0, y =>   0 },
        { x => 100, y =>   0 },
        { x => 100, y => 100 },
        { x =>   0, y => 100 },
    ]);
isa_ok($behaviour, 'Clutter::Behaviour::Path', 'ctor with hash knots');

my @knots;

@knots = $behaviour->get_knots();
is(@knots, 4, 'we have four knots');

$behaviour->remove_knot(2);
@knots = $behaviour->get_knots();
is(@knots, 3, 'we have three knots');

$behaviour->insert_knot(2, Clutter::Knot->new(100, 100));
@knots = $behaviour->get_knots();
is(@knots, 4, 'we have four knots again');

$behaviour->append_knot(Clutter::Knot->new(0, 0));
@knots = $behaviour->get_knots();
is(@knots, 5, 'we now have five knots');

$behaviour->clear();
@knots = $behaviour->get_knots();
is(@knots, 0, 'we do not have any more knots');
