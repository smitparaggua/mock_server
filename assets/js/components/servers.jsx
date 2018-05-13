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
  const style = {
    listStyleType: "none"
  }
  return (
    <ul style={style}>
      {servers.map(server => {
        return <Server key={server.id} server={server}/>
      })}
    </ul>
  )
}

const Server = ({server}) => {
  const style = {
    marginBottom: "1em"
  }
  return (
    <li style={style}>
      <div>{server.name}</div>
      <div style={{fontSize: "smaller", color: "gray"}}>
        <code>{server.path}</code>
        <div>{server.description}</div>
      </div>
    </li>
  )
}

export default Servers
