import React from "react"
import {Link} from "react-router-dom"
import axios from "axios"
import {ButtonLink, Button} from "./button"
import styled from "styled-components"
import Notifications from "components/notifications/index"
import ServerListing from "components/server_listing"

const Header = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`

export default class Servers extends React.PureComponent {
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
    axios.get("/api/servers").then(({data}) => {
      this.setState({
        loading: false,
        servers: data.data
      })
    })
  }

  render() {
    const notifRef = React.createRef()
    const self = this;
    return (
      <div className="container">
        <Notifications ref={notifRef}/>
        <Header>
          <h2 style={{display: "inline-block"}}>Servers</h2>
          <ButtonLink to="/servers/new" icon="plus">Create Server</ButtonLink>
        </Header>

        {this.state.loading
          ? "Loading"
          : <ServerListing
              servers={this.state.servers}
              onDeleteSuccess={function (server) {
                const message = (
                  <span> Successfully deleted <strong>{server.name}</strong>. </span>
                )
                notifRef.current.display({message: message, type: 'success'})
                self._refreshServers()
              }}
              onDeleteFail={function (error) {
                console.log(error)
                notifRef.current.display({
                  message: `Failed to delete server`,
                  type: 'error'
                })
              }}/>
        }
      </div>
    )
  }
}
