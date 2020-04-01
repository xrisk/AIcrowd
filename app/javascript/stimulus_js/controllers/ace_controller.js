import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    const elementId = this.data.get('id');
    ace.edit(elementId);
  }
}
