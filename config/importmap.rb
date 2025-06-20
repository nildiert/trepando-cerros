# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
# The Stimulus autoloading script caused 404 errors when modules
# were fetched dynamically. Controllers are registered manually,
# so we no longer need to pin the loader script.
# pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "xlsx", to: "https://cdn.jsdelivr.net/npm/xlsx@0.19.1/dist/xlsx.full.min.js"
