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
                $('#art_message').html(data.mess).fadeIn().delay(3000).fadeOut();
                $('#add-to-cart-button').prop("disabled", false);
            },
            error: function (data) {
                alert(data.mess);
                $('#add-to-cart-button').prop("disabled", false);
            }

        });

        return false;
    });

});
