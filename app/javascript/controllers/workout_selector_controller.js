import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "workoutInput"]
  static values = { toggleId: String }

  select(event) {
    const value = event.target.value
    const text = event.target.selectedOptions[0].textContent
    this.workoutInputTarget.value = value
    this.displayTarget.textContent = text
    if (this.toggleIdValue) {
      const toggle = document.getElementById(this.toggleIdValue)
      if (toggle) toggle.checked = false
    }
  }
}
