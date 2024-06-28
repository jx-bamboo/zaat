import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["code"]
  copy() {
    navigator.clipboard.writeText(this.codeTarget.value)
    this.showAlert(this.codeTarget.value)
  }

  showAlert(data) {
    const alertPlaceholder = document.getElementById('liveAlertPlaceholder');
    const appendAlert = (message, type) => {
      const wrapper = document.createElement('div');
      wrapper.innerHTML = [
        `<div class="bg_gradient text-light alert alert-${type} alert-dismissible" role="alert">`,
        `   <div>Copied.</div>`,
        `   <div class="fw-bold">${message}</div>`,
        '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
        '</div>'
      ].join('');

      alertPlaceholder.append(wrapper);
    };
    appendAlert(data, 'success');
  }
}