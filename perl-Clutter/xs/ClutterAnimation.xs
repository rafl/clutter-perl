#include "clutter-perl-private.h"

MODULE = Clutter::Animation     PACKAGE = Clutter::Animation    PREFIX = clutter_animation_

=for object Clutter::Animation - Animate object properties
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $animation = Clutter::Animation->new();

    # 500 milliseconds of duration
    $animation->set_duration(500);

    # cubic easing mode
    $animation->set_mode('ease-out-cubic');

    # set the object we want to animate
    $animation->set_object($texture);

    # bind the properties we want to animate on the object; bind()
    # calls can be chained up to
    $animation->bind('scale-x', 2.0)
              ->bind('scale-y', 2.0)
              ->bind('opacity', 255);

    # start the animation
    $animation->get_timeline()->start();

    # set the object as reactive when the animation ends
    $animation->signal_connect(completed => sub {
        $animation->get_object()->set_reactive(TRUE);
    })

=head1 DESCRIPTION

B<Clutter::Animation> is an class providing simple, implicit animations
for L<Glib::Object> instances.

Clutter::Animation instances will bind one or more object properties
belonging to a Glib::Object to a L<Clutter::Interval>, and will then use a
L<Clutter::Alpha> to interpolate the property between the initial and final
values of the interval.

The duration of the animation is set using Clutter::Animation::set_duration().
The easing mode of the animation is set using Clutter::Animation::set_mode().

=head2 Controlling the Animation

If you want to control the animation you should retrieve the
L<Clutter::Timeline> using Clutter::Animation::get_timeline() and then
use L<Clutter::Timeline> methods like Clutter::Timeline::start(),
Clutter::Timeline::pause() or Clutter::Timeline::stop().

A Clutter::Animation will emit the Clutter::Animation::completed signal
when the L<Clutter::Timeline> used by the animation is completed; unlike
L<Clutter::Timeline>, though, the Clutter::Animation::completed will not be
emitted if Clutter::Animation:loop is set to %TRUE - that is, a looping
animation never completes.

If your animation depends on user control you can force its completion
using Clutter::Animation::completed().

If the Glib::Object instance bound to a Clutter::Animation implements the
Clutter::Animatable interface it is possible for that instance to control
the way the initial and final states are interpolated.

=head2 Changing the Animation

The initial and final value of a property bound to the Animation are
controlled by a L<Clutter::Interval> instance. You can retrieve the
Interval instance and change the values, or you can change the Interval
instance itself:

    # increase the scaling factor
    $animation->get_interval('scale-x')->set_final_value(2.5);
    $animation->get_interval('scale-y')->set_final_value(2.5);

    # change the opacity interval
    $cur_value = $animation->get_object()->get_opacity();
    $interval = Clutter::Interval->new('Glib::Uchar');
    $interval->set_interval($cur_value, 128);
    $animation->update_interval('opacity', $interval);

=head2 Differences between Animation and Behaviour

Clutter::Animation is distinguished from L<Clutter::Behaviour> because
the former can only control Glib::Object properties of a single Glib::Object
instance, while the latter can control multiple properties using accessor
functions inside the L<Clutter::Behaviour>::ALPHA_NOTIFY virtual function,
and can control multiple L<Clutter::Actor>s at the same time.

=head2 Convenience API

For convenience, it is possible to use the Clutter::Actor::animate()
method which will take care of setting up and tearing down a
Clutter::Animation instance and animate an actor between its current
state and the specified final state:

    $texture->animate(
        'ease-out-cubic', 500,
        scale_x => 2.0,
        scale_y => 2.0,
        opacity => 255
    )->signal_connect(completed => sub { $texture->set_reactive(TRUE) })

The example above reproduces the same animation as the one in the Synopsis.

The Clutter::Animation instance created by Clutter::Actor::animate() is
managed by the animate() method itself and it is guaranteed to be valid for
as long as the animation is running; once the animation emits the I<completed>
signal, the animation will still be valid from within handlers connected to
that signal, until the default signal handler is executed.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Timeline>, L<Clutter::Alpha>, L<Clutter::Behaviour>,
L<Clutter::Interval>, L<Clutter::Actor>.

=cut

=for enum Clutter::AnimationMode
=cut

=for apidoc
Creates a new Clutter::Animation
=cut
ClutterAnimation *clutter_animation_new (class);
    C_ARGS:
        /* void */

