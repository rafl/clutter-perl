use 5.008;
use strict;
use warnings;
use Cwd;
use File::Spec;
use ExtUtils::MakeMaker;

# minimum required version of dependancies we need to build
our %build_reqs = (
	'perl-ExtUtils-Depends'   => '0.2',
	'perl-ExtUtils-PkgConfig' => '1.03',
	'perl-Glib'               => '1.120', # for Glib::MakeHelper
	'perl-Gtk2'               => '1.120',
	'Clutter'                 => '0.2.3',
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends '$build_reqs{'perl-ExtUtils-Depends'}';"
           . "use ExtUtils::PkgConfig '$build_reqs{'perl-ExtUtils-PkgConfig'}';"           . "use Glib::CodeGen;"
           # just seeing if Glib is available isn't enough, make sure
           # it's recent enough, too 
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Gtk2 '$build_reqs{'perl-Gtk2'}';"
           . "use Glib::MakeHelper;"
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => {
            'Glib'                => $build_reqs{'perl-Glib'},
            'Gtk2'                => $build_reqs{'perl-Gtk2'},
            'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
            'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
         },
   );
   exit 1; # not reached
}

mkdir 'build', 0777;

our %pkgcfg = ExtUtils::PkgConfig->find(
    'clutter-0.2 >= ' . $build_reqs{Clutter}
);


our @xs_files = <xs/*.xs>;
our %pm_files = (
    'Clutter.pm' => '$(INST_LIBDIR)/Clutter.pm',
);

our %pod_files = (
    'Clutter.pm'       => '$(INST_MAN3DIR)/Clutter.$(MAN3EXT)',

    Glib::MakeHelper->do_pod_files(@xs_files),
);

# autogeneration
Glib::CodeGen->parse_maps('clutterperl');
Glib::CodeGen->write_boot(ignore => '^Clutter$');

my $cwd = cwd();
our $clutter = ExtUtils::Depends->new('Clutter', 'Gtk2');
$clutter->set_inc($pkgcfg{cflags} . ' -I./build ');
$clutter->set_libs($pkgcfg{libs});
$clutter->add_xs(@xs_files);
$clutter->add_pm(%pm_files);
$clutter->add_typemaps(map { File::Spec->catfile($cwd, $_) }
                           'build/clutterperl.typemap');
$clutter->install(qw(clutterperl.h build/clutterperl-autogen.h));
$clutter->save_config('build/IFiles.pm');

WriteMakefile(
    NAME          => 'Clutter',
    VERSION_FROM  => 'Clutter.pm', # finds $VERSION
    PREREQ_PM     => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM => 'Clutter.pm', # retrieve abstract from module
    XSPROTOARG    => '-noprototypes',
    MAN3PODS	  => \%pod_files,
    $clutter->get_makefile_vars(),
);


=pod
=unstable

print "
WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING

This is an unstable development release of Clutter.  The API is
not frozen and things are subject to change at any time.  Report any
bugs to clutter AT openedhand DOT com as soon as possible.

WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
";

=cut

sub MY::postamble
{
    return Glib::MakeHelper->postamble_clean()
         . Glib::MakeHelper->postamble_docs_full(
            DEPENDS => $clutter,
            DOCTYPES => 'doctypes',
            COPYRIGHT_FROM => 'copyright.pod',
           )
         . Glib::MakeHelper->postamble_rpms(
            'CLUTTER' => $build_reqs{'Clutter'},
            'PERL_EXTUTILS_DEPENDS' => $build_reqs{'perl-ExtUtils-Depends'},
            'PERL_EXTUTILS_PKGCONFIG' => $build_reqs{'perl-ExtUtils-PkgConfig'},
            'PERL_GLIB' => $build_reqs{'perl-Glib'},
           );
}
