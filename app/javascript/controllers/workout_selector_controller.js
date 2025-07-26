import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "workoutInput"]
  static values = { toggleId: String }

  choose(event) {
    const { workoutValue: value, workoutText: text } = event.currentTarget.dataset
    this.workoutInputTarget.value = value
    this.displayTarget.textContent = text
    if (this.toggleIdValue) {
      const toggle = document.getElementById(this.toggleIdValue)
      if (toggle) toggle.checked = false
    }
  }
}
