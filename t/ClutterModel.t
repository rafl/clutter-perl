use Clutter::TestHelper tests => 16;

my $model = Clutter::Model::Default->new(
    'Glib::String', 'Strings',
    'Glib::Int',    'Integers',
);

isa_ok($model, 'Clutter::Model', 'our model');
is($model->get_n_columns(), 2, 'model columns count');
is($model->get_column_name(0), 'Strings', 'first column name');
is($model->get_column_type(1), 'Glib::Int', 'second column type');

is($model->get_sorting_column(), -1, 'no sorting column');

# model (after): [ (foo, 0) ]
$model->append(0, 'foo', 1, 0);
is($model->get_n_rows(), 1, 'model rows count after first append');

# model (after): [ (foo, 0), (bar, 1) ]
$model->append(0, 'bar', 1, 1);
is($model->get_n_rows(), 2, 'model rows count after second append');

# model (after): [ (baz, 2), (foo, 0), (bar, 1) ]
$model->prepend(0, 'baz', 1, 2);
is($model->get_n_rows(), 3, 'model rows count after prepend');

# remove (baz, 2) from model
$model->remove(0);
is($model->get_n_rows(), 2, 'model rows count after remove');

my $iter = $model->get_first_iter();
isa_ok($iter, 'Clutter::Model::Iter', 'first iter');
is($iter->is_first(), TRUE, 'first iter points to the first row');
isnt($iter->is_last(), TRUE, 'first iter does not point to the last row');
ok(eq_array([ $iter->get_values() ], [ 'foo', 0 ]), 'first row values');

$iter = $model->get_last_iter();
isa_ok($iter, 'Clutter::Model::Iter', 'last iter');
isnt($iter->is_first(), TRUE, 'last iter does not point to the first row');
ok(eq_array([ $iter->get_values(0) ], [ 'bar', ]), 'last row values');
