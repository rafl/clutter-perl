/* Clutter.
 *
 * Perl bindings for the OpenGL based 'interactive canvas' library.
 *
 * Clutter Authored By Matthew Allum  <mallum@openedhand.com>
 * Perl bindings by Emmanuele Bassi  <ebassi@openedhand.com>
 * 
 * Copyright (C) 2006 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "clutterperl.h"

static const char *
clutterperl_event_get_package (ClutterEvent *event)
{
  switch (event->type)
    {
    case CLUTTER_NOTHING:
      return "Clutter::Event";
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_2BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      return "Clutter::Event::Button";
    case CLUTTER_KEY_PRESS:
    case CLUTTER_KEY_RELEASE:
      return "Clutter::Event::Key";
    case CLUTTER_MOTION:
      return "Clutter::Event::Motion";
    default:
      {
        GEnumClass *class = g_type_class_ref (CLUTTER_TYPE_EVENT_TYPE);
	GEnumValue *value = g_enum_get_value (class, event->type);
	if (value)
	  warn ("Unhandled event type `%s' (%d) in event->type",
		value->value_name,
		event->type);
	else
          warn ("Unknown value %d in event->type",
		event->type);
      }
      return "Clutter::Event";
    }
}

/* Common fields */
static void
clutterperl_event_set_time (ClutterEvent *event,
			    guint32       time_)
{
  if (!event)
    return;

  switch (event->type)
    {
    case CLUTTER_MOTION:
      event->motion.time = time_;
      break;
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_2BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      event->button.time = time_;
      break;
    case CLUTTER_KEY_PRESS:
    case CLUTTER_KEY_RELEASE:
      event->key.time = time_;
      break;
    default:
      break;
    }
}

static guint
clutterperl_event_get_time (ClutterEvent *event)
{
  guint retval = 0;

  if (!event)
    return retval;
  
  switch (event->type)
    {
    case CLUTTER_MOTION:
      retval = event->motion.time;
      break;
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_2BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      retval = event->button.time;
      break;
    case CLUTTER_KEY_PRESS:
    case CLUTTER_KEY_RELEASE:
      retval = event->key.time;
      break;
    default:
      break;
    }

  return retval;
}

static void
clutterperl_event_set_modifier_state (ClutterEvent *event,
				      guint32       state)
{
  if (!event)
    return;

  switch (event->type)
    {
    case CLUTTER_MOTION:
      event->motion.modifier_state = state;
      break;
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_2BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      event->button.modifier_state = state;
      break;
    case CLUTTER_KEY_PRESS:
    case CLUTTER_KEY_RELEASE:
      event->key.modifier_state = state;
      break;
    default:
      break;
    }
}

static guint32
clutterperl_event_get_modifier_state (ClutterEvent *event)
{
  guint32 retval = 0;

  if (!event)
    return retval;
  
  switch (event->type)
    {
    case CLUTTER_MOTION:
      retval = event->motion.modifier_state;
      break;
    case CLUTTER_BUTTON_PRESS:
    case CLUTTER_2BUTTON_PRESS:
    case CLUTTER_BUTTON_RELEASE:
      retval = event->button.modifier_state;
      break;
    case CLUTTER_KEY_PRESS:
    case CLUTTER_KEY_RELEASE:
      retval = event->key.modifier_state;
      break;
    default:
      break;
    }

  return retval;
}


/* initialized in the boot section */
static GPerlBoxedWrapperClass clutter_event_wrapper_class;
static GPerlBoxedWrapperClass *default_wrapper_class;

static SV *
clutterperl_event_wrap (GType         gtype,
			const char   *package,
			ClutterEvent *event,
			gboolean      owned)
{
  HV *stash;
  SV *sv;

  sv = default_wrapper_class->wrap (gtype, package, event, owned);

  package = clutterperl_event_get_package (event);
  stash = gv_stashpv (package, TRUE);

  return sv_bless (sv, stash);
}

static ClutterEvent *
clutterperl_event_unwrap (GType       gtype,
			  const char *package,
			  SV         *sv)
{
  ClutterEvent *event = default_wrapper_class->unwrap (gtype, package, sv);

  package = clutterperl_event_get_package (event);

  if (!sv_derived_from (sv, package))
    croak ("`%s' is not of type `%s'",
	   gperl_format_variable_for_input (sv),
	   package);

  return event;
}

MODULE = Clutter::Event		PACKAGE = Clutter::Event	PREFIX = clutter_event_

=head1 EVENT TYPES

=over

=item * L<Clutter::Event::Button>

=item * L<Clutter::Event::Key>

=item * L<Clutter::Event::Motion>

=back

=cut

=for enum ClutterEventType
=cut

BOOT:
	default_wrapper_class = gperl_default_boxed_wrapper_class ();
	clutter_event_wrapper_class = *default_wrapper_class;
	clutter_event_wrapper_class.wrap   = (GPerlBoxedWrapFunc)   clutterperl_event_wrap;
	clutter_event_wrapper_class.unwrap = (GPerlBoxedUnwrapFunc) clutterperl_event_unwrap;
	gperl_register_boxed (CLUTTER_TYPE_EVENT, "Clutter::Event",
			      &clutter_event_wrapper_class);

ClutterEvent_own *
clutter_event_new (class, type)
	ClutterEventType type
    C_ARGS:
    	type

ClutterEvent_own *
clutter_event_copy (ClutterEvent *event);

 ## since we're overriding the package names, Glib::Boxed::DESTROY won't
 ## be able to find the right destructor, because these new names don't
 ## correspond to GTypes, and Glib::Boxed::DESTROY tries to find the GType
 ## from the package into which the SV is blessed.  we'll have to explicitly
 ## tell perl what destructor to use.
