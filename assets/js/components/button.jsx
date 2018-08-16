import React from "react"
import {Input} from "./input"
import {Link, withRouter} from "react-router-dom"
import styled from "styled-components"

const Button = styled.button`
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: inset 0 1px 1px rgb(0, 0, 0, 0.075);
  padding: 6px 12px;
  line-height: 1.42;
  font-size: 1em;
  box-sizing: border-box;
  cursor: pointer;
  outline: none;
`

const ButtonLink = withRouter(({children, to, icon, history}) => {
  return (
    <Button onClick={() => history.push(to)}>
      <i className={`fa fa-${icon}`} style={{color: "gray"}}></i> {children}
    </Button>
  )
})

export {Button, ButtonLink}
export default Button
