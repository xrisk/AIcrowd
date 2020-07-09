$(document).ready(function(){
  $('.social-share').click(function(){
    var socialSelector;
    if(this.dataset.site == 'facebook')
    {
      socialSelector = $('meta[name="og:image"]');
    }else if(this.dataset.site == 'twitter')
    {
      socialSelector = $('meta[name="twitter:image"]');
    }
    socialSelector.attr('content', this.parentElement.dataset.img);
    return SocialShareButton.share(this);
  });
});
