import { Controller } from "stimulus"

export default class extends Controller {
  connect() {}

  showSelectedResults(event) {
    event.preventDefault();

    const pillType           = event.target.dataset.searchPillType;
    const challengesResults  = document.getElementById('search-challenges-results');
    const usersResults       = document.getElementById('search-users-results');
    const discussionsResults = document.getElementById('search-discussions-results');
    const urlParams          = new URLSearchParams(location.search);

    switch (pillType) {
      case 'all':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all=true';
        break;
      case 'challenges':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all_challenges=true';
        break;
      case 'users':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all_participants=true';
        break;
      case 'discussions':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all_discussions=true';
        break;
    }

    removeSearchPillsActiveClass();
    event.target.classList.add('active');

    switch (pillType) {
      case 'see-all-challenges':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all_challenges=true';
        break;
      case 'see-all-users':
        window.location.href = window.location.origin + window.location.pathname + '?q=' + urlParams.get('q') + '&show_all_participants=true';
        break;
    }
  }
}

function removeSearchPillsActiveClass() {
  const urlParams = new URLSearchParams(location.search);
  const searchPills = document.querySelectorAll('.search-nav-link');

  searchPills.forEach(element => {
    element.classList.remove('active');
  });
}

window.onload = function() {
  const urlParams = new URLSearchParams(location.search);
  const challengesResults  = document.getElementById('search-challenges-results');
  const usersResults       = document.getElementById('search-users-results');
  const discussionsResults = document.getElementById('search-discussions-results');

  if(urlParams.has('show_all_challenges')){
    removeSearchPillsActiveClass();
    challengesResults.style.display = 'block';
    usersResults.style.display = 'none';
    discussionsResults.style.display = 'none';
    document.getElementById('challenge-nav-search').classList.add('active');
  }

  if(urlParams.has('show_all_participants')){
    removeSearchPillsActiveClass();
    challengesResults.style.display = 'none';
    usersResults.style.display = 'block';
    discussionsResults.style.display = 'none';
    document.getElementById('participant-nav-search').classList.add('active');
  }

  if(urlParams.has('show_all')){
    removeSearchPillsActiveClass();
    challengesResults.style.display = 'block';
    usersResults.style.display = 'block';
    discussionsResults.style.display = 'block';
    document.getElementById('all-nav-search').classList.add('active');
  }

  if(urlParams.has('show_all_discussions')){
    removeSearchPillsActiveClass();
    challengesResults.style.display = 'none';
    usersResults.style.display = 'none';
    discussionsResults.style.display = 'block';
    document.getElementById('discussion-nav-search').classList.add('active');
  }
}
