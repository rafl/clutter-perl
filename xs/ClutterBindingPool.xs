#include "clutterperl-private.h"

MODULE = Clutter::BindingPool   PACKAGE = Clutter::BindingPool  PREFIX = clutter_binding_pool_

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::BindingPool> is a data structure holding a set of key bindings.

Each key binding associates a key symbol (eventually with modifiers)
to an action. A callback function is associated to each action.

For a given key symbol and modifier mask combination there can be only one
action; for each action there can be only one callback. There can be
multiple actions with the same name, and the same callback can be used
to handle multiple key bindings.

Actors requiring key bindings should create a new Clutter::BindingPool
inside their class initialization function and then install actions
like this:

    sub INIT_INSTANCE {
        my ($self) = @_;

        my $binding_pool = Clutter::BindingPool->new('MyActor');

        # install a key binding for 'Up'
        $binding_pool->install_action(
            'move-up',
            $Clutter::Keysyms{Up}, [ ],
            \&my_actor_move_up,
        );

        # install a key binding for Shift+Up; the action name
        # is the same, as well as the callback
        $binding_pool->install_action(
            'move-up',
            $Clutter::Keysyms{Up}, [ qw( shift-mask ) ],
            \&my_actor_move_up,
        );

        # keep a reference on the binding pool
        $self->{binding_pool} = $binding_pool;
    }

The callback function has a signature of:

    sub callback {
        my (
            $instance,
            $action_name,
            $key_val,
            $modifiers,
            $user_data
        ) = @_;

        return $was_the_action_handled;
    }

The actor should then override the Clutter::Actor "key-press-event" signal
and use Clutter::BindingPool::activate() to match a Clutter::Event::Key to
one of the actions:

    sub on_key_press_event {
        my ($self, $event) = @_;

        return $self->{binding_pool}->activate(
            $event->keyval,
            $event->modifier_state,
            $self,
        );
    }

The Clutter::BindingPool::activate() method will return C<FALSE> if no
action for the given key binding was found in the pool, if the action
was blocked using Clutter::BindingPool::block_action(), or if the handler
returned C<FALSE>; otherwise, it will return C<TRUE>.

=cut

ClutterBindingPool_noinc *clutter_binding_pool_new (class, const gchar *name);
    C_ARGS:
        name

void
clutter_binding_pool_install_action (pool, action_name, key_val, modifiers, func, data=NULL)
        ClutterBindingPool *pool
        const gchar *action_name
        guint key_val
        ClutterModifierType modifiers
        SV *func
        SV *data
    PREINIT:
        GClosure *closure;
    CODE:
        closure = gperl_closure_new (func, data, FALSE);
        clutter_binding_pool_install_closure (pool, action_name,
                                              key_val, modifiers,
                                              closure);

void
clutter_binding_pool_override_action (pool, key_val, modifiers, func, data=NULL)
        ClutterBindingPool *pool
        guint key_val
        ClutterModifierType modifiers
        SV *func
        SV *data
    PREINIT:
        GClosure *closure;
    CODE:
        closure = gperl_closure_new (func, data, FALSE);
        clutter_binding_pool_override_closure (pool,
                                               key_val, modifiers,
                                               closure);

const gchar *
clutter_binding_pool_find_action (pool, key_val, modifiers)
        ClutterBindingPool *pool
        guint key_val
        ClutterModifierType modifiers

void
clutter_binding_pool_remove_action (pool, key_val, modifiers)
        ClutterBindingPool *pool
        guint key_val
        ClutterModifierType modifiers

gboolean
clutter_binding_pool_activate (pool, key_val, modifiers, object)
        ClutterBindingPool *pool
        guint key_val
        ClutterModifierType modifiers
        GObject *object

void clutter_binding_pool_block_action (ClutterBindingPool *pool, const gchar *action_name);

void clutter_binding_pool_unblock_action (ClutterBindingPool *pool, const gchar *action_name);

