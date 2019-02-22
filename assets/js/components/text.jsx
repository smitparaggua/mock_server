import React from "react"
import styled from "styled-components"

export const Comment = styled.div`
  color: #6c757d;
  font-style: italic;
`

export const TextWithDefaultComment = function ({text, defaultComment, ...otherProps}) {
  return text
    ? <div {...otherProps}>{text}</div>
    : <Comment>{defaultComment}</Comment>
}
