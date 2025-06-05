import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value.trim()
    if (query === "") {
      this.resultsTarget.innerHTML = ""
      return
    }
    fetch(`/athletes/search?query=${encodeURIComponent(query)}`)
      .then(r => r.ok ? r.json() : [])
      .then(data => {
        if (data.length > 0) {
          this.resultsTarget.innerHTML = data.map(a => `
            <div class="flex items-center space-x-2 p-2 cursor-pointer hover:bg-gray-100" data-action="click->athlete-search#select" data-id="${a.id}">
              <img src="${a.profile}" alt="Avatar" class="w-8 h-8 rounded-full" />
              <span>${a.firstname} ${a.lastname}</span>
            </div>`).join('')
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
