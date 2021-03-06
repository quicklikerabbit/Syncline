$(function() {
  var map = $('#mapAnimation');
  var bars = $('#graph');
  var inputs = $('#inputAnimation');

  if (map.length > 0 && bars.length > 0) {
    $(window).scroll(function() {
      var mapPos = map.offset().top;
      var barsPos = bars.offset().top;
      var inputPos = inputs.offset().top;

      var topOfWindow = $(window).scrollTop();
      var scrollBottom = $(window).scrollTop() + $(window).height();

      ///////////Map Animation/////////////////////
      if ((mapPos+250) < scrollBottom) {
        map.children('.pin').each(function(i, b) {
          $(b).addClass('pin' + (i + 1));
        });
      } else {
        map.children('.pin').each(function(i, b) {
          $(b).removeClass('pin' + (i + 1));
        });
      }
      ////////////Input Animation/////////////////

      if ((inputPos + 250) < scrollBottom) {
        $('#two').fadeIn();
        setTimeout(function() {
          $('#two').addClass('up');
          $('#one').addClass('down');
        }, 1000);
      } else {
        $('#two').removeClass('up');
        $('#one').removeClass('down');
        $('#two').css({
          display: 'none'
        });
      }

      ////////////Bar Graph Animation//////////////
      if ((barsPos + 250) < scrollBottom) {
        var allbars = bars.children('bar');
        bars.children('.barContainer').each(function(i, b) {
          $(b).find('.bar').addClass('bar' + (i + 1));
        });

      } else {
        bars.children('.barContainer').each(function(i, b) {
          $(b).find('.bar').removeClass('bar' + (i + 1));
        });
      }

    });

    $('.pin').css('visibility', 'hidden');
  }
});
