import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "form",
    "file",
    "dropzone",
    "heading",
    "loader",
    "messages",
    "bar",
    "timeField",
    "timeCard",
    "timeInput"
  ]

  connect() {
    this.submitted = false
  }

  submit(event) {
    if (this.submitted) return
    event.preventDefault()
    this.submitted = true
    this.dropzoneTarget.classList.add('hidden')
    this.timeCardTarget.classList.remove('hidden')
    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = 'Selecciona tu hora de inicio'
    }
  }

  confirmTime() {
    const value = this.timeInputTarget.value
    this.timeFieldTarget.value = value
    const startInput = document.getElementById('startTime')
    if (startInput) {
      startInput.value = value
      startInput.dispatchEvent(new Event('change'))
    }
    this.timeCardTarget.classList.add('hidden')
    if (this.hasHeadingTarget) {
      this.headingTarget.classList.add('hidden')
    }
    this.startSteps()
  }

  cancelTime() {
    this.timeCardTarget.classList.add('hidden')
    this.dropzoneTarget.classList.remove('hidden')
    this.submitted = false
    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = 'Cargar Archivo'
      this.headingTarget.classList.remove('hidden')
    }
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

