import React from "react"
import styled from "styled-components"

export default function Icon({icon}) {
  return (
    <i className={`fa fa-${icon}`}></i>
  )
}
