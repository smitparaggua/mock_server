import React from "react"
import {Route, Switch, Redirect} from "react-router-dom"
import Home from "components/home"
import CreateServer from "components/create_server"
import Servers from "components/servers"
import ShowServer from "components/show_server"
import CreateRoute from "routes/create"
import NotFound from "errors/not_found"
import ShowRoute from "components/show_route/index"
import EditRoute from "components/routes/edit"

// TODO can we make /routes shallow? if so, how do we get server information?
// - server info is issue since front-end fetches server information
// - this is not an issue if initial load is from backend (we could send server
//   info as props)
const routes = (
  <Switch>
    <Route exact path="/" render={() => (<Redirect to="/servers" />)}/>
    <Route exact path="/servers/:serverId/routes/new" component={CreateRoute}/>
    <Route exact path="/servers/:serverId/routes/:id" component={ShowRoute}/>
    <Route exact path="/servers/:serverId/routes/:id/edit" component={EditRoute}/>
    <Route path="/servers/new" component={CreateServer}/>
    <Route path="/servers/:id" component={ShowServer}/>
    <Route path="/servers" component={Servers}/>
    <Route component={NotFound}/>
  </Switch>
)

export default routes
