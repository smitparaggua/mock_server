// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import "babel-polyfill"
import React from "react"
import ReactDom from "react-dom"
import {BrowserRouter} from "react-router-dom"
import routes from "./routes"

import "phoenix_html"

ReactDom.render(
  <BrowserRouter children={routes} />,
  document.getElementById("react-app")
)
