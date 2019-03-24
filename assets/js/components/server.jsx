import React from "react"
import {Link} from "react-router-dom"
import styled from "styled-components"
import {Servers} from "js/api"
import RunServerButton from "./run_server_button"
import {confirmAlert} from "react-confirm-alert"
import "react-confirm-alert/src/react-confirm-alert.css"
import ListAccordion from "components/list_accordion"
import RouteComponent from "components/show_server/route"

const ServerContainer = styled.div`
  outline: none;
  cursor: pointer;
  background-color: #2e364f;
  border-radius: 0.3em;

  ::-webkit-details-marker {
    display: none;
  }

  align-items: center;
  display: flex;
  justify-content: space-between;
`

const Subtext = styled.div`
  font-size: small;
  color: gray;
`

const MenuItems = styled.div`
  display: flex;
  align-items: center;

  div, i {
    margin-right: 10px;
    margin-left: 10px;
  }
`

const DeleteButton = styled.i`
  color: #a33;
  font-size: 1.2em;
  cursor: pointer;
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
    this.deleteServer = this.deleteServer.bind(this)
    this.onDeleteSuccess = props.onDeleteSuccess || noop
    this.onDeleteFail = props.onDeleteFail || noop
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

  deleteServer(server) {
    const options = {
      title: 'Delete Server',
      message: `Are you sure you want to delete ${server.name}?`,
      buttons: [
        {
          label: 'Yes',
          onClick: () => {
            return Servers.delete(server.id)
              .then(this.onDeleteSuccess)
              .catch(this.onDeleteFail)
            // TODO after delete handler
            // on success, show deleted message toast, refresh list of servers
            // on fail, show failed toast
          }
        },
        {label: 'No'}
      ],
      childrenElement: () => <div />,
      // customUI: ({ title, message, onClose }) => <div>Custom UI</div>,
      willUnmount: noop
    };
    confirmAlert(options);
  }

  render() {
    const server = this.props.server
    console.log(server)
    return (
      <ListAccordion>
        {{
          header: (
            <ServerContainer>
              <div>
                <Link to={`/servers/${server.id}`}>{server.name}</Link>
                <Subtext>
                  <code>{server.path}</code>
                  <div>{server.description}</div>
                </Subtext>
              </div>

              <MenuItems>
                <RunServerButton state={this.state.state} onClick={() => this.toggleServer()}>
                  Start
                </RunServerButton>
                <DeleteButton className={`fa fa-times-circle`}
                              onClick={() => this.deleteServer(server)}>
                </DeleteButton>
              </MenuItems>
            </ServerContainer>
          ),
          items: server.routes,
          itemKey: function (route) { return route.id },
          itemTemplate: function (route) {
            return <RouteComponent server={server} route={route} />
          }
        }}
      </ListAccordion>
    )
  }
}

function noop() {}
