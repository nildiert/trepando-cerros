import { Controller } from "@hotwired/stimulus"

const IMAGES = {
  dm320: "https://thehub.com.co/cdn/shop/files/drink_mix_320_maurten.webp?v=1731261437",
  dm160: "https://thehub.com.co/cdn/shop/files/DrinkMix1601.jpg?v=1705944477",
  gel160: "https://thehub.com.co/cdn/shop/files/Gel1601.jpg?v=1705944264",
  gel100: "https://thehub.com.co/cdn/shop/files/Gel100Foto1.jpg?v=1705943825",
  gel100caf: "https://thehub.com.co/cdn/shop/files/Gel100CAF1.jpg?v=1705944033"
}

const BLOCKS = [
  { group: "Bloque 1", section: null, hours: 7, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, mixCH: 40, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 2", section: "A", hours: 4, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 2", section: "B", hours: 3, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 100", gelImg: IMAGES.gel100, gelCH: 25 },
  { group: "Bloque 3", section: "A", hours: 2, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, mixCH: 40, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 3", section: "B", hours: 2, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, mixCH: 40, gel: "Gel 100 CAF", gelImg: IMAGES.gel100caf, gelCH: 25 },
  { group: "Bloque 3", section: "C", hours: 3, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, mixCH: 40, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 4", section: "A", hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 100 CAF", gelImg: IMAGES.gel100caf, gelCH: 25 },
  { group: "Bloque 4", section: "B", hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 4", section: "C", hours: 2, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 100", gelImg: IMAGES.gel100, gelCH: 25 },
  { group: "Bloque 4", section: "D", hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 160", gelImg: IMAGES.gel160, gelCH: 40 },
  { group: "Bloque 4", section: "E", hours: 2, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, mixCH: 20, gel: "Gel 100", gelImg: IMAGES.gel100, gelCH: 25 }
]

function buildSchedule(maxHours = 30) {
  const schedule = []
  const info = []
  let count = 0
  BLOCKS.forEach(block => {
    const name = block.section ? `${block.group} ${block.section}` : block.group
    const limit = Math.min(block.hours, maxHours - count)
    if (limit <= 0) return
    info.push({ group: block.group, name, start: count, hours: limit, mixCH: block.mixCH, gelCH: block.gelCH })
    for (let i = 0; i < limit; i++) {
      schedule.push({
        block: name,
        mix: block.mix,
        mixImg: block.mixImg,
        mixCH: block.mixCH,
        gel: block.gel,
        gelImg: block.gelImg,
        gelCH: block.gelCH
      })
    }
    count += limit
  })
  const last = BLOCKS[BLOCKS.length - 1]
  while (count < maxHours) {
    if (info.length === 0 || info[info.length - 1].name !== (last.section ? `${last.group} ${last.section}` : last.group)) {
      info.push({ group: last.group, name: last.section ? `${last.group} ${last.section}` : last.group, start: count, hours: 0, mixCH: last.mixCH, gelCH: last.gelCH })
    }
    schedule.push({
      block: last.section ? `${last.group} ${last.section}` : last.group,
      mix: last.mix,
      mixImg: last.mixImg,
      mixCH: last.mixCH,
      gel: last.gel,
      gelImg: last.gelImg,
      gelCH: last.gelCH
    })
    info[info.length - 1].hours += 1
    count += 1
  }
  return { schedule, info }
}

const PLAN = buildSchedule()

function timeStr(date) {
  return `${String(date.getHours()).padStart(2, "0")}:${String(date.getMinutes()).padStart(2, "0")}`
}

export default class extends Controller {
  static targets = ["list"]

  connect() {
    const input = document.getElementById("startTime")
    if (input) input.addEventListener("change", () => this.render())
    this.render()
  }

  render() {
    const input = document.getElementById("startTime")
    const [h, m] = input && input.value ? input.value.split(":").map(Number) : [8, 0]
    const base = new Date()
    base.setHours(h, m, 0, 0)
    this.listTarget.innerHTML = ""

    const groups = {}
    PLAN.info.forEach((block, idx) => {
      if (!groups[block.group]) groups[block.group] = []
      groups[block.group].push({ ...block, idx })
    })

    Object.keys(groups).forEach(g => {
      const groupDetail = document.createElement("details")
      groupDetail.classList.add("mb-2")
      const groupSummary = document.createElement("summary")
      groupSummary.classList.add("cursor-pointer", "font-semibold", "bg-gray-200", "px-2", "py-1", "rounded")
      groupSummary.textContent = g
      groupDetail.appendChild(groupSummary)

      groups[g].forEach(block => {
        const section = document.createElement("details")
        section.classList.add("ml-4", "mb-2")
        const start = new Date(base.getTime() + block.start * 3600 * 1000)
        const end = new Date(base.getTime() + (block.start + block.hours) * 3600 * 1000)
        const secSummary = document.createElement("summary")
        secSummary.classList.add("cursor-pointer", "font-medium", "bg-gray-100", "px-2", "py-1", "rounded")
        const relStart = this.formatTime(block.start * 3600)
        const relEnd = this.formatTime((block.start + block.hours) * 3600)
        secSummary.textContent = `${block.name} (${timeStr(start)}–${timeStr(end)}) [${relStart} - ${relEnd}](${block.mixCH + block.gelCH}g)`
        section.appendChild(secSummary)

        const table = document.createElement("table")
        table.className = "w-full text-left mt-2"
        table.innerHTML = `
          <thead>
            <tr>
              <th class='px-2 py-1'>Hora</th>
              <th class='px-2 py-1'>Drink Mix</th>
              <th class='px-2 py-1'>Gel</th>
              <th class='px-2 py-1'>CH</th>
              <th class='px-2 py-1'>Hora del día</th>
            </tr>
          </thead>
        `
        const body = document.createElement("tbody")
        for (let i = block.start; i < block.start + block.hours; i++) {
          const item = PLAN.schedule[i]
          const t = new Date(base.getTime() + i * 3600 * 1000)
          const hh = String(t.getHours()).padStart(2, "0")
          const mm = String(t.getMinutes()).padStart(2, "0")
          const tr = document.createElement("tr")
          tr.innerHTML = `
            <td class='px-2 py-1'>${i + 1}</td>
            <td class='px-2 py-1'><img src='${item.mixImg}' alt='' class='h-10 inline-block mr-1'>${item.mix}</td>
            <td class='px-2 py-1'><img src='${item.gelImg}' alt='' class='h-10 inline-block mr-1'>${item.gel}</td>
            <td class='px-2 py-1'>${item.mixCH} + ${item.gelCH}</td>
            <td class='px-2 py-1'>${hh}:${mm}</td>
          `
          body.appendChild(tr)
        }
        table.appendChild(body)
        section.appendChild(table)
        groupDetail.appendChild(section)
      })
      this.listTarget.appendChild(groupDetail)
    })
  }

  formatTime(seconds) {
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`
  }
}
