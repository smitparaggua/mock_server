import React from "react"
import styled from "styled-components";

export const inputStyle = {
  border: "1px solid #ccc",
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

const InputGroup = ({icon, className, ...otherProps}) => {
  const containerStyle = {
    position: "relative"
  }
  const iconStyle = {
    position: "absolute",
    top: "calc(50% - 0.5em)",
    left: "0.8em",
    color: "gray"
  }
  const inputStyle = icon && {paddingLeft: "2.5em", width: "100%", height: "100%"}

  return (
    <div style={containerStyle} className={className}>
      {icon && <i className={`fa fa-${icon}`} style={iconStyle}></i>}
      <Input {...otherProps} style={inputStyle} />
    </div>
  )
}

export const GroupedInput = styled.div`
  display: flex;
  align-content: stretch;

  button, input {
    border-radius: 0;
  }

  button:first-child,
  input:first-child {
    border-radius: 4px 0 0 4px;
  }

  button:last-child,
  input:last-child {
    border-radius: 0 4px 4px 0;
  }

  > div, > input {
    flex-grow: 1;
  }
`
