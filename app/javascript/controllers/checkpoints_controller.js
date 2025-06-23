import { Controller } from "@hotwired/stimulus"

const RANGE_SEC = 30 * 60 // +/- 30 minutes

export default class extends Controller {
  static values = { kmSeconds: Array }
  static targets = ["name", "km", "list"]

  connect() {
    this.points = []
  }

  add(event) {
    event.preventDefault()
    const name = this.nameTarget.value.trim()
    const km = parseFloat(this.kmTarget.value)
    if (!name || isNaN(km)) return
    const secs = this.timeForDistance(km)
    this.points.push({ name, km, secs })
    this.points.sort((a, b) => a.km - b.km)
    this.render()
    this.nameTarget.value = ""
    this.kmTarget.value = ""
  }

  render() {
    this.listTarget.innerHTML = ""
    let prev = 0
    this.points.forEach(pt => {
      const range = this.timeRangeString(pt.secs)
      const diff = this.formatTime(pt.secs - prev)
      const tr = document.createElement("tr")
      tr.innerHTML = `<td class='px-2 py-1'>${pt.name}</td>` +
        `<td class='px-2 py-1'>${pt.km}</td>` +
        `<td class='px-2 py-1'>${range}</td>` +
        `<td class='px-2 py-1'>${diff}</td>`
      this.listTarget.appendChild(tr)
      prev = pt.secs
    })
  }

  timeForDistance(d) {
    const kmSeconds = this.kmSecondsValue || []
    if (kmSeconds.length === 0) return 0
    for (let i = 0; i < kmSeconds.length; i++) {
      const km = kmSeconds[i][0]
      const sec = kmSeconds[i][1]
      if (d <= km) {
        if (i === 0) return sec * (d / km)
        const kmA = kmSeconds[i - 1][0]
        const secA = kmSeconds[i - 1][1]
        const ratio = (d - kmA) / (km - kmA)
        return secA + ratio * (sec - secA)
      }
    }
    return kmSeconds[kmSeconds.length - 1][1]
  }

  dayTimeString(seconds) {
    const input = document.getElementById("startTime")
    if (!input || !input.value) return this.formatTime(seconds)
    const [h, m] = input.value.split(":" ).map(Number)
    const base = new Date()
    base.setHours(h, m, 0, 0)
    const t = new Date(base.getTime() + seconds * 1000)
    return `${String(t.getHours()).padStart(2,'0')}:${String(t.getMinutes()).padStart(2,'0')}`
  }

  timeRangeString(seconds) {
    const start = Math.max(0, seconds - RANGE_SEC)
    const finish = seconds + RANGE_SEC
    return `${this.dayTimeString(start)} - ${this.dayTimeString(finish)}`
  }

  formatTime(seconds) {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    return `${String(h).padStart(2,'0')}:${String(m).padStart(2,'0')}`
  }
}
