import React from "react"
import styled from "styled-components"
import { CSSTransition } from 'react-transition-group'

const DEFAULT_TIMEOUT = 500;

const FadeContainer = styled(CSSTransition)`
  &.fade-enter {
    opacity: 0.01;
  }

  &.fade-enter-active {
    transition: 0.5s opacity ease-in;
    opacity: 1;
  }

  &.fade-exit {
    opacity: 1;
  }

  &.fade-exit-active {
    opacity: 0;
    transition: opacity 0.5s ease-in;
  }
`

const Fade = ({in: _in, timeout, ...otherProps}) => {
  _in = _in || false
  timeout = timeout || DEFAULT_TIMEOUT
  return (
    <FadeContainer in={_in} timeout={timeout} {...otherProps} classNames="fade"/>
  )
}

export default Fade;
