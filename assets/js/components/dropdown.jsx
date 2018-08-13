import React from "react"
import Button from "components/button"
import styled, {css} from "styled-components"
import {withStateHandlers, withState, compose, withHandlers} from "recompose"

const Icon = ({icon}) => (
  <i className={`fa fa-${icon}`}></i>
)

const Selection = styled.ul`
  border: 1px #ccc solid;
  list-style: none;
  position: absolute;
  margin: 0;
  z-index: 2;
  background-color: white;
  border-radius: 0 0 5px 5px;
  padding: 0;
  display: none;

  ${props => props.active && css`
    display: block;
  `}
`

const SelectionItem = styled.li`
  padding: 5px 20px;

  &:hover {
    background-color: #eee;
  }
`

const MethodSelection = ({active}) => (
  <Selection active={active}>
    <SelectionItem>GET</SelectionItem>
    <SelectionItem>POST</SelectionItem>
    <SelectionItem>PUT</SelectionItem>
    <SelectionItem>PATCH</SelectionItem>
    <SelectionItem>DELETE</SelectionItem>
  </Selection>
)

const addToggleActive = compose(
  withState('active', 'setActive', false),
  withHandlers({
    toggleActive: ({setActive}) => setActive(active => !active)
  })
)

export const Dropdown = addToggleActive(({className, selection, active, toggleActive}) => (
  <div>
    <Button className={className} onClick={toggleActive}>
      GET <Icon icon="angle-down"/>
    </Button>
    <MethodSelection active={active}/>
  </div>
))
