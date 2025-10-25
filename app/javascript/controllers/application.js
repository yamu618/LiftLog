import { Application } from "@hotwired/stimulus"

const application = Application.start()

application.debug = true // デバッグON（確認しやすい）
window.Stimulus = application

export { application }
