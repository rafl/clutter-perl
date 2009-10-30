BEGIN { require 5.008; }

use strict;
use warnings;

use ExtUtils::MakeMaker;
use File::Spec;
use Cwd;

# minimum required version of dependancies we need to build
our %build_reqs = (
    'perl-ExtUtils-Depends'   => '0.300',
    'perl-ExtUtils-PkgConfig' => '1.030',
    'perl-Glib'               => '1.220',
    'perl-Cairo'              => '1.000',
    'perl-Pango'              => '1.140',
    'perl-Clutter'            => '1.000',
    'perl-GStreamer'          => '0.10',
    'clutter'                 => '1.0.0',
    'clutter-gst'             => '0.10.0',
);

my %PREREQ_PM = (
    'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
    'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
    'Glib'                => $build_reqs{'perl-Glib'},
    'Cairo'               => $build_reqs{'perl-Cairo'},
    'Pango'               => $build_reqs{'perl-Pango'},
    'GStreamer'           => $build_reqs{'perl-GStreamer'},
    'Clutter'             => $build_reqs{'perl-Clutter'},
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends '$build_reqs{'perl-ExtUtils-Depends'}';"
           . "use ExtUtils::PkgConfig '$build_reqs{'perl-ExtUtils-PkgConfig'}';"
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Cairo '$build_reqs{'perl-Cairo'}';"
           . "use Pango '$build_reqs{'perl-Pango'}';"
	   . "use GStreamer '$build_reqs{'perl-GStreamer'}';"
	   . "use Clutter '$build_reqs{'perl-Clutter'}';"
	   . "use Glib::CodeGen;"
	   . "use Glib::MakeHelper;"
           . "1") {
   warn <<"__EOW__";
Pre-requisites not found:
$@
Please install them manually.
__EOW__
   exit 0;
}

mkdir 'build', 0777;

# Base module
my %pkgcfg;
unless (eval { %pkgcfg = ExtUtils::PkgConfig->find('clutter-gst-0.10'); 1; }) {
    warn $@;
    exit 0;
}

# retrieve Clutter's version
my @clutter_version = split /\./, $pkgcfg{modversion};

# decide what files to use in the build based on the version we found.
my @xs_files = ();
my @xs_lists = Glib::MakeHelper->select_files_by_version("xs_files", @clutter_version);
foreach my $filename (@xs_lists) {
    my @names = Glib::MakeHelper->read_source_list_file($filename);
    push @xs_files, @names;
}

print "Loaded " . scalar(@xs_files) . " xs files for Clutter::GStreamer\n";

my %pm_files = (
    'lib/Clutter/GStreamer.pm' => '$(INST_LIBDIR)/GStreamer.pm',
);

my %pod_files = (
    'lib/Clutter/GStreamer.pm' => '$(INST_MAN3DIR)/Clutter::GStreamer.$(MAN3EXT)',

    Glib::MakeHelper->do_pod_files(@xs_files),
);

# autogeneration
Glib::CodeGen->parse_maps('clutter-gst-perl', input => [<maps-[0-9]\.[0-9]*>]);
Glib::CodeGen->write_boot(xs_files => \@xs_files, ignore => qr/^Clutter::GStreamer$/);

my @deps = qw/ Clutter GStreamer /;
my $cwd = cwd();

my $module_cflags = $pkgcfg{cflags};
my $module_libs   = $pkgcfg{libs};

my @typemaps = map { File::Spec->catfile($cwd, $_) }
               qw( build/clutter-gst-perl.typemap );

my $clutter = ExtUtils::Depends->new('Clutter::GStreamer', @deps);
$clutter->set_inc($module_cflags . ' -I./build ');
$clutter->set_libs($module_libs);
$clutter->add_xs(@xs_files);
$clutter->add_pm(%pm_files);
$clutter->add_typemaps(@typemaps);
$clutter->install(qw(clutter-gst-perl.h build/clutter-gst-perl-autogen.h));
$clutter->save_config('build/IFiles.pm');

WriteMakefile(
    AUTHOR        => 'Emmanuele Bassi <ebassi@linux.intel.com>',
    NAME          => 'Clutter::GStreamer',
    VERSION_FROM  => 'lib/Clutter/GStreamer.pm',
    ABSTRACT_FROM => 'lib/Clutter/GStreamer.pm',
    LICENSE       => 'perl, lgpl',

    # what the module requires to run
    PREREQ_PM     => \%PREREQ_PM,
    PREREQ_FATAL  => 1,

    XSPROTOARG    => '-noprototypes ',
    MAN3PODS	  => \%pod_files,

    META_MERGE    => {
        configure_requires => \%PREREQ_PM,
	no_index => { directory => [ qw/ xs / ], },
    },

    $clutter->get_makefile_vars(),
);


=pod
#=unstable

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
               COPYRIGHT_FROM => 'copyright.pod',
           );
}
