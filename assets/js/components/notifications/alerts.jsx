import React from "react"
import styled from "styled-components"

const Alert = styled.div`
  border: 0;
  border-radius: 0;
  color: #2c2c2c;
  padding-top: .9rem;
  padding-bottom: .9rem;
  position: relative;
  background: #0d111f;
  padding: 0.75rem 1.25rem;
  margin-bottom: 1rem;
  border-radius: 0.2rem;
`

export const SuccessAlert = styled(Alert)`
  color: #fdfcfc;
  background-color: #73c16bcc;
  border-color: #c0d0b0;
`

export const DangerAlert = styled(Alert)`
  border-color: #b78d8d
  color: #fdfcfc;
`
