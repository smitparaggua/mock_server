import React from "react"
import {Route, Switch} from "react-router-dom"
import Home from "./components/home"
import CreateServer from "./components/create_server"
import Servers from "./components/servers"
import ShowServer from "./components/show_server"
import NotFound from "./components/errors/not_found"

const routes = (
  <Switch>
    <Route exact path="/" component={Home}/>
    <Route path="/servers/new" component={CreateServer}/>
    <Route path="/servers/:id" component={ShowServer}/>
    <Route path="/servers" component={Servers}/>
    <Route component={NotFound}/>
  </Switch>
)

export default routes
