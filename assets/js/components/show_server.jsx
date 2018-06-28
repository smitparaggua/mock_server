import React from "react"
import {Servers, Routes} from "api"
import NotFound from "./errors/not_found"
import {ButtonLink} from "./button"

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
      .then(response => this.setState({loadingRoutes: false, routes: response.data}))
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
    console.log('ssssssss-routes-------')
    console.log(this.state.routes)
    console.log('ssssssss-routes-end---')
    if (server) {
      return (
        <div className="container">
          <div style={headerStyle}>
            <h2 style={{display: "inline-block"}}>{server.name}</h2>
            <ButtonLink to={`/servers/${server.id}/routes/new`} icon="plus">Create Route</ButtonLink>
          </div>

          {this.state.routes
            ? (
              <ul style={{listStyleType: "none"}}>
                {this.state.routes.map(route => (
                  <li style={{}}>
                    <span>{route.method} {route.path}</span>
                    <div style={{fontSize: "smaller", color: "gray"}}>
                      <div>{route.description}</div>
                    </div>
                  </li>
                ))}
              </ul>
            )
            : <div>Shit</div>
          }
        </div>
      )
    }
    return <NotFound />
  }
}

export default ShowServer
