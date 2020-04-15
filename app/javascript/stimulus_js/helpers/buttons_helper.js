export function disableButton(button, label) {
  button.disabled    = true;
  button.textContent = label;
}

export function enableButton(button, label) {
  button.removeAttribute('disabled');
  button.textContent = label;
}
