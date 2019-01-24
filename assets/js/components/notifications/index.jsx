import React from "react"
import styled from "styled-components"
import { TransitionGroup, CSSTransition } from "react-transition-group"
import Fade from "components/transitions/fade"
import {SuccessAlert} from "components/notifications/alerts"

const DEFAULT_DISPLAY_DELAY = 3000

class Notifications extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {notifs: []}
  }

  display(notif) {
    const delay = notif.delay || DEFAULT_DISPLAY_DELAY
    const notifId = Math.random().toString(36)
    const timeout = setTimeout(this._removeNotif.bind(this, notifId), delay)
    notif = {id: notifId, timeout, ...notif}
    this.setState({notifs: [notif, ...this.state.notifs]});
    // TODO clear the timeouts on componentWillUnmount
  }

  _removeNotif(notifId) {
    this.setState({
      notifs: this.state.notifs.filter(curr => curr.id != notifId)
    })
  }

  componentWillUnmount() {
    this.state.notifs.forEach(function (notif) {
      clearTimeout(notif.timeout);
    });
  }

  render() {
    return (
      <TransitionGroup>
        {this.state.notifs.map(notif => (
          <Fade key={notif.id}>
            <SuccessAlert>{notif.message}</SuccessAlert>
          </Fade>
        ))}
      </TransitionGroup>
    )
  }
}

export default Notifications
