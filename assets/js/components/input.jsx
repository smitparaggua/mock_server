import React from "react"

export const inputStyle = {
  width: "100%",
  border: "1px solid #ccc",
  borderRadius: "4px",
  boxShadow: "inset 0 1px 1px rgb(0, 0, 0, 0.075)",
  padding: "6px 12px",
  lineHeight: "1.42",
  fontSize: ".8em",
  boxSizing: "border-box"
}

export const Input = (props) => {
  let {style, icon, ...otherProps} = props
  style = Object.assign({}, inputStyle, style)
  return icon
    ? <InputGroup {...props}/>
    : <input style={style} {...otherProps}/>
}

const InputGroup = ({icon, ...otherProps}) => {
  const containerStyle = {
    marginBottom: "15px",
    position: "relative"
  }
  const iconStyle = {
    position: "absolute",
    top: "calc(50% - 0.5em)",
    left: "0.8em",
    color: "gray"
  }
  const inputStyle = icon && {paddingLeft: "2.5em"}

  return (
    <div style={containerStyle}>
      <Input {...otherProps} style={inputStyle} />
      {icon && <i className={`fa fa-${icon}`} style={iconStyle}></i>}
    </div>
  )
}
