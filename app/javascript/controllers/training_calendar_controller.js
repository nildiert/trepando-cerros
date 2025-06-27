import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["day", "collapse"]
  static values = { initialIndex: Number }

  connect() {
    this.selectedIndex = this.initialIndexValue || 0
    this.update()
  }

  select(event) {
    event.preventDefault()
    const index = parseInt(event.currentTarget.dataset.trainingCalendarIndexValue, 10)
    if (!isNaN(index)) {
      this.selectedIndex = index
      this.update()
    }
  }

  update() {
    this.dayTargets.forEach((day, i) => {
      if (i === this.selectedIndex) {
        day.classList.add("bg-primary", "text-primary-content")
      } else {
        day.classList.remove("bg-primary", "text-primary-content")
      }
    })
    this.collapseTargets.forEach((collapse, i) => {
      const input = collapse.querySelector("input[type='checkbox']")
      if (input) input.checked = i === this.selectedIndex
    })
  }
}
