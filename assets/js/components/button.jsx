import React from "react"
import {Input} from "./input"
import {Link, withRouter} from "react-router-dom"
import styled from "styled-components"

const Button = styled.button`
  background-color: #3f4453;
  color: #fff;
  margin: 0;
  border: none;
  border-width: 2px;
  border-radius: 0.1875rem;
  cursor: pointer;
  padding: 0.7rem 1rem;
  line-height: 1.35em;
  white-space: normal;
  font-size: 0.8571em;
  font-weight: 400;
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
