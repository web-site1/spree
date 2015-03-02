jQuery(document).ready(function ($) {
     
	$("select").select2({dropdownCssClass: 'dropdown-inverse'});

	$(':checkbox').radiocheck();

	$('#accordion.search').on('show.bs.collapse', function () {
		console.log('test');
		$(':checkbox').radiocheck('destroy');
		$(':checkbox').radiocheck();
	});

	var spinner = $( ".spinner" ).spinner();

	var $slider = $("#width-slider");
	if ($slider.length > 0) {
	  $slider.slider({
	    min: 1,
	    max: 9,
	    value: 1,
	    orientation: "horizontal",
	    range: "min"
	  }).addSliderSegments($slider.slider("option").max);
	}

	var $lengthslider = $("#length-slider");
	if ($lengthslider.length > 0) {
	  $lengthslider.slider({
	    min: 1,
	    max: 4,
	    value: 1,
	    orientation: "horizontal",
	    range: "min"
	  }).addSliderSegments($lengthslider.slider("option").max);
	}

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

    var carousel3 = jQuery('#multiple-items');

    carousel3
    	.on('jcarousel:reload jcarousel:create ', function () {
                var carousel = jQuery(this),
                    width = carousel.innerWidth();

                    // alert (width);

                if (width >= 600) {
                    width = 174; // width / 3;
                } else if (width >= 350) {
                    width = 174; // width / 2;
                }

                width = 80;

                carousel.jcarousel('items').css('width', Math.ceil(width) + 'px');                
                // alert ("test");
            })
            .jcarousel({
		    	wrap: 'circular'
		    });
    


    jQuery('.multiple-items .jcarousel-control-prev').jcarouselControl({
	    target: '-=1',
	    carousel: carousel3
	});

	jQuery('.multiple-items .jcarousel-control-next').jcarouselControl({
	    target: '-=1',
	    carousel: carousel3
	});



     
})(jQuery);