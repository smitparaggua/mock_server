import React from "react"
import {Link} from "react-router-dom"
import axios from "axios"
import {ButtonLink, Button} from "./button"
import styled from "styled-components"
import Server from "./server"

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

export default Servers
