// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar.cjs"
import { hello, sendLovelace, getBalanceByName, getInstalledWalletExtensions } from "../ts/main"


let Hooks = {}

Hooks.SendL = {
  mounted() {
    this.el.addEventListener("click", e => {
      console.log("wallet", this.el.dataset)
      sendLovelace(this.el.dataset.wallet, this.el.dataset.address, this.el.dataset.amount)
    })
  }
}

Hooks.Connect = {
  wallet() { return this.el.dataset.wallet },
  mounted() {
    this.el.addEventListener("click", async e => {
      console.log(this.wallet())
      const balance = await getBalanceByName(this.wallet())
      console.log("balance", balance)

      this.pushEvent("connected", { wallet: this.wallet(), balance: balance })
    })
  }
}

Hooks.Balance = {
  mounted() {
    this.el.addEventListener("click", e => {
      console.log(e)
      this.pushEvent("balance", balance())
    })
  }
}

Hooks.Wallets = {
  mounted() {
    this.el.addEventListener("click", e => {
      const wallets = getInstalledWalletExtensions()
      console.log(wallets)
      this.pushEvent("wallets", wallets)
    })
  }
}

Hooks.Hello = {
  mounted() {
    this.el.addEventListener("click", e => {
      const h = hello();
      console.log("received event")
      console.log(h);
      this.pushEvent("hello", h)
    })
  }
}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


window.addEventListener("phx:live_reload:attached", ({ detail: reloader }) => {
  // Enable server log streaming to client. Disable with reloader.disableServerLogs()
  reloader.enableServerLogs()

  // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
  //
  //   * click with "Alt" key pressed to open at caller location
  //   * click with "Shift" key pressed to open at function component definition location
  let keyDown
  window.addEventListener("keydown", e => keyDown = e.key)
  window.addEventListener("keyup", e => keyDown = null)
  window.addEventListener("click", e => {
    console.log("key", keyDown)
    if (keyDown === "Alt") {
      e.preventDefault()
      e.stopImmediatePropagation()
      reloader.openEditorAtCaller(e.target)
    } else if (keyDown === "Shift") {
      e.preventDefault()
      e.stopImmediatePropagation()
      reloader.openEditorAtDef(e.target)
    }
  }, true)
  window.liveReloader = reloader
})

// Allows to execute JS commands from the server
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})
