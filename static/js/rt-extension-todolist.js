function UpdateTodoList (Object) {
    const CustomField = jQuery('#RT-TodoList-Select').val();
    fetch(RT.Config.WebHomePath + "/Helpers/TodoList?UpdateTodoList=1&ObjectId="+Object+"&CustomField="+CustomField, {
       credentials: 'include',
    }).then(response => (response.json()))
    .then(json => {
          jQuery('#RT-TodoList').html(json[0].html)
      })
      .catch(function (error) {
        console.log('Request failed', error)
      });
};

function UpdateTodos () {
    let values = {};
    jQuery('#RT-TodoList :checkbox').each(function(){
        if ( jQuery(this).is(":checked") ) {
            values[this.id] = document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        } else {
            values[this.id] = 'RT-TodoList-Remove-'+document.querySelectorAll("[for='"+this.id+"']")[0].innerHTML;
        }
    });
    values['UpdateTodo'] = 1;
    fetch(RT.Config.WebHomePath + "/Helpers/TodoList", {
        method: 'POST',
        credentials: 'include',
        body: JSON.stringify(values)
    });
};
