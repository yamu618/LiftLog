import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];

  search() {
    const query = this.inputTarget.value;
    const categoryId = this.data.get("category-id")

    if (!query) {
      this.resultsTarget.innerHTML = "";
      return;
    }

    fetch(
      `/api/exercises?query=${query}&category_id=${categoryId}`
    )
      .then((response) => response.json())
      .then((names) => {
        this.resultsTarget.innerHTML = names
          .map(
            (name) =>
              `<div class="suggestion" style="padding:5px 10px; cursor:pointer;">${name}</div>`
          )
          .join("");

        this.resultsTarget.querySelectorAll(".suggestion").forEach((el) => {
          el.addEventListener(
            "mouseenter",
            () => (el.style.backgroundColor = "#f0f0f0")
          );
          el.addEventListener(
            "mouseleave",
            () => (el.style.backgroundColor = "white")
          );
          el.addEventListener("click", () => {
            this.inputTarget.value = el.textContent;
            this.resultsTarget.innerHTML = "";
          });
        });
      });
  }
}
