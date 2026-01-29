import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "minutes", "durationSeconds"]

  calculateDuration(event) {
    const hours = parseInt(this.hoursTarget.value) || 0
    const minutes = parseInt(this.minutesTarget.value) || 0
    const totalSeconds = (hours * 3600) + (minutes * 60)

    if (totalSeconds === 0) {
      event.preventDefault()
      this.hoursTarget.focus()
      return
    }

    this.durationSecondsTarget.value = totalSeconds
  }
}