=for apidoc
Sets the object to be animated. The I<object> must be set before calling
Clutter::Animation::bind() or Clutter::Animation::bind_interval()
=cut
void clutter_animation_set_object (ClutterAnimation *animation, GObject *object);

=for apidoc
Retrieves the object set using Clutter::Animation::set_object()
=cut
GObject *clutter_animation_get_object (ClutterAnimation *animation);

=for apidoc
Sets the easing mode of I<animation>. The easing mode can either be a value
of the Clutter::AnimationMode enumeration or the logical id returned by
Clutter::Alpha::register_func() for custom easing modes
=cut
void clutter_animation_set_mode (ClutterAnimation *animation, SV *mode);
    CODE:
        clutter_animation_set_mode (animation, clutter_perl_animation_mode_from_sv (mode));

=for apidoc
Retrieves the easing mode as set using Clutter::Animation::set_mode()
=cut
SV *clutter_animation_get_mode (ClutterAnimation *animation);
    CODE:
        RETVAL = clutter_perl_animation_mode_to_sv (clutter_animation_get_mode (animation));
    OUTPUT:
        RETVAL

=for apidoc
Sets the duration of I<animation>, in milliseconds
=cut
void clutter_animation_set_duration (ClutterAnimation *animation, gint msecs);

=for apidoc
Gets the duration set using Clutter::Animation::set_duration()
=cut
guint clutter_animation_get_duration (ClutterAnimation *animation);

=for apidoc
Sets whether I<animation> should loop. A looping animation will never emit
the I<completed> signal
=cut
void clutter_animation_set_loop (ClutterAnimation *animation, gboolean loop);

=for apidoc
Retrieves whether I<animation> is looping or not
=cut
gboolean clutter_animation_get_loop (ClutterAnimation *animation);

void clutter_animation_set_timeline (ClutterAnimation *animation, ClutterTimeline *timeline);

ClutterTimeline *clutter_animation_get_timeline (ClutterAnimation *animation);

void clutter_animation_set_alpha (ClutterAnimation *animation, ClutterAlpha *alpha);

ClutterAlpha *clutter_animation_get_alpha (ClutterAnimation *animation);

=for apidoc
Binds I<property_name> to the animation.

An implicit L<Clutter::Interval> will be created which will use:

=over 4

=item the type of the property

=item the current value as the initial value

=item the passed I<final> value as the final value

=back

This method will croak if I<animation> does not have an object set.
=cut
ClutterAnimation *clutter_animation_bind (animation, property_name, final)
        ClutterAnimation *animation
        const gchar *property_name
        SV *final
    PREINIT:
        GValue value = { 0, };
        GObject *obj;
        GObjectClass *klass;
        GParamSpec *pspec;
    CODE:
        obj = clutter_animation_get_object (animation);
        if (obj == NULL) {
                croak ("No object to animate has been set");
        }
        klass = G_OBJECT_GET_CLASS (obj);
        pspec = g_object_class_find_property (klass, property_name);
        if (pspec == NULL) {
                croak ("No property named '%s' for object of type '%s'",
                       property_name,
                       G_OBJECT_TYPE_NAME (obj));
        }
        g_value_init (&value, G_PARAM_SPEC_VALUE_TYPE (pspec));
        if (!gperl_value_from_sv (&value, final)) {
                croak ("Unable to convert value");
        }
        RETVAL = clutter_animation_bind (animation, property_name, &value);
        g_value_unset (&value);
    OUTPUT:
        RETVAL


ClutterAnimation *clutter_animation_bind_interval (animation, property_name, interval)
        ClutterAnimation *animation
        const gchar *property_name
        ClutterInterval *interval

gboolean clutter_animation_has_property (ClutterAnimation *animation, const gchar *property_name);

void clutter_animation_update_interval (animation, property_name, interval)
        ClutterAnimation *animation
        const gchar *property_name
        ClutterInterval *interval

void clutter_animation_unbind_property (ClutterAnimation *animation, const gchar *property_name);

ClutterInterval_noinc *clutter_animation_get_interval (ClutterAnimation *animation, const gchar *property_name);

=for apidoc
Emits the I<completed> signal on I<animation>
=cut
void clutter_animation_completed (ClutterAnimation *animation);

