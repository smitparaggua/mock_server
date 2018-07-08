import React from "react"
import {Input, inputStyle} from "./input"
import {Link, withRouter} from "react-router-dom"

const style = {
  borderRadius: inputStyle.borderRadius,
  padding: inputStyle.padding,
  lineHeight: inputStyle.lineHeight,
  fontSize: inputStyle.fontSize,
  cursor: "pointer"
}

const Button = ({children, ...others}) => {
  return <button style={style} {...others}>{children}</button>
}

const ButtonLink = withRouter(({children, to, icon, history}) => {
  return (
    <Button onClick={() => history.push(to)}>
      <i className={`fa fa-${icon}`} style={{color: "gray"}}></i> {children}
    </Button>
  )
})

export {Button, ButtonLink}
export default Button
