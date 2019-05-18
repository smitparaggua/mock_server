import React from "react"
import {Servers, Routes} from "js/api"
import NotFound from "errors/not_found"
import {ButtonLink} from "components/button"
import {Routes as RoutesComponent} from "components/show_server/route"
import {serversPath} from "local_routes"
import {Link} from "react-router-dom"

const headerStyle = {
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center"
}

class ShowServer extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      server: null,
      loading: true,
      loadingRoutes: true,
      serverId: props.match.params.id
    }
    this.renderLoading = this.renderLoading.bind(this)
    this.renderServer = this.renderServer.bind(this)
  }

  componentDidMount() {
    Servers.get(this.state.serverId)
      .then(server => this.setState({loading: false, server}))
      .catch(error => {
        const response = error.response || {}
        return response.status == 404
          ? this.setState({loading: false})
          : Promise.reject(error)
      })

    Routes.list(this.state.serverId)
      .then(data => this.setState({loadingRoutes: false, routes: data}))
      .catch(error => {
        const response = error.response || {}
        return response.status == 404
          ? this.setState({loadingRoutes: false})
          : Promise.reject(error)
      })
  }

  render() {
    return this.state.loading ? this.renderLoading() : this.renderServer()
  }

  renderLoading() {
    return <div>Loading</div>
  }

  renderServer() {
    const server = this.state.server
    if (server) {
      return (
        <div className="container">
          <div style={headerStyle}>
            <h2 style={{display: "inline-block"}}>
              <Link to={{pathname: serversPath()}}>Servers</Link>
              {" > "}
              {server.name} (<code>{server.path}</code>)
            </h2>
            <ButtonLink to={`/servers/${server.id}/routes/new`} icon="plus">Create Route</ButtonLink>
          </div>

          <div>
            {server.description}
          </div>

          <h3>Routes</h3>
          {this.state.loadingRoutes
            ? this.renderLoading()
            : <RoutesComponent routes={this.state.routes} server={this.state.server}/>
          }
        </div>
      )
    }
    return <NotFound />
  }
}

export default ShowServer
