import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

export default class extends Controller {
  static targets = [
    "form",
    "file",
    "dropzone",
    "loader",
    "messages",
    "bar",
    "timeField"
  ]

  connect() {
    this.submitted = false
  }

  submit(event) {
    if (this.submitted) return
    event.preventDefault()
    this.submitted = true
    Swal.fire({
      title: 'Selecciona tu hora de inicio',
      html: `
        <div data-controller="time-dial" class="flex items-center space-x-4 justify-center">
          <input id="startTimeInput" type="time" data-time-dial-target="input" class="hidden">
          <div data-time-dial-target="dial" class="relative w-24 h-24 rounded-full border-2 border-blue-500 bg-white" data-action="pointerdown->time-dial#pointerDown pointermove->time-dial#pointerMove pointerup->time-dial#pointerUp pointerleave->time-dial#pointerUp">
            <div data-time-dial-target="hourHand" class="absolute left-1/2 top-1/2 w-0.5 bg-blue-700 origin-bottom" style="height:30%;"></div>
            <div data-time-dial-target="minuteHand" class="absolute left-1/2 top-1/2 w-0.5 bg-blue-400 origin-bottom" style="height:45%;"></div>
          </div>
          <span data-time-dial-target="label" class="text-blue-700 font-medium">00:00</span>
        </div>
      `,
      confirmButtonText: 'Aceptar',
      showCancelButton: true,
      focusConfirm: false,
      preConfirm: () => {
        return document.getElementById('startTimeInput').value
      }
    }).then(result => {
      if (result.isConfirmed) {
        this.timeFieldTarget.value = result.value
        this.startSteps()
      } else {
        this.submitted = false
      }
    })
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

