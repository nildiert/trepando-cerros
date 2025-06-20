import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dial", "hourHand", "minuteHand", "input", "label"]

  connect() {
    this.hour = 0
    this.minute = 0
    this.dragging = false
    this.updateHands()
    this.labelTarget.textContent = "00:00"
  }

  pointerDown(event) {
    event.preventDefault()
    this.dragging = true
    this.updateFromEvent(event)
    this.dialTarget.setPointerCapture(event.pointerId)
  }

  pointerMove(event) {
    if (!this.dragging) return
    this.updateFromEvent(event)
  }

  pointerUp(event) {
    if (!this.dragging) return
    this.dragging = false
    this.dialTarget.releasePointerCapture(event.pointerId)
  }

  updateFromEvent(event) {
    const rect = this.dialTarget.getBoundingClientRect()
    const cx = rect.left + rect.width / 2
    const cy = rect.top + rect.height / 2
    const angle = Math.atan2(event.clientY - cy, event.clientX - cx) * 180 / Math.PI + 90
    const deg = (angle + 360) % 360
    this.hour = Math.floor(deg / 15) % 24
    this.minute = Math.round((deg % 15) * 4)
    if (this.minute === 60) {
      this.minute = 0
      this.hour = (this.hour + 1) % 24
    }
    this.update()
  }

  update() {
    this.updateHands()
    const value = `${String(this.hour).padStart(2,'0')}:${String(this.minute).padStart(2,'0')}`
    this.inputTarget.value = value
    this.labelTarget.textContent = value
    this.inputTarget.dispatchEvent(new Event('change'))
  }

  updateHands() {
    const hourDeg = this.hour * 15 + this.minute * 0.25
    const minuteDeg = this.minute * 6
    this.hourHandTarget.style.transform = `translate(-50%, -100%) rotate(${hourDeg}deg)`
    this.minuteHandTarget.style.transform = `translate(-50%, -100%) rotate(${minuteDeg}deg)`
  }
}
