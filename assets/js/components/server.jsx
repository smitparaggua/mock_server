import React from "react"
import {Link} from "react-router-dom"
import styled from "styled-components"
import {Servers} from "js/api"
import RunServerButton from "./run_server_button"
import {confirmAlert} from "react-confirm-alert"
import "react-confirm-alert/src/react-confirm-alert.css"
import ListAccordion from "components/list_accordion"
import RouteComponent from "components/show_server/route"
import DeleteButton from "components/server_listing/delete_button"

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
      .then(() => this.setState({state: 'running'}))
      .catch(() => this.setState({state: 'stopped'}))
  }

  stopServer() {
    this.setState({state: 'stopping'})
    Servers.stop(this.state.server.id)
      .then(() => this.setState({state: 'stopped'}))
  }

  deleteServer(event, server) {
    event.stopPropagation()
    const ConfirmAlert = function ({title, message, onClose, onConfirm}) {
      const Container = styled.div`
        background-color: #151b31;
        padding: 3em;
        border-radius: 0.8em;

        h1 {
          margin-top: 0;
        }
      `

      return (
        <Container>
          <h1>{title}</h1>
          <p>{message}</p>
          <button onClick={onClose}>No</button>
          <button onClick={onYes}>Yes</button>
        </Container>
      )

      function onYes() {
        onConfirm()
        onClose()
      }
    }

    const onConfirm = () => {
      return Servers.delete(server.id)
        .then(this.onDeleteSuccess)
        .catch(this.onDeleteFail)
    }

    const options = {
      title: 'Delete Server',
      message: `Are you sure you want to delete ${server.name}?`,
      childrenElement: () => <div />,
      customUI: props => <ConfirmAlert onConfirm={onConfirm} {...props}/>,
      willUnmount: noop
    };
    confirmAlert(options);
  }

  render() {
    const server = this.props.server
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
                <DeleteButton onClick={(event) => this.deleteServer(event, server)}>
                </DeleteButton>
              </MenuItems>
            </ServerContainer>
          ),
          items: server.routes,
          itemKey: function (route) { return route.id },
          itemTemplate: function (route) {
            return <RouteComponent server={server} route={route} withoutBackground={true}/>
          }
        }}
      </ListAccordion>
    )
  }
}

function noop() {}
