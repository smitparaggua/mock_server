import React from "react"
import {Link} from "react-router-dom"
import axios from "axios"
import {ButtonLink} from "./button"

const headerStyle = {
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center"
}

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
        <div style={headerStyle}>
          <h2 style={{display: "inline-block"}}>Servers</h2>
          <ButtonLink to="/servers/new" icon="plus">CreateServer</ButtonLink>
        </div>

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
      <Link to={`/servers/${server.id}`}>{server.name}</Link>
      <div style={{fontSize: "smaller", color: "gray"}}>
        <code>{server.path}</code>
        <div>{server.description}</div>
      </div>
    </li>
  )
}

export default Servers
