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

/*
 * GInterface support
 */

#define GET_METHOD(obj, name) \
       HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (obj)); \
       GV * slot = gv_fetchmethod (stash, name);

#define METHOD_EXISTS (slot && GvCV (slot))

#define PREP(obj) \
       dSP; \
       ENTER; \
       SAVETMPS; \
       PUSHMARK (SP) ; \
       PUSHs (sv_2mortal (newSVGObject (G_OBJECT (obj))));

#define CALL \
       PUTBACK; \
       call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

#define FINISH \
       FREETMPS; \
       LEAVE;

static void
clutterperl_container_add (ClutterContainer *container,
                           ClutterActor     *actor)
{
  GET_METHOD (container, "ADD");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (actor)));

      CALL;

      FINISH;
    }
}

static void
init_child_property_value (GObject     *object, 
                           const gchar *name, 
                           GValue      *value)
{
  GParamSpec * pspec;

  pspec = clutter_container_class_find_child_property (G_OBJECT_GET_CLASS (object), name);
  if (!pspec)
    croak ("Child property %s not found in object class %s",
           name,
           G_OBJECT_TYPE_NAME (object));

  g_value_init (value, G_PARAM_SPEC_VALUE_TYPE (pspec));
}

typedef struct {
  ClutterCallback func;
  gpointer data;
} ClutterPerlContainerForeachFunc;

static void
create_callback (ClutterCallback   func,
                 gpointer          data,
                 SV              **code_return,
                 SV              **data_return)
{
  HV *stash;
  gchar *sub;
  CV *dummy = NULL;
  SV *code, *my_data;
  ClutterPerlContainerForeachFunc *stuff;

  stash = gv_stashpv ("Clutter::Container::ForeachFunc", TRUE);

  sub = g_strdup_printf ("__clutterperl_container_foreach_func_%p", data);
  dummy = newCONSTSUB (stash, sub, NULL);
  g_free (sub);

  code = sv_bless (newRV_noinc ((SV *) dummy), stash);

  stuff = g_new0 (ClutterPerlContainerForeachFunc, 1);
  stuff->func = func;
  stuff->data = data;

  my_data = newSViv (PTR2IV (stuff));
  sv_magic ((SV *) dummy, 0, PERL_MAGIC_ext, (const char *) my_data, 0);

  *code_return = code;
  *data_return = my_data;
}

