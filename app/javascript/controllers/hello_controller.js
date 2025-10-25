import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "output"]

  connect() {
    console.log("✅ HelloController が接続されました！")
  }

  greet() {
    const name = this.nameTarget.value
    this.outputTarget.textContent = `こんにちは、${name}さん！💪`
  }
}
