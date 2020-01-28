import { Controller } from 'stimulus';

export default class extends Controller {
  initialize() {
    const currentUrl  = new URL(window.location);
    const currentStep = currentUrl.searchParams.get('step');
    // I have to use JQuery here, because Bootstrap tabs use JQuery and
    // plain javascript won't trigger events on them
    const currentTab = $(`#challenge-edit-${currentStep}-tab`);

    if (currentTab) {
      currentTab.tab('show');
    }
  }
}
