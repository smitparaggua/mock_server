import React from "react"
import {Servers, Routes} from "js/api"

class ShowRoute extends React.PureComponent {
  constructor(props) {
    super(props);
    const linkProps = props.location.state || {}
    const server = props.server || linkProps.server
    const route = props.route || linkProps.route
    this.serverId = this.props.match.params.serverId
    this.id = this.props.match.params.id
    this.state = {
      server, route,
      loadingServer: !Boolean(server),
      loadingRoute: !Boolean(route),
      hasError: false
    }
  }

  componentDidMount() {
    const {server, route} = this.state
    if (!server) {
      Servers.get(this.serverId)
        .then(response => this.setState({server: response.data, loadingServer: false}))
        .catch(error => {
          const response = error.response || {}
          return response.status == 404
            ? this.setState({loadingServer: false})
            : this.setState({loadingServer: false, hasError: true})
        })
    }

    if (!route) {
      Routes.get(this.id)
        .then(route => this.setState({route, loadingRoute: false}))
        .catch(error => {
          const response = error.response || {}
          return response.status == 404
            ? this.setState({loadingRoute: false})
            : this.setState({loadingRoute: false, hasError: true})
        })
    }
  }

  _isLoading() {
    return this.state.loadingServer && this.state.loadingRoute
  }

  _hasCompleteInformation() {
    return !this._isLoading() && this.state.server && this.state.route
  }

  render() {
    if (this._isLoading()) {
      return null
    }
    if (this.state.hasError) {
      // TODO make proper error
      return (<div>Error occurred while loading route information</div>)
    }
    if (!this._hasCompleteInformation()) {
      // Route NOT found
    }
    const {server, route} = this.state
    return (
      <div className="container">
        <h2>
          <div>{server.name} {">"} {route.method} {route.path}</div>
        </h2>

        <div>
          {route.description}
        </div>

        <h3>
          Response
        </h3>

        <div>
          {route.statusCode} ({route.responseType})
          <div>
            Body:
            <div>
              {route.responseBody}
            </div>
          </div>
        </div>

        <h3>
          Access History
        </h3>

        <div>
          This route has no access logs.
        </div>
      </div>
    )
  }
}

export default ShowRoute
