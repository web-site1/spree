jQuery(document).ready(function ($) {


    $('#add_to_cart_form').submit(function(){
        $('#add-to-cart-button').attr('disabled', 'disabled');
        data = $(this).serialize();
        $.ajax({
            type: 'POST',
            url:  $(this).attr("action"),
            data: data,
            success: function (data)
            {
                if (data.status == 'success') {
                    var o = Spree.fetch_cart();
                    $('#link-to-cart').html(o.responseText);

                }
                $('#art_message').html(data.mess) //.fadeIn().delay(3000).fadeOut();
                $('#itm_ord').modal('show');
                setTimeout(function() {   //calls click event after a certain time
                    $('#itm_ord').modal('hide');
                    $('#add-to-cart-button').prop("disabled", false);
                }, 3000);

            },
            error: function (data) {
                alert(data.mess);
                $('#add-to-cart-button').prop("disabled", false);
            }

        });

        return false;
    });

});
