use Test::More tests => 12;
use Clutter;

Clutter->init();

my $behaviour = Clutter::Behaviour::Path->new(undef);
isa_ok($behaviour, 'Clutter::Behaviour::Path', 'is a path');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

ok(Clutter::Behaviour::Path->new(undef,
        Clutter::Knot->new(0, 0),
        Clutter::Knot->new(100, 0),
        Clutter::Knot->new(100, 100),
        Clutter::Knot->new(0, 100),
    ), 'ctor with object knots');
ok(Clutter::Behaviour::Path->new(undef,
        [   0,   0 ],
        [ 100,   0 ],
        [ 100, 100 ],
        [   0, 100 ],
    ), 'ctor with array knots');
ok(Clutter::Behaviour::Path->new(undef, 
        { x =>   0, y =>   0 },
        { x => 100, y =>   0 },
        { x => 100, y => 100 },
        { x =>   0, y => 100 },
    ), 'ctor with hash knots');

$behaviour = Clutter::Behaviour::Path->new(undef,
        [   0,   0 ],
        [ 100,   0 ],
        [ 100, 100 ],
        [   0, 100 ],
    );

my @knots;

@knots = $behaviour->get_knots();
is(@knots, 4, 'we have four knots');
is_deeply($knots[0], [ 0, 0 ], 'array equal');
is_deeply($knots[0], Clutter::Knot->new(0, 0), 'object equal');

$behaviour->remove_knot(2);
@knots = $behaviour->get_knots();
is(@knots, 3, 'we have three knots');

$behaviour->insert_knot(2, Clutter::Knot->new(100, 100));
@knots = $behaviour->get_knots();
is(@knots, 4, 'we have four knots again');

$behaviour->append_knot([0, 0]);
@knots = $behaviour->get_knots();
is(@knots, 5, 'we now have five knots');

$behaviour->clear();
@knots = $behaviour->get_knots();
is(@knots, 0, 'we do not have any more knots');
