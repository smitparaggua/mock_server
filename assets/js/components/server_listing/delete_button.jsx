import React from "react"
import styled from "styled-components"


const DeleteIcon = styled.i`
  color: #a33;
  font-size: 1.2em;
  cursor: pointer;
  pointer-events: none;
`

const DeleteButtonContainer = styled.button `
  background: transparent;
  border: 0;
  outline: none;
  height: 3em;
  font-size: 0.8em;
  cursor: pointer;
`

export default function (props) {
  return (
    <DeleteButtonContainer {...props}>
      <DeleteIcon className={`fa fa-times-circle`}>
      </DeleteIcon>
    </DeleteButtonContainer>
  )
}
