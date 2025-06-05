import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value.trim()
    if (query === "") {
      this.resultsTarget.innerHTML = ""
      return
    }
    fetch(`/athletes/lookup?query=${encodeURIComponent(query)}`)
      .then(r => r.ok ? r.json() : null)
      .then(data => {
        if (data) {
          this.resultsTarget.innerHTML = `
            <div class="flex items-center space-x-2 p-2 cursor-pointer hover:bg-gray-100" data-action="click->athlete-search#select" data-id="${data.id}">
              <img src="${data.profile}" alt="Avatar" class="w-8 h-8 rounded-full" />
              <span>${data.firstname} ${data.lastname}</span>
            </div>`
        } else {
          this.resultsTarget.innerHTML = `<p class="p-2 text-sm text-gray-500">No encontrado</p>`
        }
      })
      .catch(() => { this.resultsTarget.innerHTML = "" })
  }

  select(event) {
    const id = event.currentTarget.dataset.id
    window.location = `/athletes/${id}`
  }
}
