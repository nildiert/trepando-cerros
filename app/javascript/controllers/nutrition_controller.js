import { Controller } from "@hotwired/stimulus"

const IMAGES = {
  dm320: "https://thehub.com.co/cdn/shop/files/drink_mix_320_maurten.webp?v=1731261437",
  dm160: "https://thehub.com.co/cdn/shop/files/DrinkMix1601.jpg?v=1705944477",
  gel160: "https://thehub.com.co/cdn/shop/files/Gel1601.jpg?v=1705944264",
  gel100: "https://thehub.com.co/cdn/shop/files/Gel100Foto1.jpg?v=1705943825",
  gel100caf: "https://thehub.com.co/cdn/shop/files/Gel100CAF1.jpg?v=1705944033"
}

const BLOCKS = [
  { hours: 7, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 4, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 3, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 100", gelImg: IMAGES.gel100 },
  { hours: 2, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 2, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, gel: "Gel 100 CAF", gelImg: IMAGES.gel100caf },
  { hours: 3, mix: "1/2 Drink Mix 320", mixImg: IMAGES.dm320, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 100 CAF", gelImg: IMAGES.gel100caf },
  { hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 2, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 100", gelImg: IMAGES.gel100 },
  { hours: 1, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 160", gelImg: IMAGES.gel160 },
  { hours: 2, mix: "1/2 Drink Mix 160", mixImg: IMAGES.dm160, gel: "Gel 100", gelImg: IMAGES.gel100 }
]

function buildSchedule(maxHours = 30) {
  const schedule = []
  BLOCKS.forEach(block => {
    for (let i = 0; i < block.hours && schedule.length < maxHours; i++) {
      schedule.push({ mix: block.mix, mixImg: block.mixImg, gel: block.gel, gelImg: block.gelImg })
    }
  })
  const last = BLOCKS[BLOCKS.length - 1]
  while (schedule.length < maxHours) {
    schedule.push({ mix: last.mix, mixImg: last.mixImg, gel: last.gel, gelImg: last.gelImg })
  }
  return schedule
}

const SCHEDULE = buildSchedule()

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
    SCHEDULE.forEach((item, idx) => {
      const t = new Date(base.getTime() + idx * 3600 * 1000)
      const hh = String(t.getHours()).padStart(2, "0")
      const mm = String(t.getMinutes()).padStart(2, "0")
      const tr = document.createElement("tr")
      tr.innerHTML = `
        <td class='px-2 py-1'>${idx + 1}</td>
        <td class='px-2 py-1'><img src='${item.mixImg}' alt='' class='h-10 inline-block mr-1'>${item.mix}</td>
        <td class='px-2 py-1'><img src='${item.gelImg}' alt='' class='h-10 inline-block mr-1'>${item.gel}</td>
        <td class='px-2 py-1'>${hh}:${mm}</td>
      `
      this.listTarget.appendChild(tr)
    })
  }
}
