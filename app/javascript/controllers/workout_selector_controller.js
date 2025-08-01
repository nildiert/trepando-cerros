import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "display",
    "workoutInput",
    "phaseInput",
    "phaseDisplay",
    "phaseContainer",
    "modalTitle",
  ]
  static values = { toggleId: String, title: String }

  connect() {
    this.updateAppearance(this.workoutInputTarget.value)
    if (this.hasPhaseContainerTarget) {
      this.phaseContainerTarget.classList.add("hidden")
    }
  }

  choose(event) {
    event.preventDefault()
    const { workoutValue: value, workoutText: text } =
      event.currentTarget.dataset
    this.workoutInputTarget.value = value
    this.displayTarget.textContent = text
    this.updateAppearance(value)
    if (this.hasPhaseContainerTarget) {
      this.phaseContainerTarget.classList.remove("hidden")
    }
  }

  choosePhase(event) {
    event.preventDefault()
    const { phaseValue: value, phaseText: text } = event.currentTarget.dataset
    if (this.hasPhaseInputTarget) this.phaseInputTarget.value = value
    if (this.hasPhaseDisplayTarget) this.phaseDisplayTarget.textContent = text
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
    this.displayTarget.className = `badge rounded-lg ${classes[value] || ''}`
    this.element.classList.remove(
      "bg-[#A3BE8C]",
      "bg-[#8FBCBB]",
      "bg-[#5E81AC]",
      "bg-[#BF616A]",
      "bg-[#D08770]",
      "hover:bg-[#8CA877]",
      "hover:bg-[#7aa9a8]",
      "hover:bg-[#4c6b90]",
      "hover:bg-[#a04c54]",
      "hover:bg-[#b36f5d]",
      "text-white"
    )
    if (classes[value]) {
      this.element.classList.add(...classes[value].split(" "))
    }
  }
}
