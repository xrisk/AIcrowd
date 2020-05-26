import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['participantCountry', 'participantAffiliation']

  filterURL(event){
    event.preventDefault();

    let url = window.location.origin + window.location.pathname

    let params = ''
    let country = this.participantCountryTarget.selectedOptions[0].value
    let postChallenge = $('#post_challenge').val()
    let challengeRoundID = $('#challenge_round_id').val()
    let affiliation = this.participantAffiliationTarget.selectedOptions[0].value
    let countryPresent = country !== ''
    let affiliationPresent = affiliation !== ''
    let challengeRoundIDPresent = challengeRoundID !== ''
    let postChallengePresent = postChallenge !== 'false'



    if(affiliationPresent){
      if(countryPresent){
        params = params.concat('country_name=', country).concat('&affiliation=', affiliation);
      }else{
        params = params.concat('affiliation=', affiliation);
      }
      if(challengeRoundIDPresent)
      {
        params = params.concat('&challenge_round_id=', challengeRoundID);
      }
      if(postChallengePresent)
      {
        params = params.concat('&post_challenge=', postChallenge);
      }
    }else if(countryPresent){
      params = params.concat('country_name=', country);
      if(challengeRoundIDPresent)
      {
        params = params.concat('&challenge_round_id=', challengeRoundID);
      }
      if(postChallengePresent)
      {
        params = params.concat('&post_challenge=', postChallenge);
      }
    }else if(challengeRoundIDPresent) {
      params = params.concat('challenge_round_id=', challengeRoundID);
      if(postChallengePresent)
      {
        params = params.concat('&post_challenge=', postChallenge);
      }
    }else if(postChallengePresent) {
      params = params.concat('post_challenge=', postChallenge);
    }

    if(countryPresent || affiliationPresent || challengeRoundIDPresent || postChallengePresent){
      window.location.href = url.concat('?').concat(params);
    }else{
      window.location.href = url
    }
  }
}
