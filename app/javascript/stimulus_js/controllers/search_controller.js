import { Controller } from "stimulus"

export default class extends Controller {
  connect() {}

  showSelectedResults(event) {
    event.preventDefault();

    const pillType           = event.target.dataset.searchPillType;
    const challengesResults  = document.getElementById('search-challenges-results');
    const usersResults       = document.getElementById('search-users-results');
    const discussionsResults = document.getElementById('search-discussions-results');

    switch (pillType) {
      case 'all':
        challengesResults.style.display = 'block';
        usersResults.style.display = 'block';
        discussionsResults.style.display = 'block';
        break;
      case 'challenges':
        challengesResults.style.display = 'block';
        usersResults.style.display = 'none';
        discussionsResults.style.display = 'none';
        break;
      case 'users':
        challengesResults.style.display = 'none';
        usersResults.style.display = 'block';
        discussionsResults.style.display = 'none';
        break;
      case 'discussions':
        challengesResults.style.display = 'none';
        usersResults.style.display = 'none';
        discussionsResults.style.display = 'block';
        break;
    }

    removeSearchPillsActiveClass();
    event.target.classList.add('active');

    switch (pillType) {
      case 'see-all-challenges':
        challengesResults.style.display = 'block';
        usersResults.style.display = 'none';
        discussionsResults.style.display = 'none';
        document.getElementById('challenge-nav-search').classList.add('active');
        break;
      case 'see-all-users':
        challengesResults.style.display = 'none';
        usersResults.style.display = 'block';
        discussionsResults.style.display = 'none';
        document.getElementById('users-nav-search').classList.add('active');
        break;
    }
  }
}

function removeSearchPillsActiveClass() {
  const searchPills = document.querySelectorAll('.search-nav-link');

  searchPills.forEach(element => {
    element.classList.remove('active');
  });
}