static void
clutterperl_container_remove (ClutterContainer *container,
                              ClutterActor     *actor)
{
  GET_METHOD (container, "REMOVE");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (actor)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_foreach (ClutterContainer *container,
                               ClutterCallback   callback,
                               gpointer          callback_data)
{
  GET_METHOD (container, "FOREACH");

  if (METHOD_EXISTS)
    {
      SV *code, *data;

      PREP (container);

      create_callback (callback, callback_data, &code, &data);

      XPUSHs (sv_2mortal (newSVsv (code)));
      XPUSHs (sv_2mortal (newSVsv (data)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_raise (ClutterContainer *container,
                             ClutterActor     *child,
                             ClutterActor     *sibling)
{
  GET_METHOD (container, "RAISE");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));
      if (sibling)
        XPUSHs (sv_2mortal (newSVClutterActor (sibling)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_lower (ClutterContainer *container,
                             ClutterActor     *child,
                             ClutterActor     *sibling)
{
  GET_METHOD (container, "LOWER");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));
      if (sibling)
        XPUSHs (sv_2mortal (newSVClutterActor (sibling)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_sort_depth_order (ClutterContainer *container)
{
  GET_METHOD (container, "SORT_DEPTH_ORDER");

  if (METHOD_EXISTS)
    {
      PREP (container);

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_create_child_meta (ClutterContainer *container,
                                         ClutterActor     *child)
{
  GET_METHOD (container, "CREATE_CHILD_META");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));

      CALL;

      FINISH;
    }
}

static void
clutterperl_container_destroy_child_meta (ClutterContainer *container,
                                          ClutterActor     *child)
{
  GET_METHOD (container, "DESTROY_CHILD_META");

  if (METHOD_EXISTS)
    {
      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));

      CALL;

      FINISH;
    }
}

static ClutterChildMeta *
clutterperl_container_get_child_meta (ClutterContainer *container,
                                      ClutterActor     *child)
{
  GET_METHOD (container, "GET_CHILD_META");

  if (METHOD_EXISTS)
    {
      ClutterChildMeta *meta;
      int count;

      PREP (container);

      XPUSHs (sv_2mortal (newSVClutterActor (child)));

      PUTBACK;
      count = call_sv ((SV *) GvCV (slot), G_SCALAR);
      SPAGAIN;

      if (count == 1)
        {
          meta = SvClutterChildMeta (POPs);

          if (!g_type_is_a (G_OBJECT_TYPE (meta), CLUTTER_TYPE_CHILD_META))
            croak ("Object of type `%s' is not a Clutter::ChildMeta",
                   G_OBJECT_TYPE_NAME (meta));
        }
      else
        croak ("GET_CHILD_META must return a subclass of "
               "Clutter::ChildMeta");

      FINISH;

      return meta;
    }

  return NULL;
}

static void
clutterperl_container_init (ClutterContainerIface *iface)
{
  iface->add = clutterperl_container_add;
  iface->remove = clutterperl_container_remove;
  iface->foreach = clutterperl_container_foreach;
  iface->raise = clutterperl_container_raise;
  iface->lower = clutterperl_container_lower;
  iface->sort_depth_order = clutterperl_container_sort_depth_order;
  iface->create_child_meta = clutterperl_container_create_child_meta;
  iface->destroy_child_meta = clutterperl_container_destroy_child_meta;
  iface->get_child_meta = clutterperl_container_get_child_meta;
}

static void
clutterperl_container_foreach_callback (ClutterActor *actor,
                                        gpointer      user_data)
{
  GPerlCallback *callback = user_data;
  
  gperl_callback_invoke (callback, NULL, actor);
}


MODULE = Clutter::Container     PACKAGE = Clutter::Container	PREFIX = clutter_container_

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Container> is an interface for L<Clutter::Actor>s that provides a
common API for adding, removing and iterating over children.

By implementing the Clutter::Container interface with the usual L<Glib::Object>
subclassing methods it is possible to use the Clutter::Container API for
managing children.

=cut

=for position post_methods

=head1 CHILD PROPERTIES

Clutter::Container allows the management of properties that exist only when
an actor is contained inside a container.

For instance, it is possible to add a property like I<padding> to a child
actor when inside a container; such property might only be useful when adding
any actor to a specific container implementation, and might be desirable
not to have it inside the actor class itself.

In order to create child properties for a container it is needed to subclass
the L<Clutter::ChildMeta> object class using the usual L<Glib::Object>
mechanisms, like:

  package My::ChildMeta;

  use Glib::Object::Subclass
      'Clutter::ChildMeta',
      properties => [
        ...
      ];

The L<Clutter::ChildMeta> class is the class that stores and handles the
child properties. A ChildMeta instance also stores references to the
container that handles it, and to the actor it is wrapping.

The container implementation should set the package name of the ChildMeta
subclass it will use; the most convenient place is inside the INIT_INSTANCE
sub:

  sub INIT_INSTANCE {
    my ($self) = @_;

    # instance set up

    $self->set_child_meta_type('My::ChildMeta');
  }

This is enough to start using the Clutter::Container::child_set() and
Clutter::Container::child_get() methods to store and retrieve values for
the properties specified inside the ChildMeta subclass, like:

  $container->child_set($child, 'padding', [ 0, 10, 0, 10 ]);

When the child is removed from the container, the ChildMeta instance
bound to it will simply disappear.

It is also possible to exercise a higher degree of control on the creation
and destruction of the ChildMeta instances by using the CREATE_CHILD_META,
GET_CHILD_META and DESTROY_CHILD_META functions.

=head1 CREATING A CUSTOM CONTAINER ACTOR

  package MyContainer;
  use Clutter;
  use Glib::Object::Subclass
      'Clutter::Actor',
      interfaces => [ qw( Clutter::Container ) ];

=head2 Virtual Methods

In order to create a Clutter::Container actor, an implementation of the
following methods is required:

=over

=item B<< ADD ($container, $actor) >>

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

Called to add I<actor> to I<container>. The implementation should
queue a relayout of I<container> and emit the B<::actor-added> signal
once the actor has been added.

For instance:

  push @{$self->{children}}, $actor;
  $actor->set_parent($self);

  $self->queue_relayout();
  $self->signal_emit('actor-added', $actor);

=item B<< REMOVE ($container, $actor) >>

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

Called to remove I<actor> from I<container>. The implementation should emit
the B<::actor-removed> signal once the actor has been removed.

=item B<< RAISE ($container, $child, $sibling) >>

=over

=item o $container (Clutter::Container)

=item o $child (Clutter::Actor)

=item o $sibling (Clutter::Actor)

=back

Called when raising I<child> above I<sibling>. If I<sibling> is undefined,
then I<child> should be raised above every other child of I<container>.

=item B<< LOWER ($container, $child, $sibling) >>

=over

=item o $container (Clutter::Container)

=item o $child (Clutter::Actor)

=item o $sibling (Clutter::Actor)

=back

Called when lowering I<child> below I<sibling>. If I<sibling> is undefined,
then I<child> should be lowered below every other child of I<container>.

=item B<< SORT_DEPTH_ORDER ($container) >>

=over

=item o $container (Clutter::Container)

Called when resorting the list of children depending on their depth.

=back

=item B<< FOREACH ($container, $function, $data) >>

=over

=item o $container (Clutter::Container)

=item o $function (code reference)

=item o $data (scalar) data to pass to the function

=back

Called when iterating over every child of I<container>. For each child
the I<function> must be called with the actor and the passed I<data>, for
instance:

  foreach my $child (@{$container->{children}}) {
    &$function ($child, $data);
  }

This function will also be called by the B<get_children> method.

=item B<< CREATE_CHILD_META ($container, $actor) >>

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

Called when creating a new L<Clutter::ChildMeta> instance wrapping I<actor>
inside I<container>. This function should be overridden only if the
metadata class used to implement child properties needs special code
or needs to be stored inside a different data structure within I<container>.

For instance:

  sub CREATE_CHILD_META {
      my ($self, $child) = @_;

      my $meta = My::ChildMeta->new(
          container => $self,
          actor     => $child,
      );

      # store the ChildMeta into a hash using the
      # actor itself as the key
      $self->{meta}->{$child} = $meta;
  }

When overriding the I<CREATE_CHILD_META>, the I<GET_CHILD_META> and
the I<DESTROY_CHILD_META> methods should be overridden as well.

This function is called before Clutter::Container::ADD_ACTOR.

=item B<< DESTROY_CHILD_META ($container, $actor) >>

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

Called when destroying a L<Clutter::ChildMeta> instance for I<actor>.

For instance:

  sub DESTROY_CHILD_META {
      my ($self, $child) = @_;

      delete $self->{meta}->{$child};
  }

This function is called before Clutter::Actor::REMOVE_ACTOR

=item B<< childmeta = GET_CHILD_META ($container, $actor) >>

=over

=item o $container (Clutter::Container)

=item o $actor (Clutter::Actor)

=back

Called when retrieving a L<Clutter::ChildMeta> instance for I<actor>.

For instance:

  sub GET_CHILD_META {
      my ($self, $child) = @_;

      return $self->{meta}->{$child};
  }

=back

=cut

=for apidoc __hide__
=cut
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
          (GInterfaceInitFunc) clutterperl_container_init,
          NULL,
          NULL
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface_static (gtype, CLUTTER_TYPE_CONTAINER, &iface_info);
    }

=for apidoc
=for arg actor __hide__
=for arg ... list of actors
Adds a list of actors to I<container>
=cut
void
clutter_container_add (ClutterContainer *container, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
    	clutter_container_add_actor (container, actor);
	for (i = 2; i < items; i++)
	  clutter_container_add_actor (container, SvClutterActor (ST (i)));

=for apidoc
=for arg actor __hide__
=for arg ... list of actors
Removes a list of actors from I<container>
=cut
void
clutter_container_remove (ClutterContainer *container, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
        clutter_container_remove_actor (container, actor);
        for (i = 2; i < items; i++)
          clutter_container_remove_actor (container, SvClutterActor (ST (i)));

=for apidoc
=for signature actors = $container->get_children
=cut
void
clutter_container_get_children (ClutterContainer *container)
    PREINIT:
        GList *children = NULL, *l;
    PPCODE:
        children = clutter_container_get_children (container);
        if (children) {
                EXTEND (SP, (int) g_list_length (children));
                for (l = children; l != NULL; l = l->next) {
                        PUSHs (sv_2mortal (newSVClutterActor_noinc (l->data)));
                }
                g_list_free (children);
        }

void
clutter_container_foreach (container, callback, callback_data=NULL)
        ClutterContainer *container
        SV *callback
        SV *callback_data
    PREINIT:
    	GPerlCallback *real_callback;
	GType param_types [1];
    CODE:
	param_types[0] = CLUTTER_TYPE_ACTOR;
	real_callback = gperl_callback_new (callback, callback_data,
                                            1, param_types,
					    G_TYPE_NONE);
	clutter_container_foreach (container,
                                   clutterperl_container_foreach_callback,
                                   real_callback);
	gperl_callback_destroy (real_callback);

ClutterActor_ornull *
clutter_container_find_child_by_name (container, name)
        ClutterContainer *container
        const gchar *name

void
clutter_container_raise_child (container, actor, sibling)
        ClutterContainer *container
        ClutterActor *actor
        ClutterActor *sibling

void
clutter_container_lower_child (container, actor, sibling)
        ClutterContainer *container
        ClutterActor *actor
        ClutterActor *sibling

=for apidoc
=for arg ... list of property names
Returns a list of values of properties of the child
=cut
void
clutter_container_child_get (ClutterContainer *container, ClutterActor *child, ...)
    ALIAS:
        Clutter::Container::child_get_property = 1
    PREINIT:
        GValue value = { 0, };
        gint i;
    PPCODE:
        PERL_UNUSED_VAR (ix);
        EXTEND (SP, items - 1);
        for (i = 2; i < items; i++) {
                char *name = SvPV_nolen (ST (i));
                init_child_property_value (G_OBJECT (container), name, &value);
                clutter_container_child_get_property (container,
                                                      child,
                                                      name,
                                                      &value);
                PUSHs (sv_2mortal (gperl_sv_from_value (&value)));
                g_value_unset (&value);
        }

=for apidoc
=for arg ... list of property names
Sets a list of properties of the child
=cut
void
clutter_container_child_set (ClutterContainer *container, ClutterActor *child, ...)
    ALIAS:
        Clutter::Container::child_set_property = 1
    PREINIT:
        GValue value = { 0, };
        gint i;
    CODE:
        PERL_UNUSED_VAR (ix);
        if (0 != ((items - 2) % 2))
          croak ("set method expects name => value pairs "
                 "(odd number of arguments detected)");
        for (i = 2; i < items; i += 2) {
                char *name = SvPV_nolen (ST (i));
                SV *newval = ST (i + 1);
                init_child_property_value (G_OBJECT (container), name, &value);
                gperl_value_from_sv (&value, newval);
                clutter_container_child_set_property (container,
                                                      child,
                                                      name,
                                                      &value);
                g_value_unset (&value);
        }

=for apidoc
Retrieves the ChildMeta type used by I<container>
=cut
const gchar *
clutter_container_get_child_meta_type (ClutterContainer *container)
    PREINIT:
        GType gtype = G_TYPE_INVALID;
    CODE:
        gtype = CLUTTER_CONTAINER_GET_IFACE (container)->child_meta_type;
        if (gtype == G_TYPE_INVALID)
                XSRETURN_UNDEF;
        RETVAL = NULL;
        /* ClutterChildMeta are GObjects, so we should always get back
         * a valid type; however, we might get back a type the bindings
         * know nothing about, so we have to stop when we hit an
         * unknown type. Glib::Object is always known, so this loop
         * cannot go on forever
         */
        while (gtype &&
               (NULL == (RETVAL = gperl_object_package_from_type (gtype))))
                gtype = g_type_parent (gtype);
    OUTPUT:
        RETVAL

=for apidoc __gerror__
Sets the ChildMeta type used by I<container>. This type can only be
set once and only if the container implementation does not have any
ChildMeta type set already. If you try to set the ChildMeta type on
an instance with a type already set, this function will croak.
=cut
void
clutter_container_set_child_meta_type (ClutterContainer *container, const gchar *type_name)
    PREINIT:
        GType gtype = G_TYPE_INVALID;
    CODE:
        gtype = CLUTTER_CONTAINER_GET_IFACE (container)->child_meta_type;
        if (gtype != G_TYPE_INVALID)
                croak ("Container implementation of type `%s' already has "
                       "child meta type of `%s'. You should subclass `%s' "
                       "in order to change it",
                       G_OBJECT_TYPE_NAME (container),
                       g_type_name (gtype),
                       G_OBJECT_TYPE_NAME (container));
        gtype = gperl_object_type_from_package (type_name);
        if (gtype == G_TYPE_INVALID)
                croak ("Invalid GType `%s'", type_name);
        if (!g_type_is_a (gtype, CLUTTER_TYPE_CHILD_META))
                croak ("GType `%s' is not a Clutter::ChildMeta", type_name);
        CLUTTER_CONTAINER_GET_IFACE (container)->child_meta_type = gtype;

=for apidoc
Retrieves the L<Clutter::ChildMeta> instance for I<actor>
=cut
ClutterChildMeta *
clutter_container_get_child_meta (ClutterContainer *container, ClutterActor *actor)

MODULE = Clutter::Container     PACKAGE = Clutter::Container::ForeachFunc

void
invoke (ClutterActor *actor, SV *data)
    PREINIT:
        ClutterPerlContainerForeachFunc *stuff;
    CODE:
        stuff = INT2PTR (ClutterPerlContainerForeachFunc*, SvIV (data));
        if (!stuff | !stuff->func)
                croak("Invalid data passed to the foreach function");
        stuff->func (actor, stuff->data);

void
DESTROY (SV *code)
    PREINIT:
        MAGIC *mg;
        ClutterPerlContainerForeachFunc *stuff;
    CODE:
        if (!gperl_sv_is_defined (code) || !SvROK (code) || !(mg = mg_find (SvRV (code), PERL_MAGIC_ext)))
                return;
        stuff = INT2PTR (ClutterPerlContainerForeachFunc*, SvIV ((SV *) mg->mg_ptr));
        sv_unmagic (SvRV (code), PERL_MAGIC_ext);
        g_free (stuff);
