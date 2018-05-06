import React from "react"
import {Input, inputStyle} from "./input"

const style = {
  borderRadius: inputStyle.borderRadius,
  padding: inputStyle.padding,
  lineHeight: inputStyle.lineHeight,
  fontSize: inputStyle.fontSize
}

export const Submit = () => {
  return <input type="submit" style={style}/>
}
