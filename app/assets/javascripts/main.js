jQuery(document).ready(function ($) {


    $('#quickclear').click(function()
        {
            $('.mbl select option[value=place-holder]').attr('selected',true);
            $('#quick_srch_frm').submit();
        }
    );

    $('.mbl select').change(function()
        {
            $('#quick_srch_frm').submit();
        }
    );

    $("select").select2({dropdownCssClass: 'dropdown-inverse'});

	$(':checkbox').radiocheck();

	$('#accordion.search').on('show.bs.collapse', function () {
		console.log('test');
		$(':checkbox').radiocheck('destroy');
		$(':checkbox').radiocheck();
	});

	var spinner = $( ".spinner" ).spinner();

  // If contact form is present
  if ($("#contact_first_name").length > 0) {
    if ($("#contact_email_address").val().length == 0) {
      $("#contact_email_address").focus()
    } else {
      $("#contact_first_name").focus()
    }
  }

  $('.holiday_mess').fadeIn(3000,function(){});

});

// Add segments to a slider
$.fn.addSliderSegments = function (amount, orientation) {
  return this.each(function () {
    if (orientation == "vertical") {
      var output = ''
        , i;
      for (i = 1; i <= amount - 2; i++) {
        output += '<div class="ui-slider-segment" style="top:' + 100 / (amount - 1) * i + '%;"></div>';
      };
      $(this).prepend(output);
    } else {
      var segmentGap = 100 / (amount - 1) + "%"
        , segment = '<div class="ui-slider-segment" style="margin-left: ' + segmentGap + ';"></div>';

      for ( $x=0; $x<=(amount - 3); $x++) {
        $(this).prepend(segment);
      }

    }
  });
};

(function(jQuery) {
    jQuery(function() {
        var jcarousel = jQuery('.featured-items');

        jcarousel
            .on('jcarousel:reload jcarousel:create ', function () {
                var carousel = jQuery(this),
                    width = carousel.innerWidth();

                if (width >= 600) {
                    width = 174; // width / 3;
                } else if (width >= 350) {
                    width = 174; // width / 2;
                }

                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');                
            })
            .jcarousel({
                wrap: 'circular'
            });

        jQuery('.jcarousel-control-prev')
            .jcarouselControl({
                target: '-=1'
            });

        jQuery('.jcarousel-control-next')
            .jcarouselControl({
                target: '+=1'
            });

        jQuery('.jcarousel-pagination')
            .on('jcarouselpagination:active', 'a', function() {
                jQuery(this).addClass('active');
            })
            .on('jcarouselpagination:inactive', 'a', function() {
                jQuery(this).removeClass('active');
            })
            .on('click', function(e) {
                e.preventDefault();
            })
            .jcarouselPagination({
                perPage: 1,
                item: function(page) {
                    return '<a href="#' + page + '">' + page + '</a>';
                }
            });
    });
    
    var carousel1 = jQuery('.new-arrivals');

    carousel1
    	.on('jcarousel:reload jcarousel:create ', function () {
                var carousel = jQuery(this),
                    width = carousel.innerWidth();

                if (width >= 600) {
                    width = 174; // width / 3;
                } else if (width >= 350) {
                    width = 174; // width / 2;
                }

                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');                
            })
            .jcarousel({
		    	wrap: 'circular'
		    });
    
    jQuery('.jcarousel1-control-prev').jcarouselControl({
	    target: '-=1',
	    carousel: carousel1
	});

	jQuery('.jcarousel1-control-next').jcarouselControl({
	    target: '-=1',
	    carousel: carousel1
	});

    var carousel2 = jQuery('.related-items');

    carousel2
    	.on('jcarousel:reload jcarousel:create ', function () {
                var carousel = jQuery(this),
                    width = carousel.innerWidth();

                    // alert (width);

                if (width >= 600) {
                    width = 174; // width / 3;
                } else if (width >= 350) {
                    width = 174; // width / 2;
                }

                width = 174;

                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');                
                // alert ("test1");
            })
            .jcarousel({
		    	wrap: 'circular'
		    });
    
    jQuery('.related-items .jcarousel-control-prev').jcarouselControl({
	    target: '-=1',
	    carousel: carousel2
	});

	jQuery('.related-items .jcarousel-control-next').jcarouselControl({
	    target: '-=1',
	    carousel: carousel2
	});

 //    carousel3 = jQuery('#multiple-items');

 //    carousel3
 //    	.on('jcarousel:reload jcarousel:create ', function () {
 //                var carousel = jQuery(this),
 //                    width = carousel.innerWidth();

 //                    // alert (width);

 //                if (width >= 600) {
 //                    width = 174; // width / 3;
 //                } else if (width >= 350) {
 //                    width = 174; // width / 2;
 //                }

 //                width = 80;

 //                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');                
 //                // alert ("test");
 //            })
 //            .jcarousel({
	// 	    	wrap: 'circular'
	// 	    });
    


 //    jQuery('.multiple-items .jcarousel-control-prev').jcarouselControl({
	//     target: '-=1',
	//     carousel: carousel3
	// });

	// jQuery('.multiple-items .jcarousel-control-next').jcarouselControl({
	//     target: '-=1',
	//     carousel: carousel3
	// });

     
})(jQuery);


function setCookie(key, value) {
        var expires = new Date();
        expires.setTime(expires.getTime() + (1 * 24 * 60 * 60 * 1000));
        document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

function getCookie(key) {
    var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
    return keyValue ? keyValue[2] : null;
}
