import React from "react"
import {Link} from "react-router-dom"
import styled from "styled-components"
import {Servers} from "api"
import RunServerButton from "./run_server_button"

const ServerContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 0 2em;
`

const Subtext = styled.div`
  font-size: small;
  color: gray;
`

export default class Server extends React.PureComponent {

  constructor(props) {
    super(props)
    const server = props.server
    const initialState = server.isRunning ? 'running' : 'stopped'
    this.state = {state: initialState, server: props.server}
    this.startServer = this.startServer.bind(this)
    this.stopServer = this.stopServer.bind(this)
    this.toggleServer = this.toggleServer.bind(this)
  }

  toggleServer() {
    this.state.state == 'stopped' ? this.startServer() : this.stopServer()
  }

  startServer() {
    this.setState({state: 'starting'})
    Servers.start(this.state.server.id)
      .then(console.log)
      .then(() => this.setState({state: 'running'}))
      .then(() => console.log(this.state))
      .catch(() => this.setState({state: 'stopped'}))
  }

  stopServer() {
    this.setState({state: 'stopping'})
    Servers.stop(this.state.server.id)
      .then(() => this.setState({state: 'stopped'}))
  }

  render() {
    const server = this.props.server
    return (
      <ServerContainer>
        <div>
          <Link to={`/servers/${server.id}`}>{server.name}</Link>
          <Subtext>
            <code>{server.path}</code>
            <div>{server.description}</div>
          </Subtext>
        </div>

        <RunServerButton state={this.state.state} onClick={() => this.toggleServer()}>
          Start
        </RunServerButton>
      </ServerContainer>
    )
  }
}
