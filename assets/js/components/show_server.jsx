import React from "react"
import {Servers, Routes} from "js/api"
import NotFound from "errors/not_found"
import {ButtonLink} from "components/button"
import Route from "components/show_server/route"

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
      .then((response) => this.setState({loading: false, server: response.data}))
      .catch((error) => {
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
            <h2 style={{display: "inline-block"}}>{server.name}</h2>
            <ButtonLink to={`/servers/${server.id}/routes/new`} icon="plus">Create Route</ButtonLink>
          </div>

          {this.state.loadingRoutes
            ? this.renderLoading()
            : (
              <ul style={{listStyleType: "none"}}>
                {this.state.routes.map(route => (
                  <Route key={route.id} route={route} server={this.state.server}/>
                ))}
              </ul>
            )
          }
        </div>
      )
    }
    return <NotFound />
  }
}

export default ShowServer
