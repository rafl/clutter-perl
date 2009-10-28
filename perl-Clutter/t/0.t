use Test::More tests => 4;
BEGIN { use_ok('Clutter'); };

my @version = Clutter->GET_VERSION_INFO;
is(@version, 3, 'version info is three items long');
ok (Clutter->CHECK_VERSION(0,0,0), 'CHECK_VERSION pass');
ok (!Clutter->CHECK_VERSION(50,0,0), 'CHECK_VERSION fail');

__END__

Copyright (C) 2006  OpenedHand Ltd.  See the file AUTHORS for the full list.
See LICENSE for more information.
