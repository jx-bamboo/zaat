# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "bootstrap", to: "https://unpkg.com/bootstrap@5.3.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://unpkg.com/@popperjs/core@2.11.8/dist/esm/index.js"

pin "three", to: "https://cdn.jsdelivr.net/npm/three@0.162.0/build/three.module.min.js"
# pin "web3", to: "https://cdn.jsdelivr.net/npm/web3@4.10.0/dist/web3.min.js"
# pin "web3", to: "../vendor/javascript/web3/package/lib/esm/web3.js"
# pin "web3", to: "vendor/javascript/web3/package/lib/esm/web3.js"
pin 'web3', to: "https://unpkg.com/web3@4.10.0/dist/web3.min.js"
