import React from "react"
import {Link} from "react-router-dom"
import axios from "axios"
import {ButtonLink, Button} from "./button"
import styled from "styled-components"

const Header = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`

class Servers extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      servers: [],
      loading: true
    }
  }

  componentDidMount() {
    axios.get("/api/servers").then(({data}) => {
      this.setState({
        loading: false,
        servers: data.data
      })
    })
  }

  render() {
    return (
      <div className="container">
        <Header>
          <h2 style={{display: "inline-block"}}>Servers</h2>
          <ButtonLink to="/servers/new" icon="plus">Create Server</ButtonLink>
        </Header>

        {this.state.loading
          ? "Loading"
          : <ServerListing servers={this.state.servers}/>
        }
      </div>
    )
  }
}

const ServerListing = ({servers}) => {
  const Listing = styled.div`
    list-style-type: none;
  `
  const ListItem = styled.li`
    margin-bottom: 1em;
  `
  return (
    <Listing>
      {servers.map(server => (
        <ListItem key={server.id}>
          <Server server={server}/>
        </ListItem>
      ))}
    </Listing>
  )
}

const ServerContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 0 2em;
`

const StartButton = styled(Button)`
  background-color: #5fb760;
  border-color: #50ad51;
  color: white;
`

const StopButton = styled(Button)`
  color: #fff;
  background-color: #d9534f;
  border-color: #d43f3a;
`

const Subtext = styled.div`
  font-size: small;
  color: gray;
`

class Server extends React.PureComponent {

  constructor(props) {
    super(props)
    this.state = {
      state: 'stopped',
      server: props.server
    }
  }

  handleStart() {
    // call start
    // while calling, change button to running
    // on fail go back to start
    // on success go to stop
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
        <StartButton>Start</StartButton>
      </ServerContainer>
    )
  }
}

export default Servers
