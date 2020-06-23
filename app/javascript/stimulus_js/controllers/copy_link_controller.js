import { Controller } from "stimulus"

export default class extends Controller {
  copyLink() {
    const hiddenInput = document.getElementById("shortUrl");

    hiddenInput.style.display = 'block';
    hiddenInput.select();
    document.execCommand("copy");
    hiddenInput.style.display = 'none';

    const copybtn = document.getElementById("copyurlbutton");

    copybtn.style.text = '#FFFFFF';
    copybtn.style.backgroundColor = '#44B174';
    copybtn.classList.remove("btn-secondary");
    copybtn.classList.add("btn-primary");
    copybtn.innerHTML = "Copied!";

    return false;
  }
}
