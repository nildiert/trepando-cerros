import { application } from "controllers/application"
import { Controller } from "@hotwired/stimulus"
import * as XLSX from "xlsx"

// Analysis controller manages file upload and progress animation
class AnalysisController extends Controller {
  static targets = ["form", "file", "dropzone", "loader", "messages", "bar"]

  connect() {
    this.submitted = false
  }

  submit(event) {
    if (this.submitted) return
    event.preventDefault()
    this.submitted = true
    this.startSteps()
  }

  autoSubmit() {
    if (this.fileTarget.files.length > 0) {
      this.formTarget.requestSubmit()
    }
  }

  openFile() {
    this.fileTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add('border-blue-500', 'bg-blue-50')
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove('border-blue-500', 'bg-blue-50')
  }

  drop(event) {
    event.preventDefault()
    this.dragLeave(event)
    this.fileTarget.files = event.dataTransfer.files
    this.formTarget.requestSubmit()
  }

  startSteps() {
    this.loaderTarget.classList.remove('hidden')
    this.messagesTarget.innerHTML = ''
    this.barTarget.style.width = '0%'
    const steps = ['Leyendo GPX...', 'Consultando Strava...', 'Calculando tiempos...', 'Generando gráfica...']
    const delay = 1000

    steps.forEach((msg, idx) => {
      setTimeout(() => {
        this.messagesTarget.insertAdjacentHTML('beforeend', `<p>${msg}</p>`)
        const pct = ((idx + 1) / steps.length) * 100
        this.barTarget.style.width = `${pct}%`

        if (idx === steps.length - 1) {
          this.formTarget.submit()
        }
      }, idx * delay)
    })
  }
}

// Dropdown controller toggles simple menus
class DropdownController extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle('hidden')
  }
}

// Hello controller is only for demo text replacement
class HelloController extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

// Simple tabs navigation
class TabsController extends Controller {
  static targets = ["panel", "tab"]

  connect() {
    this.show(0)
  }

  switch(event) {
    event.preventDefault()
    const idx = this.tabTargets.indexOf(event.currentTarget)
    this.show(idx)
  }

  show(index) {
    this.tabTargets.forEach((t, i) => {
      t.classList.toggle('border-blue-500', i === index)
      t.classList.toggle('text-blue-600', i === index)
      t.classList.toggle('border-b-2', i === index)
    })
    this.panelTargets.forEach((p, i) => {
      p.classList.toggle('hidden', i !== index)
    })
  }
}

// Checkpoints controller handles import/export and time calculations
class CheckpointsController extends Controller {
  static targets = ["list", "template", "output", "file", "loader", "bar", "messages"]

  connect() {
    this.results = []
    this.loading = false
  }

  addRow() {
    const fragment = this.templateTarget.content.cloneNode(true)
    this.listTarget.appendChild(fragment)
  }

  chooseFile() {
    this.fileTarget.click()
  }

  import(event) {
    const file = event.target.files[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = e => {
      const wb = XLSX.read(e.target.result)
      const sheet = wb.Sheets[wb.SheetNames[0]]
      const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 })
      rows.forEach((r, idx) => {
        if (idx === 0 && typeof r[1] === 'string') return
        const name = r[0]
        const km = parseFloat(r[1])
        if (!name || isNaN(km)) return
        const frag = this.templateTarget.content.cloneNode(true)
        const row = frag.querySelector('.checkpoint-row')
        row.querySelector('[data-field="name"]').value = name
        row.querySelector('[data-field="km"]').value = km
        this.listTarget.appendChild(frag)
      })
    }
    reader.readAsArrayBuffer(file)
  }

  export() {
    if (this.results.length === 0) return
    const data = [['Nombre', 'Km', 'Inicio', 'Fin']]
    this.results.forEach(r => {
      data.push([r.name, r.km, r.start, r.end])
    })
    const ws = XLSX.utils.aoa_to_sheet(data)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Puntos')
    XLSX.writeFile(wb, 'puntos.xlsx')
  }

  compute() {
    if (this.loading) return
    this.loading = true
    this.loaderTarget.classList.remove('hidden')
    this.messagesTarget.innerHTML = ''
    this.barTarget.style.width = '0%'
    const steps = ['Leyendo datos...', 'Calculando...', 'Listo']
    const delay = 800
    steps.forEach((msg, idx) => {
      setTimeout(() => {
        this.messagesTarget.insertAdjacentHTML('beforeend', `<p>${msg}</p>`)
        const pct = ((idx + 1) / steps.length) * 100
        this.barTarget.style.width = `${pct}%`
        if (idx === steps.length - 1) this.finishCompute()
      }, idx * delay)
    })
  }

  finishCompute() {
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
      results.push({ name, km, start: startStr, end: endStr })
    })
    this.results = results
    const html = results.map(r => `<li>${r.name}: ${r.start} - ${r.end}</li>`).join('')
    this.outputTarget.innerHTML = `<ul class='list-disc pl-5 space-y-1'>${html}</ul>`
    this.loaderTarget.classList.add('hidden')
    this.loading = false
  }
}

// Register all controllers with Stimulus application
application.register("analysis", AnalysisController)
application.register("dropdown", DropdownController)
application.register("hello", HelloController)
application.register("tabs", TabsController)
application.register("checkpoints", CheckpointsController)
