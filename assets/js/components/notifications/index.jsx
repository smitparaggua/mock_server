import React from "react"
import styled from "styled-components"
import { TransitionGroup, CSSTransition } from 'react-transition-group'
import Fade from "components/transitions/fade"

const DEFAULT_DISPLAY_DELAY = 3000

class Notifications extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      notifs: []
    }
    this.display = this.display.bind(this)
  }

  display(notif) {
    const delay = notif.delay || DEFAULT_DISPLAY_DELAY
    const notifId = Math.random().toString(36)
    notif = {id: notifId, ...notif}
    this.setState({notifs: [notif, ...this.state.notifs]});
    setTimeout(this._removeNotif.bind(this, notifId), delay)
  }

  _removeNotif(notifId) {
    this.setState({
      notifs: this.state.notifs.filter(curr => curr.id != notifId)
    })
  }

  render() {
    return (
      <TransitionGroup>
        {this.state.notifs.map(notif => (
          <Fade key={notif.id}>
            <div>{notif.message}</div>
          </Fade>
        ))}
      </TransitionGroup>
    )
  }
}

export default Notifications
