import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "loader" ]

  connect() {
  }

  showLoader() {
    //this.loaderTarget.classList.remove('hidden')
  }

  hideLoader() {
    //this.loaderTarget.classList.remove('hidden')
    this.loaderTarget.innerHTML = "Ask Plain!"
  }

  formSubmitting() {
    this.loaderTarget.innerHTML = "Loading..."
    //if(this.hasLoaderTarget) this.showLoader()
  }

  formSubmitted() {
    this.loaderTarget.innerHTML = "Ask Plain!"
    //if(this.hasLoaderTarget) this.hideLoader()
  }
}