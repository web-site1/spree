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
});