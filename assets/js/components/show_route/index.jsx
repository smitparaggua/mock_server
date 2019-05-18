import React from "react"
import {Servers, Routes} from "js/api"
import {JsonBlock, CodeBlock} from "components/code"
import {TextWithDefaultComment} from "components/text"
import NotFound from "errors/not_found"
import {Link} from "react-router-dom"
import {serverPath, serversPath} from "local_routes"

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
        .then(server => this.setState({server, loadingServer: false}))
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
    return this.state.loadingServer || this.state.loadingRoute
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
      return <NotFound/>
    }

    const {server, route} = this.state
    return (
      <div className="container">
        <h2>
          <Link to={{pathname: serversPath()}}>Servers</Link>
          {" > "}
          <Link to={{pathname: serverPath(this.serverId), state: {server}}}>
            {server.name}
          </Link>
          {" > "} <code>{route.method} {route.path}</code>
        </h2>

        <TextWithDefaultComment text={route.description} defaultComment="No description."/>

        <h3>
          Response
        </h3>

        <div>
          <code>{route.statusCode} ({route.responseType})</code>
          {
            route.responseType == "application/json"
              ? <JsonBlock json={route.responseBody} />
              : <CodeBlock>route.responseBody</CodeBlock>
          }
        </div>

        <h3>
          Access History
        </h3>

        <TextWithDefaultComment text={null} defaultComment="This route has no access logs."/>
      </div>
    )
  }
}

export default ShowRoute
