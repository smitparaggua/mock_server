import React from "react"
import {Servers} from "../api"
import NotFound from "./errors/not_found"

class ShowServer extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      server: null,
      loading: true,
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
        response.status == 404
          ? this.setState({loading: false})
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
      return <h1>{server.name}</h1>
    }
    return <NotFound />
  }
}

export default ShowServer
