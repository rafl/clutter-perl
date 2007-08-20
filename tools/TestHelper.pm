package Clutter::TestHelper;

use strict;
use warnings;
use Test::More;
use Carp;

our $VERSION = '0.01';

sub import
{
    shift;
    my %opts = (@_);

    plan skip_all => $opts{skip_all}
        if $opts{skip_all};

    croak "test must be provided at import"
        unless exists $opts{tests};

    if ($opts{at_least_version}) {
        my ($rmajor, $rminor, $rmicro, $text) = @{$opts{at_least_version}};

        plan skip_all => $text
            unless Clutter->CHECK_VERSION($rmajor, $rminor, $rmicro);
    }

    if ($opts{sub_module}) {
        my @modules = Clutter->SUPPORTED_MODULES();
        my $no_skip = 0;

        foreach my $m (@modules) {
            $no_skip = 1 if $opts{sub_module} eq $m;
        }

        plan skip_all => "no support for $opts{sub_module}"
            unless $no_skip;
    }

    if (!Clutter->init()) {
        plan skip_all => 'Clutter->init failed';
    }
    else {
        plan tests => $opts{tests};
    }

    # forcibly turn on warnings and strictness in the caller
    $^W = 1;
    @_ = ();
    goto &strict::import;
}

package main;

# we obviously need Clutter
use Clutter;

# and Test::More
use Test::More;

# enforce the use of these constants in the tests
use Glib qw( TRUE FALSE );

1;
__END__

=head1 NAME

Clutter::TestHelper - Simple wrapper module for testing Clutter

=head1 SYNOPSIS

  use Clutter::TestHelper tests => 10;

=head1 DESCRIPTION

A simple wrapper module around L<Test::More> that makes Clutter test suite
easier to write. When importing the module, L<Clutter> is also imported and
initialised. In case the initialisation process fails, likely to happen if
the C<DISPLAY> environment variable is not set, all the planned tests are
just skipped.

=head1 OPTIONS

=over

=item tests => $number

The number of tests to be performed

=item at_least_version => [ $major, $minor, $micro, $reason ]

A reference to a list that is checked with Clutter->CHECK_VERSION

=item skip_all

Simply skip all tests

=item sub_module => $module_name

Skip all tests if Clutter was not compiled against I<module_name>.

=back

=head1 AUTHORS

Emmanuele Bassi  E<lt>ebassi (AT) openedhand (DOT) comE<gt>

This module heavily borrows from the equivalent L<Gtk2::TestHelper> module
written by the Gtk2-Perl team.

=head1 COPYRIGHT

Copyright (C) 2007  OpenedHand, Ltd.

Released under the terms of Clutter itself.

=cut
package Clutter::TestHelper;

use strict;
use warnings;
use Test::More;
use Carp;

our $VERSION = '0.01';

sub import
{
    shift;
    my %opts = (@_);

    plan skip_all => $opts{skip_all} if $opts{skip_all};

    croak "test must be provided at import" unless exists $opts{tests};

    if ($opts{at_least_version}) {
        my ($rmajor, $rminor, $rmicro, $text) = @{$opts{at_least_version}};

        plan skip_all => $text
            unless Clutter->CHECK_VERSION($rmajor, $rminor, $rmicro);
    }

    if (!Clutter->init()) {
        plan skip_all => 'Clutter->init failed';
    }
    else {
        plan tests => $opts{tests};
    }

    # forcibly turn on warnings and strictness in the caller
    $^W = 1;
    @_ = ();
    goto &strict::import;
}

package main;

use Clutter;
use Test::More;

use Glib qw( TRUE FALSE );

1;
__END__

=head1 NAME

Clutter::TestHelper - Simple wrapper module for testing Clutter

=head1 SYNOPSIS

  use Clutter::TestHelper tests => 10;

=head1 DESCRIPTION

A simple wrapper module around L<Test::More> that makes Clutter test suite
easier to write. When importing the module, L<Clutter> is also imported and
initialised. In case the initialisation process fails, likely to happen if
the C<DISPLAY> environment variable is not set, all the planned tests are
just skipped.

=head1 OPTIONS

=over

=item tests

The number of tests to be performed

=item at_least_version

A reference to a list that is checked with Clutter->CHECK_VERSION

=item skip_all

Simply skip all tests

=back

=head1 AUTHORS

Emmanuele Bassi  E<lt>ebassi (AT) openedhand (DOT) comE<gt>

This module heavily borrows from the equivalent L<Gtk2::TestHelper> module
written by the Gtk2-Perl team.

=head1 COPYRIGHT

Copyright (C) 2007  OpenedHand, Ltd.

Released under the terms of Clutter itself.

=cut
