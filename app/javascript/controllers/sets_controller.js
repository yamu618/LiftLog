import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "template"];

  add(event) {
    event.preventDefault();
    const clone = this.templateTarget.content.cloneNode(true);
    const index = this.containerTarget.querySelectorAll(".set-row").length;
    
    clone.querySelectorAll("input, select, textarea").forEach((el) => {
      el.name = el.name.replace("__INDEX__", index);
      el.id = el.id.replace("__INDEX__", index);
    });

    this.containerTarget.appendChild(clone);
  }

  remove(event) {
    event.preventDefault();
    const rows = this.containerTarget.querySelectorAll(".set-row");
    if (rows.length > 1) {
      rows[rows.length - 1].remove();
    }
  }
}
