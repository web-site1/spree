jQuery(document).ready(function ($) {
    $('#quickclear').click(function () {
            $('.mbl select option[value=place-holder]').attr('selected', true);
            $('#quick_srch_frm').submit();
        }
    );

    $('.mbl select').change(function () {
            $('#quick_srch_frm').submit();
        }
    );

    $('.cat-click').click(function(event){
            $(this).attr('href','');
            $(this).css('opacity','0.5')
            event.preventDefault();
            var href = $(this).data("hrefa");
            window.location.href = href
            //alert(href);
        }
    );

});