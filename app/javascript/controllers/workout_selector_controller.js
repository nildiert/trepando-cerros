import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "workoutInput", "modalTitle"]
  static values = { toggleId: String, title: String }

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

  open() {
    if (this.hasModalTitleTarget && this.hasTitleValue) {
      this.modalTitleTarget.textContent = this.titleValue
    }
  }

  updateAppearance(value) {
    const classes = {
      rest: "bg-[#A3BE8C] hover:bg-[#8CA877] text-white",
      easy_run: "bg-[#8FBCBB] hover:bg-[#7aa9a8] text-white",
      long_run: "bg-[#5E81AC] hover:bg-[#4c6b90] text-white",
      intensity: "bg-[#BF616A] hover:bg-[#a04c54] text-white",
      strength: "bg-[#D08770] hover:bg-[#b36f5d] text-white",
    }
    const borders = {
      rest: "border-[#A3BE8C]",
      easy_run: "border-[#8FBCBB]",
      long_run: "border-[#5E81AC]",
      intensity: "border-[#BF616A]",
      strength: "border-[#D08770]",
    }
    this.displayTarget.className = `badge rounded-lg ${classes[value] || ''}`
    this.element.classList.remove(
      "border-[#A3BE8C]",
      "border-[#8FBCBB]",
      "border-[#5E81AC]",
      "border-[#BF616A]",
      "border-[#D08770]",
    )
    if (borders[value]) this.element.classList.add(borders[value])
  }
}
