# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "xlsx", to: "https://cdn.jsdelivr.net/npm/xlsx@0.20.2/dist/xlsx.full.min.js"
