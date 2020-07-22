import { Controller } from 'stimulus'
import { showAlert } from '../helpers/alerts_helper'

export default class extends Controller {
  static targets = ['searchQuery']

  connect() {}

  handleSubmit(event) {
    event.preventDefault();

    const searchQuery = this.searchQueryTarget.value;

    if (searchQuery.length < 3) {
      showAlert('danger', 'Please provide at least 3 characters in search phrase.');
    } else {
      event.target.submit();
    }
  }
}
