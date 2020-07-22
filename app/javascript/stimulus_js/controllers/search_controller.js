import { Controller } from "stimulus"

export default class extends Controller {
  connect() {}

  showAllResults(event) {
    event.preventDefault();

    const challengesResults = document.getElementById('search-challenges-results');
    const usersResults      = document.getElementById('search-users-results');

    challengesResults.style.display = 'block';
    usersResults.style.display = 'block';
    removeSearchPillsActiveClass();
    event.target.classList.add('active');
  }

  showChallengesResults(event) {
    event.preventDefault();

    const challengesResults = document.getElementById('search-challenges-results');
    const usersResults      = document.getElementById('search-users-results');

    challengesResults.style.display = 'block';
    usersResults.style.display = 'none';
    removeSearchPillsActiveClass();
    event.target.classList.add('active');
  }

  showUsersResults(event) {
    event.preventDefault();

    const challengesResults = document.getElementById('search-challenges-results');
    const usersResults      = document.getElementById('search-users-results');

    challengesResults.style.display = 'none';
    usersResults.style.display = 'block';
    removeSearchPillsActiveClass();
    event.target.classList.add('active');
  }
}

function removeSearchPillsActiveClass() {
  const searchPills = document.querySelectorAll('.search-nav-link');

  searchPills.forEach(element => {
    element.classList.remove('active');
  });
}
