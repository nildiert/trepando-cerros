import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "template", "output"]

  addRow() {
    const fragment = this.templateTarget.content.cloneNode(true)
    this.listTarget.appendChild(fragment)
  }

  compute() {
    const rows = this.listTarget.querySelectorAll('.checkpoint-row')
    const results = []
    rows.forEach(row => {
      const name = row.querySelector('[data-field="name"]').value
      const km = parseFloat(row.querySelector('[data-field="km"]').value)
      if (!name || isNaN(km)) return
      const sec = window.timeForDistance ? window.timeForDistance(km) : 0
      const startSec = sec - 300
      const endSec = sec + 300
      const startStr = window.dayTimeString ? window.dayTimeString(startSec) : ''
      const endStr = window.dayTimeString ? window.dayTimeString(endSec) : ''
      results.push(`<li>${name}: ${startStr} - ${endStr}</li>`)
    })
    this.outputTarget.innerHTML = `<ul class='list-disc pl-5 space-y-1'>${results.join('')}</ul>`
  }
}
