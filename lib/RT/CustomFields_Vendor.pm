package RT::CustomFields;

sub LimitTodoToObject {
    my $self     = shift;
    my $ObjectId = shift;

    my $attributes = RT::Attributes->new(RT->SystemUser);
    $attributes->Limit(
        FIELD         => 'Name',
        OPERATOR      => '=',
        VALUE         => 'TodoListCustomField',
    );
    my @custom_field_ids;
    while ( my $attribute = $attributes->Next ) {
        push @custom_field_ids, $attribute->ObjectId;
    }

    $self->Limit(
        ALIAS           => $self->_OCFAlias,
        FIELD           => 'ObjectId',
        OPERATOR        => '=',
        VALUE           => $ObjectId,
        ENTRYAGGREGATOR => 'AND',
        SUBCLAUSE       => 'LimitToTodo'
    );
    $self->Limit(
        FIELD         => 'Id',
        OPERATOR      => 'IN',
        VALUE         => \@custom_field_ids,
        ENTRYAGGREGATOR => 'AND',
        SUBCLAUSE       => 'LimitToTodo'
    );
}

sub LimitToNotTodo {
    my $self = shift;

    my $attributes = RT::Attributes->new(RT->SystemUser);
    $attributes->Limit(
        FIELD         => 'Name',
        OPERATOR      => '=',
        VALUE         => 'TodoListCustomField',
    );
    my @custom_field_ids;
    while ( my $attribute = $attributes->Next ) {
        push @custom_field_ids, $attribute->ObjectId;
    }
    return unless scalar @custom_field_ids;

    $self->Limit(
        FIELD         => 'Id',
        OPERATOR      => 'NOT IN',
        VALUE         => \@custom_field_ids,
        ENTRYAGGREGATOR => 'AND',
        SUBCLAUSE       => 'LimitToTodo'
    );
}

1;
