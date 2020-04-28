$(document).ready(function() {
  const declineButtons = document.querySelectorAll('.newsletter-emails__decline-button');

  declineButtons.forEach(function(declineButton) {
    declineButton.addEventListener('click', function(event) {
      event.preventDefault();

      const requestURL    = event.target.dataset['requestUrl'];
      const declineReason = prompt('Please enter the decline reason.');

      if (declineReason && declineReason.length) {
        fetch(requestURL, {
          method: 'POST',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ decline_reason: declineReason })
        }).then(response => {
          if (response.redirected) {
            location.assign(response.url)
          }
        })
      } else {
        if (declineReason === '') {
          alert('Decline reason is required.')
        }
      }
    })
  });
});
