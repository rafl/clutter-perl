package Clutter::Ex::TextureReflection;

use warnings;
use strict;

use Glib qw( :constants );
use Clutter;

use Glib::Object::Subclass
    'Clutter::Texture::Clone',
    signals => { },
    properties => [ ];

sub PAINT {
    my ($self) = @_;

    my $parent = $self->get_parent_texture();
    return unless $parent;

    my $cogl_tex = $parent->get_cogl_texture();
    return unless $cogl_tex;

    my ($width, $height) = $self->get_size();

    my $r_height = $self->{reflection_height};
    $r_height = $height if $r_height < 0 or $r_height > $height;

    my $rty = $r_height / $height;

    my $opacity = $self->get_paint_opacity();

    my $start = Clutter::Color->new(255, 255, 255, $opacity);
    my $stop  = Clutter::Color->new(255, 255, 255,        0);

    my $vertices = [
        [      0,         0, 0, 0.0, $rty,   $start],
        [ $width,         0, 0, 1.0, $rty,   $start],
        [ $width, $r_height, 0, 1.0,    0.0, $stop ],
        [      0, $r_height, 0, 0.0,    0.0, $stop ],
    ];

    Clutter::Cogl->push_matrix();

    $cogl_tex->texture_polygon($vertices, TRUE);

    Clutter::Cogl->pop_matrix();
}

sub INIT_INSTANCE {
    my ($self) = @_;

    $self->{reflection_height} = -1;
}

sub set_reflection_height {
    my ($self, $height) = @_;

    $self->{reflection_height} = $height;
}

sub get_reflection_height {
    my ($self) = @_;

    return $self->{reflection_height};
}

package main;

use Glib qw( :constants );
use Clutter qw( :init );

my $stage = Clutter::Stage->new();
$stage->set_size(640, 480);
$stage->set_color(Clutter::Color->parse('Black'));
$stage->signal_connect(destroy => sub { Clutter->main_quit() });
$stage->set_title('TextureReflection');

my $group = Clutter::Group->new();
$stage->add($group);

my $tex;
eval { $tex = Clutter::Texture->new($ARGV[0]) };
if ($@) {
    warn ("Unable to load '$ARGV[0]': $@");
    exit 1;
}

my $reflect = Clutter::Ex::TextureReflection->new();
$reflect->set_parent_texture($tex);
$reflect->set_opacity(100);

my $x_pos = ($stage->get_width() - $tex->get_width()) / 2;
$group->add($tex, $reflect);
$group->set_position($x_pos, 20);

$reflect->set_position(0, $tex->get_height() + 20);

my $timeline = Clutter::Timeline->new_for_duration(3000);
$timeline->set_loop(TRUE);
my $alpha = Clutter::Alpha->new($timeline, \&Clutter::Alpha::ramp_inc);
my $behaviour = Clutter::Behaviour::Rotate->new($alpha, 'y-axis', 'cw', 0, 360);
$behaviour->set_center($group->get_width() / 2, 0, 0);
$behaviour->apply($group);

$stage->show();

$timeline->start();

Clutter->main();

0;
