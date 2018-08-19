import React from "react"
import {inputStyle} from "./input"
import styled from "styled-components"

const textAreaStyle = Object.assign({resize: "vertical"}, inputStyle)

const StyledTextArea = styled.textarea`
  border: 1px solid #ccc;
  box-shadow: inset 0 1px 1px rgb(0, 0, 0, 0.075);
  box-sizing: border-box;
  font-size: 1em;
  padding: 6px 12px;
  line-height: 1.42;
`

export const TextArea = ({rows = 3, ...otherProps}) => {
  return (
    <StyledTextArea rows={rows} {...otherProps}>
    </StyledTextArea>
  )
}
