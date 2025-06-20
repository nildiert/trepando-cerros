import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.show(0)
  }

  change(event) {
    event.preventDefault()
    const index = this.tabTargets.indexOf(event.currentTarget)
    if (index >= 0) {
      this.show(index)
    }
  }

  show(index) {
    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("border-blue-500", "text-blue-600")
        tab.classList.remove("border-transparent", "text-gray-500")
      } else {
        tab.classList.add("border-transparent", "text-gray-500")
        tab.classList.remove("border-blue-500", "text-blue-600")
      }
    })
    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== index)
    })
  }
}
