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

    $('#pause').click(function(event) {
            pause();
        }
    );

    //Auto slide the carousel every 3.5 seconds
    setslider();

    function setslider(){
        var intervalId = setInterval( "$('#next_slide').click();",4000 );
    }

    function stopslider(){
        clearInterval(intervalId);
        delete intervalId;
    }

    function pause(){
        if (typeof intervalId == 'undefined'){
            setslider();
        }else{
            stopslider();
        }
    }

    //Add toggle


    $( '#add_btn' ).click( function() {
        //alert('hello world');
        $( '#bannerformmodal' ).modal();
        $( '#bannerformmodal').toggle();
      });


});