jQuery(document).ready(function ($) {


    $('#cart_view').on('show', function () {
        $(this).find('.modal-body').css({
            width:'auto', //probably not needed
            height:'auto', //probably not needed
            'max-height':'100%'
        });
    });




    $('#add_to_cart_form').submit(function(){
        $('#add-to-cart-button').attr('disabled', 'disabled');
        var device_type = $('#device_check').val();
        var data = $(this).serialize();
        $.ajax({
            type: 'POST',
            url:  $(this).attr("action"),
            data: data,
            success: function (data)
            {
                if (data.status == 'success') {
                    var o = Spree.fetch_cart();
                    var linkinfo =  o.responseText;
                    $('#link-to-cart').html(linkinfo);
                    if (device_type == 'desktop')
                    {
                        see_ajax_cart();
                    }

                }
                $('#art_message').html(data.mess) //.fadeIn().delay(3000).fadeOut();


                if (device_type == 'mobile') {
                    $('#itm_ord').modal('show');
                }
                setTimeout(function() {   //calls click event after a certain time
                    if (device_type == 'mobile') {
                        $('#itm_ord').modal('hide');
                    }
                    $('#add-to-cart-button').prop("disabled", false);
                }, 5000);


            },
            error: function (data) {
                alert(data.mess);
                $('#add-to-cart-button').prop("disabled", false);
            }

        });

        return false;
    });

    //$('#view_cart_btn').click(function(){
    function see_ajax_cart(){
        $('#itm_ord').modal('hide');
        $.ajax({
            type: 'GET',
            url:  '/ajax_cart',
            data: '',
            success: function (data)
            {
                $('#cart_view_body').html(data);
                $('#cart_view').modal('show');

            },
            error: function (data) {
                alert("Please check your cart!");
            }

        });

    };






});
