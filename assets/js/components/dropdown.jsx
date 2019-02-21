import React from "react"
import Button from "components/button"
import styled, {css} from "styled-components"
import {lifecycle, withStateHandlers, withState, compose, withHandlers} from "recompose"

const Icon = ({icon}) => (
  <i className={`fa fa-${icon}`}></i>
)

const Selection = styled.ul`
  font-size: 0.9em;
  list-style: none;
  position: absolute;
  margin: 0;
  z-index: 2;
  background-color: #2f364d;
  border-radius: 0 0 5px 5px;
  padding: 0;
  display: none;

  ${props => props.active && css`
    display: block;
  `}
`

const SelectionItem = styled.li`
  padding: 0.75em 2em;
  cursor: pointer;

  &:hover {
    background-color: rgba(200, 208, 218, 0.3);
  }
`

const DropdownButton = styled(Button)`
  font-size: 0.9em;
  height: 100%;
  width: 100%;

  ${props => props.active && css`
    background-color: #555c70;
  `}
`

export class Dropdown extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      selectedChoice: props.choices[0],
      active: false
    }
    this.toggleActive = this.toggleActive.bind(this)
    this.onChange = props.onChange || noop
    this.dismiss = this.dismiss.bind(this)
    this.handleClickOutside = this.handleClickOutside.bind(this)
    this.selectionRef = React.createRef()
    this.buttonRef = React.createRef()
  }

  componentDidMount() {
    document.addEventListener("click", this.handleClickOutside)
  }

  componentWillUnmount() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  toggleActive(event) {
    event.preventDefault()
    this.setState({
      active: !this.state.active
    })
  }

  onItemSelect(selected) {
    return () => {
      this.onChange(selected)
      this.setState({selectedChoice: selected})
      this.dismiss()
    }
  }

  dismiss() {
    this.setState({active: false})
  }

  handleClickOutside(event) {
    const clickLocation = event.target
    const selection = this.selectionRef.current
    const button = this.buttonRef.current
    if (!button.contains(clickLocation) && !selection.contains(clickLocation)) {
      this.dismiss()
    }
  }

  render() {
    const choices = this.props.choices
    const active = this.state.active
    return <div className={this.props.className}>
      <DropdownButton onClick={this.toggleActive}
        innerRef={this.buttonRef} active={active}>
        {this.state.selectedChoice.text} <Icon icon="angle-down"/>
      </DropdownButton>

      <Selection active={active} innerRef={this.selectionRef}>
        {choices && choices.map(choice => (
          <SelectionItem onClick={this.onItemSelect(choice)} key={choice.value}>
            {choice.text}
          </SelectionItem>
        ))}
      </Selection>
    </div>
  }
}

function noop() { }
