// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./react/src/index.js"

Turbo.setConfirmMethod((message, element) => {
    const dialog = document.getElementById("turbo-confirm")
    dialog.showModal()
    dialog.querySelector("p").textContent = message

    return new Promise((resolve, reject) => {
        dialog.addEventListener('close', () => {
            resolve(dialog.returnValue === 'confirm')
        }, {once: true})
    })
})

