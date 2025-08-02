import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "display"]

  addPhase(event) {
    event.preventDefault()
    const phase = event.currentTarget.dataset.phaseValue
    this.add({ phase })
  }

  add(detail = {}) {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    const fragment = document.createRange().createContextualFragment(content)
    const item = fragment.firstElementChild
    if (detail.phase) {
      const select = item.querySelector("select[name*='[phase]']")
      if (select) select.value = detail.phase
    }
    this.listTarget.appendChild(item)
    this.updateDisplay()
  }

  remove(event) {
    event.preventDefault()
    const item = event.currentTarget.closest("[data-segment-item]")
    if (!item) return
    const destroy = item.querySelector("input[name*='[_destroy]']")
    if (destroy) destroy.value = 1
    item.remove()
    this.updateDisplay()
  }

  connect() {
    this.updateDisplay()
  }

  updateDisplay() {
    if (!this.hasDisplayTarget) return
    const texts = Array.from(
      this.listTarget.querySelectorAll("select[name*='[phase]'] option:checked")
    ).map(o => o.textContent.trim())
    this.displayTarget.textContent = texts.join(', ')
  }
}
