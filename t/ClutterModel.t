use Clutter::TestHelper tests => 7;

my $model = Clutter::Model->new(
    'Glib::String', 'Strings',
    'Glib::Int',    'Integers',
);

isa_ok($model, 'Clutter::Model', 'our model');
is($model->get_n_columns(), 2, 'model columns count');
is($model->get_column_name(0), 'Strings', 'first column name');
is($model->get_column_type(1), 'Glib::Int', 'second column type');

$model->append(0, 'foo', 1, 0);
$model->append(0, 'bar', 1, 1);
is($model->get_n_rows(), 2, 'model rows count');

$model->prepend(0, 'baz', 1, 2);
is($model->get_n_rows(), 3, 'model rows count after prepend');

$model->remove(2);
is($model->get_n_rows(), 2, 'model rows count after remove');
