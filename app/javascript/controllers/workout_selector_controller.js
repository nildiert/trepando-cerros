import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "workoutInput"]
  static values = { toggleId: String }

  connect() {
    this.updateAppearance(this.workoutInputTarget.value)
  }

  choose(event) {
    const { workoutValue: value, workoutText: text } = event.currentTarget.dataset
    this.workoutInputTarget.value = value
    this.displayTarget.textContent = text
    this.updateAppearance(value)
    if (this.toggleIdValue) {
      const toggle = document.getElementById(this.toggleIdValue)
      if (toggle) toggle.checked = false
    }
  }

  updateAppearance(value) {
    const classes = {
      rest: "bg-green-300 text-green-800",
      easy_run: "bg-blue-200 text-blue-800",
      long_run: "bg-blue-700 text-white",
      intensity: "bg-orange-200 text-orange-800",
      strength: "bg-orange-200 text-orange-800",
    }
    this.displayTarget.className = `badge ${classes[value] || ''}`
  }
}
