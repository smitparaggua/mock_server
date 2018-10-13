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
    this.state = {state: 'stopped', server: props.server}
    this.handleStart = this.handleStart.bind(this)
    this.handleStop = this.handleStop.bind(this)
  }

  handleStart() {
    this.setState({state: 'starting'})
    Servers.start(this.state.server.id)
      .then(() => this.setState({state: 'running'}))
      .catch(() => this.setState({state: 'stopped'}))
    // call start
    // while calling, change button to running
    // on fail go back to start
    // on success go to stop
  }

  handleStop() {
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

        <RunServerButton state={this.state.state} onClick={() => this.handleStart()}>
          Start
        </RunServerButton>
      </ServerContainer>
    )
  }
}
