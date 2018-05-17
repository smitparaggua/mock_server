import React from "react"
import {Input, inputStyle} from "./input"
import {Link} from "react-router-dom"

const style = {
  borderRadius: inputStyle.borderRadius,
  padding: inputStyle.padding,
  lineHeight: inputStyle.lineHeight,
  fontSize: inputStyle.fontSize,
  cursor: "pointer"
}

const Button = ({children}) => {
  return <button style={style}>{children}</button>
}

const ButtonLink = ({children, to, icon}) => {
  return (
    <Button>
      <Link to={to} style={{textDecoration: "none"}}>
        <i className={`fa fa-${icon}`} style={{color: "gray"}}></i> Create Server
      </Link>
    </Button>
  )
}

export {Button, ButtonLink}
export default Button
