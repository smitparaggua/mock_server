import React from "react"
import Button from "components/button"
import styled, {css} from "styled-components"
import {lifecycle, withStateHandlers, withState, compose, withHandlers} from "recompose"

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
  cursor: pointer;

  &:hover {
    background-color: #eee;
  }
`
const noop = () => {}

const MethodSelection = ({active, onChange = noop}) => (
  <Selection active={active}>
    <SelectionItem onClick={() => onChange({value: "GET"})}>GET</SelectionItem>
    <SelectionItem onClick={() => onChange({value: "POST"})}>POST</SelectionItem>
    <SelectionItem onClick={() => onChange({value: "PUT"})}>PUT</SelectionItem>
    <SelectionItem onClick={() => onChange({value: "PATCH"})}>PATCH</SelectionItem>
    <SelectionItem onClick={() => onChange({value: "DELETE"})}>DELETE</SelectionItem>
  </Selection>
)

const addDropdownHandlers = compose(
  withStateHandlers(
    {active: false, value: "GET"},
    {
      dismiss: ({active}) => () => ({active: false}),
      toggleActive: ({active}) => () => ({active: !active}),
      setValue: ({value}) => (newValue) => ({value: newValue})
    }
  ),

  lifecycle({
    componentDidMount() {
      document.addEventListener("click", dismiss)
    },

    componentWillUnmount() {
      document.removeEventListener("click", dismiss)
    }
  })
)

function dismiss() {
  // this.setState({active: false})
}

export const Dropdown = addDropdownHandlers(
  ({value, setValue, className, selection, active, toggleActive, onChange = noop, choices}) => (
    <div>
      <Button className={className} onClick={toggleActive}>
        {value} <Icon icon="angle-down"/>
      </Button>
      <Selection>
        {choices && choices.forEach(choice => (
          <SelectionItem onClick={() => onChange({value: choice.value})}>
            {choice.text}
          </SelectionItem>
        ))}
      </Selection>
    </div>
  )
)
