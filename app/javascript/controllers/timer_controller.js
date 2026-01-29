import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"]
  static values = {
    running: Boolean,
    startedAt: Number,
    baseDuration: Number
  }

  #intervalId

  connect() {
    if (this.runningValue && this.startedAtValue) {
      this.#startTicking()
    }
  }

  disconnect() {
    this.#stopTicking()
  }

  runningValueChanged() {
    if (this.runningValue) {
      this.#startTicking()
    } else {
      this.#stopTicking()
    }
  }

  #startTicking() {
    this.#tick()
    this.#intervalId = setInterval(() => this.#tick(), 1000)
  }

  #stopTicking() {
    if (this.#intervalId) {
      clearInterval(this.#intervalId)
      this.#intervalId = null
    }
  }

  #tick() {
    if (!this.hasDisplayTarget) return

    const elapsed = this.#elapsedSeconds()
    this.displayTarget.textContent = this.#formatDuration(elapsed)
  }

  #elapsedSeconds() {
    const now = Math.floor(Date.now() / 1000)
    const elapsedSinceStart = now - this.startedAtValue
    return this.baseDurationValue + elapsedSinceStart
  }

  #formatDuration(totalSeconds) {
    const hours = Math.floor(totalSeconds / 3600)
    const minutes = Math.floor((totalSeconds % 3600) / 60)
    const seconds = totalSeconds % 60

    const parts = []
    if (hours > 0) parts.push(`${hours}h`)
    if (minutes > 0 || hours > 0) parts.push(`${minutes}m`)
    if (hours === 0) parts.push(`${seconds}s`)

    return parts.join(" ")
  }
}
