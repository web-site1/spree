jQuery(document).ready(function($){$("select").select2({dropdownCssClass:"dropdown-inverse"}),$(":checkbox").radiocheck(),$("#accordion.search").on("show.bs.collapse",function(){console.log("test"),$(":checkbox").radiocheck("destroy"),$(":checkbox").radiocheck()});var e=$(".spinner").spinner(),r=$("#width-slider");r.length>0&&r.slider({min:1,max:9,value:1,orientation:"horizontal",range:"min"}).addSliderSegments(r.slider("option").max);var o=$("#length-slider");o.length>0&&o.slider({min:1,max:4,value:1,orientation:"horizontal",range:"min"}).addSliderSegments(o.slider("option").max)}),$.fn.addSliderSegments=function(e,r){return this.each(function(){if("vertical"==r){var o="",a;for(a=1;e-2>=a;a++)o+='<div class="ui-slider-segment" style="top:'+100/(e-1)*a+'%;"></div>';$(this).prepend(o)}else{var t=100/(e-1)+"%",l='<div class="ui-slider-segment" style="margin-left: '+t+';"></div>';for($x=0;e-3>=$x;$x++)$(this).prepend(l)}})},function(e){e(function(){var r=e(".featured-items");r.on("jcarousel:reload jcarousel:create ",function(){var r=e(this),o=r.innerWidth();o>=600?o=174:o>=350&&(o=174),r.jcarousel("items").css("width",Math.ceil(o)+"px")}).jcarousel({wrap:"circular"}),e(".jcarousel-control-prev").jcarouselControl({target:"-=1"}),e(".jcarousel-control-next").jcarouselControl({target:"+=1"}),e(".jcarousel-pagination").on("jcarouselpagination:active","a",function(){e(this).addClass("active")}).on("jcarouselpagination:inactive","a",function(){e(this).removeClass("active")}).on("click",function(e){e.preventDefault()}).jcarouselPagination({perPage:1,item:function(e){return'<a href="#'+e+'">'+e+"</a>"}})});var r=e(".new-arrivals");r.on("jcarousel:reload jcarousel:create ",function(){var r=e(this),o=r.innerWidth();o>=600?o=174:o>=350&&(o=174),r.jcarousel("items").css("width",Math.ceil(o)+"px")}).jcarousel({wrap:"circular"}),e(".jcarousel1-control-prev").jcarouselControl({target:"-=1",carousel:r}),e(".jcarousel1-control-next").jcarouselControl({target:"-=1",carousel:r});var o=e(".related-items");o.on("jcarousel:reload jcarousel:create ",function(){var r=e(this),o=r.innerWidth();o>=600?o=174:o>=350&&(o=174),o=174,r.jcarousel("items").css("width",Math.ceil(o)+"px")}).jcarousel({wrap:"circular"}),e(".related-items .jcarousel-control-prev").jcarouselControl({target:"-=1",carousel:o}),e(".related-items .jcarousel-control-next").jcarouselControl({target:"-=1",carousel:o});var a=e("#multiple-items");a.on("jcarousel:reload jcarousel:create ",function(){var r=e(this),o=r.innerWidth();o>=600?o=174:o>=350&&(o=174),o=80,r.jcarousel("items").css("width",Math.ceil(o)+"px")}).jcarousel({wrap:"circular"}),e(".multiple-items .jcarousel-control-prev").jcarouselControl({target:"-=1",carousel:a}),e(".multiple-items .jcarousel-control-next").jcarouselControl({target:"-=1",carousel:a})}(jQuery);