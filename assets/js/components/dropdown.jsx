import React from "react"
import Button from "components/button"
import styled from "styled-components"

const Icon = ({icon}) => (
  <i className={`fa fa-${icon}`}></i>
)

const Selection = styled.ul`
  border: 1px gray solid;
  list-style: none;
  position: absolute;
`

const SelectionItem = styled.li`
`

const MethodSelection = () => (
  <Selection>
    <SelectionItem>GET</SelectionItem>
    <SelectionItem>POST</SelectionItem>
    <SelectionItem>PUT</SelectionItem>
    <SelectionItem>PATCH</SelectionItem>
    <SelectionItem>DELETE</SelectionItem>
  </Selection>
)

export const Dropdown = ({className, selection}) => (
  <div>
    <Button className={className} onClick={showSelection(selection)}>
      GET <Icon icon="angle-down"/>
    </Button>
    <MethodSelection />
  </div>
)

function showSelection(selection) {
  return function () {
    
  }
}
