import React from "react"
import {Route, Switch} from "react-router-dom"
import Home from "home"
import CreateServer from "create_server"
import Servers from "servers"
import ShowServer from "show_server"
import CreateRoute from "routes/create"
import NotFound from "errors/not_found"

const routes = (
  <Switch>
    <Route exact path="/" component={Home}/>
    <Route path="/servers/:serverId/routes/new" component={CreateRoute}/>
    <Route path="/servers/new" component={CreateServer}/>
    <Route path="/servers/:id" component={ShowServer}/>
    <Route path="/servers" component={Servers}/>
    <Route component={NotFound}/>
  </Switch>
)

export default routes
