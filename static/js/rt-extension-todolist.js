function getTodoListData (Object) {
    var CustomField = jQuery('#RT-TodoList-Select').val();
    var data = {
            UpdateTodoList: 1,
            ObjectId: Object,
            CustomField: CustomField,
        };
    return data;
};

function getTodoData () {
    var values = {};
    jQuery('#RT-TodoList :checkbox').each(function(){
        if ( jQuery(this).is(":checked") ) {
            values[this.id] = document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        } else {
            values[this.id] = 'RT-TodoList-Remove-'+document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        }
    });
    values['UpdateTodo'] = 1;
    return values;
};
