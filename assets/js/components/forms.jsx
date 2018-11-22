import React from "react"
import styled from "styled-components"

export const Form = styled.div`
  div {
    width: 100%;
  }
`

export const Error = styled.div`
  color: red;
`

const FormGroupContainer = styled.div`
  margin: 20px 0;
  width: 100%;

  textarea {
    width: 100%;
  }
`

export const FormGroup = props => (
  <FormGroupContainer>
    {props.children}
    {props.errors && Object.entries(props.errors).map(([field, error]) => {
      return error && <Error key={field}>{field} {error}</Error>
    })}
  </FormGroupContainer>
)
