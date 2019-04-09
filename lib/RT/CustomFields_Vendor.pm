package RT::CustomFields;

sub LimitTodoToObject {
    my $self     = shift;
    my $ObjectId = shift;

    $self->Limit(
        ALIAS           => $self->_OCFAlias,
        FIELD           => 'ObjectId',
        OPERATOR        => '=',
        VALUE           => $ObjectId,
        ENTRYAGGREGATOR => 'AND',
        SUBCLAUSE       => 'LimitToTodo'
    );
    $self->Limit(
        FIELD         => 'Name',
        OPERATOR      => 'LIKE',
        CASESENSITIVE => 1,
        VALUE         => 'TODO',
        ENTRYAGGREGATOR => 'AND',
        SUBCLAUSE       => 'LimitToTodo'
    );
}

sub LimitToNotTodo {
    my $self         = shift;

    $self->Limit(
        FIELD         => 'Name',
        OPERATOR      => 'NOT LIKE',
        SUBCLAUSE     => 'hide',
        CASESENSITIVE => 1,
        VALUE         => 'TODO:',
        ENTRYAGGREGATOR => 'AND',
    );
}

1;
