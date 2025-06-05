import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader", "messages"]

  submit() {
    this.loaderTarget.classList.remove('hidden')
    this.messagesTarget.innerHTML = ''
    const steps = ['Leyendo GPX...', 'Consultando Strava...', 'Calculando tiempos...']
    steps.forEach((msg, idx) => {
      setTimeout(() => {
        this.messagesTarget.insertAdjacentHTML('beforeend', `<p>${msg}</p>`)
      }, idx * 800)
    })
  }
}
