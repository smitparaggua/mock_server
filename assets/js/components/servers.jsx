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
    this._refreshServers = this._refreshServers.bind(this)
  }

  componentDidMount() {
    this._refreshServers()
  }

  _refreshServers() {
    // TODO error handling
    console.log('loading servers')
    axios.get("/api/servers").then(({data}) => {
      console.log(data.data)
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
          : <ServerListing
              servers={this.state.servers}
              onDeleteSuccess={this._refreshServers}
              onDeleteFail={() => alert('delet failed')}/>
        }
      </div>
    )
  }
}

const ServerListing = ({servers, onDeleteSuccess, onDeleteFail}) => {
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
          <Server server={server} onDeleteSuccess={onDeleteSuccess} onDeleteFail={onDeleteFail}/>
        </ListItem>
      ))}
    </Listing>
  )
}

export default Servers
