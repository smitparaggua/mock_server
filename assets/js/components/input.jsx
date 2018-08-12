import React from "react"
import styled from "styled-components";

export const inputStyle = {
  // width: "100%",
  border: "1px solid #ccc",
  // borderRadius: "4px",
  boxShadow: "inset 0 1px 1px rgb(0, 0, 0, 0.075)",
  padding: "6px 12px",
  lineHeight: "1.42",
  fontSize: ".8em",
  boxSizing: "border-box"
}

const BaseInput = styled.input `
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: inset 0 1px 1px rgb(0, 0, 0, 0.075);
  padding: 6px 12px;
  line-height: 1.42;
  font-size: .8em;
  box-sizing: border-box;
`

export const Input = (props) => {
  let {icon, ...otherProps} = props
  return icon
    ? <InputGroup {...props}/>
    : <BaseInput {...otherProps}/>
}

const InputGroup = ({icon, ...otherProps, className}) => {
  const containerStyle = {
    // marginBottom: "15px",
    position: "relative"
  }
  const iconStyle = {
    position: "absolute",
    top: "calc(50% - 0.5em)",
    left: "0.8em",
    color: "gray"
  }
  const inputStyle = icon && {paddingLeft: "2.5em", width: "100%"}

  return (
    <div style={containerStyle} className={className}>
      {icon && <i className={`fa fa-${icon}`} style={iconStyle}></i>}
      <Input {...otherProps} style={inputStyle} />
    </div>
  )
}
