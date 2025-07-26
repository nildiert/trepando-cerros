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
      rest: "bg-green-700 hover:bg-green-800 text-white",
      easy_run: "bg-blue-500 hover:bg-blue-600 text-white",
      long_run: "bg-blue-800 hover:bg-blue-900 text-white",
      intensity: "bg-red-700 hover:bg-red-800 text-white",
      strength: "bg-orange-500 hover:bg-orange-600 text-white",
    }
    this.displayTarget.className = `badge ${classes[value] || ''}`
  }
}
