import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader", "messages", "bar"]

  connect() {
    this.submitted = false
  }

  submit(event) {
    if (this.submitted) return
    event.preventDefault()
    this.submitted = true
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
          event.target.submit()
        }
      }, idx * delay)
    })
  }
}
