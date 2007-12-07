use Clutter::TestHelper tests => 14;

my $behaviour = Clutter::Behaviour::Ellipse->new(
    undef,            # alpha
    [   0,     0   ], # center
    [ 100,   100   ], # size
    'cw',             # direction
    [   0.0, 360.0 ]  # angles
);

isa_ok($behaviour, 'Clutter::Behaviour::Ellipse', 'is an ellipse');
isa_ok($behaviour, 'Clutter::Behaviour', 'is a behaviour');

ok(eq_array($behaviour->get_center(), [ 0, 0 ]), 'center');
is(int($behaviour->get_angle_start()), 0, 'angle start');
is(int($behaviour->get_angle_end()), 360, 'angle end');
my @angles = $behaviour->get_angles();
is(@angles, 2, 'two angles');

$behaviour->set_tilt(0.0, 180.0, 270.0);
my @tilts = $behaviour->get_tilt();
is(@tilts, 3, 'tilting on three axis');
is(int($tilts[0]), 0, 'no tilt on X');
isnt(int($tilts[1]), 90, 'tilt on Y');
is(int($tilts[2]), 270, 'tilt on Z');

is(int($behaviour->get_angle_tilt('x-axis')),     0, 'X tilt');
is(int($behaviour->get_angle_tilt('y-axis')),   180, 'Y tilt');
isnt(int($behaviour->get_angle_tilt('z-axis')), 360, 'Z tilt');

$behaviour->set_angle_tilt('x-axis', 90.0);
is(int($behaviour->get_angle_tilt('x-axis')), 90, 'X tilt');
