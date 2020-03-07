import { Controller } from 'stimulus';
import $ from 'jquery';

export default class extends Controller {
  connect() {
    const tableSelector = this.element.getAttribute('data-table-id');
    $(`#${tableSelector}`).dataTable();
  }
}
