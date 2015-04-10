jQuery(document).ready(function ($) {

    $('.art_state').submit(function(event) {
        //alert('hello world');
        var $form = $(this);
        var $target = $($form.attr('data-target'));
        var order_id = $form.attr('data-order')
        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action'),
            data: $form.serialize(),

            success: function(data, status) {
                $target.html(data);
            },

            error: function(data,status){
                alert("An error has occured!")
            }
        });

        $('#ord_'+order_id).modal('hide');
        event.preventDefault();
    });
});