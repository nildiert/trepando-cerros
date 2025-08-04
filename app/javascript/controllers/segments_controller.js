import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "display"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    const fragment = document.createRange().createContextualFragment(content)
    const item = fragment.firstElementChild
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
    this.listTarget
      .querySelectorAll("select[name*='[objective_type]']")
      .forEach(select => this.changeObjective({ currentTarget: select }))
    this.listTarget
      .querySelectorAll("select[name*='[intensity_type]']")
      .forEach(select => this.changeIntensity({ currentTarget: select }))
  }

  updateDisplay() {
    if (!this.hasDisplayTarget) return
    const texts = Array.from(
      this.listTarget.querySelectorAll("select[name*='[phase]'] option:checked")
    ).map(o => o.textContent.trim())
    this.displayTarget.textContent = texts.join(', ')
  }

  changeObjective(event) {
    const item = event.currentTarget.closest("[data-segment-item]")
    const type = event.currentTarget.value
    item.querySelector('[data-objective-distance]').classList.toggle('hidden', type !== 'distance')
    item.querySelector('[data-objective-time]').classList.toggle('hidden', type !== 'time')
    item.querySelector('[data-objective-hr]').classList.toggle('hidden', type !== 'heart_rate_zone')
  }

  changeIntensity(event) {
    const item = event.currentTarget.closest("[data-segment-item]")
    const type = event.currentTarget.value
    item.querySelector('[data-intensity-hr]').classList.toggle('hidden', type !== 'heart_rate')
    item.querySelector('[data-intensity-rpe]').classList.toggle('hidden', type !== 'rpe')
  }
}
