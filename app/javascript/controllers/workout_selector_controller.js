import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "workoutInput"]
  static values = { toggleId: String }

  connect() {
    this.updateAppearance(this.workoutInputTarget.value)
  }

  choose(event) {
    event.preventDefault()
    const { workoutValue: value, workoutText: text } =
      event.currentTarget.dataset
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
    const borders = {
      rest: "border-green-700",
      easy_run: "border-blue-500",
      long_run: "border-blue-800",
      intensity: "border-red-700",
      strength: "border-orange-500",
    }
    this.displayTarget.className = `badge rounded-lg ${classes[value] || ''}`
    this.element.classList.remove(
      "border-green-700",
      "border-blue-500",
      "border-blue-800",
      "border-red-700",
      "border-orange-500",
    )
    if (borders[value]) this.element.classList.add(borders[value])
  }
}
