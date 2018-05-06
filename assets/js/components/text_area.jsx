import React from "react"
import {inputStyle} from "./input"

const textAreaStyle = Object.assign({resize: "vertical"}, inputStyle)

export const TextArea = ({rows, style, ...otherProps}) => {
  style = Object.assign({}, textAreaStyle, style)
  return (
    <textarea rows={rows || 3} style={style} {...otherProps}>
    </textarea>
  )
}
