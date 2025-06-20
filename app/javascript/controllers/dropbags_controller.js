import { Controller } from "@hotwired/stimulus"

const BLOCKS = [
  { group: "Bloque 1", section: null, hours: 7, mix: "1/2 Drink Mix 320", mixCH: 40, gel: "Gel 160" },
  { group: "Bloque 2", section: "A", hours: 4, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 160" },
  { group: "Bloque 2", section: "B", hours: 3, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 100" },
  { group: "Bloque 3", section: "A", hours: 2, mix: "1/2 Drink Mix 320", mixCH: 40, gel: "Gel 160" },
  { group: "Bloque 3", section: "B", hours: 2, mix: "1/2 Drink Mix 320", mixCH: 40, gel: "Gel 100 CAF" },
  { group: "Bloque 3", section: "C", hours: 3, mix: "1/2 Drink Mix 320", mixCH: 40, gel: "Gel 160" },
  { group: "Bloque 4", section: "A", hours: 1, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 100 CAF" },
  { group: "Bloque 4", section: "B", hours: 1, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 160" },
  { group: "Bloque 4", section: "C", hours: 2, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 100" },
  { group: "Bloque 4", section: "D", hours: 1, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 160" },
  { group: "Bloque 4", section: "E", hours: 2, mix: "1/2 Drink Mix 160", mixCH: 20, gel: "Gel 100" }
]

const CH = {
  "1/2 Drink Mix 320": 40,
  "1/2 Drink Mix 160": 20,
  "Gel 160": 40,
  "Gel 100 CAF": 25,
  "Gel 100": 25
}

function buildSchedule(maxHours = 30) {
  const schedule = []
  let count = 0
  BLOCKS.forEach(block => {
    const limit = Math.min(block.hours, maxHours - count)
    for (let i = 0; i < limit; i++) {
      schedule.push({ mix: block.mix, gel: block.gel })
    }
    count += limit
  })
  const last = BLOCKS[BLOCKS.length - 1]
  while (count < maxHours) {
    schedule.push({ mix: last.mix, gel: last.gel })
    count += 1
  }
  return schedule
}

export default class extends Controller {
  static targets = ["km", "list"]
  static values = { kmSeconds: Array }

  static RANGE_SEC = 30 * 60 // +/- 30 minutes

  connect() {
    this.bags = []
    this.render()
  }

  add(event) {
    event.preventDefault()
    const km = parseFloat(this.kmTarget.value)
    if (isNaN(km)) return
    this.bags.push(km)
    this.bags.sort((a, b) => a - b)
    this.kmTarget.value = ""
    this.render()
  }

  render() {
    const kmSeconds = this.kmSecondsValue || []
    if (kmSeconds.length === 0) return
    const totalSecs = kmSeconds[kmSeconds.length - 1][1]
    const secsForKm = km => this.timeForDistance(km)
    const times = this.bags.map(secsForKm)
    times.push(totalSecs)
    const hours = times.map(t => Math.ceil(t / 3600 + 1))
    const maxH = hours[hours.length - 1]
    const schedule = buildSchedule(maxH)

    this.listTarget.innerHTML = ""
    let prev = 0
    hours.forEach((h, idx) => {
      const counts = this.segmentCounts(schedule, prev, h)
      const carbs = this.segmentCarbRate(schedule, prev, h)
      const name = idx === 0
        ? `Inicio → Bag ${idx + 1} (${this.bags[idx] || 'meta'} km)`
        : idx < this.bags.length
          ? `Bag ${idx} → Bag ${idx + 1} (${this.bags[idx] || 'meta'} km)`
          : `Bag ${idx} → Meta`
      const secs = times[idx] + 3600
      prev = h
      const row = document.createElement("tr")
      row.innerHTML = `
        <td class='px-2 py-1'>${name}</td>
        <td class='px-2 py-1'>${this.timeRangeString(secs)}</td>
        <td class='px-2 py-1'>${h}</td>
        <td class='px-2 py-1'>${carbs}</td>
        <td class='px-2 py-1'>${counts["Drink Mix 320"]}</td>
        <td class='px-2 py-1'>${counts["Drink Mix 160"]}</td>
        <td class='px-2 py-1'>${counts["Gel 160"]}</td>
        <td class='px-2 py-1'>${counts["Gel 100 CAF"]}</td>
        <td class='px-2 py-1'>${counts["Gel 100"]}</td>`
      this.listTarget.appendChild(row)
    })
  }

  segmentCounts(schedule, start, finish) {
    const counts = { "Drink Mix 320": 0, "Drink Mix 160": 0, "Gel 160": 0, "Gel 100 CAF": 0, "Gel 100": 0 }
    for (let i = start; i < finish && i < schedule.length; i++) {
      const item = schedule[i]
      const mix = item.mix.replace('1/2 ', '')
      counts[mix] += 0.5
      counts[item.gel] += 1
    }
    Object.keys(counts).forEach(k => {
      counts[k] = Math.ceil(counts[k])
    })
    return counts
  }

  segmentCarbRate(schedule, start, finish) {
    let total = 0
    for (let i = start; i < finish && i < schedule.length; i++) {
      const item = schedule[i]
      total += CH[item.mix] + CH[item.gel]
    }
    const hours = Math.max(1, finish - start)
    return Math.round(total / hours)
  }

  dayTimeString(seconds) {
    const input = document.getElementById("startTime")
    if (!input || !input.value) return this.formatTime(seconds)
    const [h, m] = input.value.split(":").map(Number)
    const base = new Date()
    base.setHours(h, m, 0, 0)
    const t = new Date(base.getTime() + seconds * 1000)
    return `${String(t.getHours()).padStart(2, '0')}:${String(t.getMinutes()).padStart(2, '0')}`
  }

  timeRangeString(seconds) {
    const start = Math.max(0, seconds - this.constructor.RANGE_SEC)
    const finish = seconds + this.constructor.RANGE_SEC
    return `${this.dayTimeString(start)} - ${this.dayTimeString(finish)}`
  }

  formatTime(seconds) {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`
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
}
