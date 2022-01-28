function UpdateTodoList (Object) {
    var CustomField = jQuery('#RT-TodoList-Select').val();
    jQuery.ajax({
        url: RT.Config.WebHomePath + "/Helpers/TodoList",
        type: 'GET',
        datatype: 'json',
        data: {
            UpdateTodoList: 1,
            ObjectId: Object,
            CustomField: CustomField,
        },
        success: function(response) {
            jQuery('#RT-TodoList').html(response[0].html)
        }
    });
};

function UpdateTodos () {
    var values = {};
    jQuery('#RT-TodoList :checkbox').each(function(){
        if ( jQuery(this).is(":checked") ) {
            values[this.id] = document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        } else {
            values[this.id] = 'RT-TodoList-Remove-'+document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        }
    });
    values['UpdateTodo'] = 1;
    jQuery.ajax({
        url: RT.Config.WebHomePath + "/Helpers/TodoList",
        method: 'POST',
        data: 'POSTDATA=' + JSON.stringify(values),
        success: function(response) {
            //console.error(response);
        },
    });
};