void
DESTROY (sv)
	SV * sv
    ALIAS:
	Clutter::Event::Motion::DESTROY      =  1
	Clutter::Event::Button::DESTROY      =  2
	Clutter::Event::Key::DESTROY         =  3
    CODE:
	PERL_UNUSED_VAR (ix);
	default_wrapper_class->destroy (sv);

=for apidoc Clutter::Event::set_time
=for signature $event->set_time ($new_time)
=for arg ... (hide)
=for arg newtime (timestamp)
=cut

=for apidoc Clutter::Event::time __hide__
=cut

=for apidoc
=for signature $timestamp = $event->get_time
=for signature $timestamp = $event->time
=for arg ... (hide)
Get I<$event>'s time.  If that event type doesn't have a time, or if
I<$event> is undef, returns 0.
=cut	
guint
clutter_event_get_time (event, ...)
	ClutterEvent_ornull *event
    ALIAS:
        Clutter::Event::time     = 1
	Clutter::Event::set_time = 2
    CODE:
        if (ix == 0 && items != 1)
	  croak ("Usage: Clutter::Event::get_time (event)");
	if (ix == 2 && items != 2)
	  croak ("Usage: Clutter::Event::set_time (event, newtime)");
	RETVAL = clutterperl_event_get_time (event);
	if (items == 2 || ix == 2)
	  clutterperl_event_set_time (event, SvIV (ST (1)));
    OUTPUT:
        RETVAL

=for apidoc Clutter::Event::set_state
=for signature $event->set_state ($new_time)
=for arg ... (hide)
=for arg newstate (timestamp)
=cut

=for apidoc Clutter::Event::state __hide__
=cut

=for apidoc
=for signature $state = $event->get_state
=for signature $state = $event->state
=for arg ... (hide)
Get I<$event>'s state.  If that event type doesn't have a modifier state,
or if I<$event> is undef, returns 0.
=cut	
guint
clutter_event_get_state (event, ...)
	ClutterEvent_ornull *event
    ALIAS:
        Clutter::Event::state     = 1
	Clutter::Event::set_state = 2
    CODE:
        if (ix == 0 && items != 1)
	  croak ("Usage: Clutter::Event::get_state (event)");
	if (ix == 2 && items != 2)
	  croak ("Usage: Clutter::Event::set_state (event, newstate)");
	RETVAL = clutterperl_event_get_modifier_state (event);
	if (items == 2 || ix == 2)
	  clutterperl_event_set_modifier_state (event, SvIV (ST (1)));
    OUTPUT:
        RETVAL

## Event types.
##   Nothing: No event occurred.
##   Motion: The mouse has moved.
##   ButtonPress: A mouse button was pressed.
##   ButtonRelease: A mouse button was release.
##   KeyPress: A key was pressed.
##   KeyRelease: A key was released.

ClutterEventType
type (event)
	ClutterEvent * event
    CODE:
	RETVAL = event->any.type;
    OUTPUT:
	RETVAL

MODULE = Clutter::Event		PACKAGE = Clutter::Event::Motion

=for position post_hierarchy

=head1 HIERARCHY

  Clutter::Event
  +----Clutter::Event::Motion

=cut

BOOT:
	gperl_set_isa ("Clutter::Event::Motion", "Clutter::Event");

gdouble
x (ClutterEvent *event, gint newvalue=0)
    CODE:
	RETVAL = event->motion.x;
	if (items == 2)
	  event->motion.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (ClutterEvent *event, gint newvalue=0)
    CODE:
	RETVAL = event->motion.y;
	if (items == 2)
	  event->motion.y = newvalue;
    OUTPUT:
	RETVAL

MODULE = Clutter::Event		PACKAGE = Clutter::Event::Button

=for position post_hierarchy

=head1 HIERARCHY

  Clutter::Event
  +----Clutter::Event::Button

=cut

BOOT:
	gperl_set_isa ("Clutter::Event::Button", "Clutter::Event");

gdouble
x (ClutterEvent *event, gint newvalue=0)
    CODE:
	RETVAL = event->button.x;
	if (items == 2)
	  event->button.x = newvalue;
    OUTPUT:
	RETVAL

gdouble
y (ClutterEvent *event, gint newvalue=0)
    CODE:
	RETVAL = event->button.y;
	if (items == 2)
	  event->button.y = newvalue;
    OUTPUT:
	RETVAL

guint
button (ClutterEvent *event, guint newvalue=0)
    CODE:
	RETVAL = event->button.button;
	if (items == 2)
	  event->button.button = newvalue;
    OUTPUT:
	RETVAL

MODULE = Clutter::Event		PACKAGE = Clutter::Event::Key

=for position post_hierarchy

=head1 HIERARCHY

  Clutter::Event
  +----Clutter::Event::Key

=cut

BOOT:
	gperl_set_isa ("Clutter::Event::Key", "Clutter::Event");

guint
keyval (ClutterEvent *event, guint newvalue=0)
    CODE:
	RETVAL = event->key.keyval;
	if (items == 2)
	  event->key.keyval = newvalue;
    OUTPUT:
	RETVAL

guint16
hardware_keycode (ClutterEvent *event, guint16 newvalue=0)
    CODE:
	RETVAL = event->key.hardware_keycode;
	if (items == 2)
	  event->key.hardware_keycode = newvalue;
    OUTPUT:
	RETVAL
