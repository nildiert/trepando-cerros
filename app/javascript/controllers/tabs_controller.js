import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
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
