import React from "react"
import axios from "axios"

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
        <h2>Servers</h2>
        {this.state.loading
          ? "Loading"
          : <ServerListing servers={this.state.servers}/>
        }
      </div>
    )
  }
}

const ServerListing = ({servers}) => {
  return (
    <ul>
      {servers.map(server => {
        return (
          <li key={server.id}>
            <Server server={server}/>
          </li>
        )
      })}
    </ul>
  )
}

const Server = ({server}) => {
  return (
    <span>{server.name}</span>
  )
}

export default Servers
