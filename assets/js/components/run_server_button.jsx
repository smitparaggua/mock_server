import React from "react"
import styled from "styled-components"
import {Button} from "./button"

const RippleContainer = styled.div`
  box-sizing: border-box;
  display: inline-block;
  position: relative;
  width: ${props => `${props.height || 64}px`};
  height: ${props => `${props.height || 64}px`};

  div {
    box-sizing: border-box;
    position: absolute;
    border: 4px solid #fff;
    opacity: 1;
    border-radius: 50%;
    animation: lds-ripple 1s cubic-bezier(0, 0.2, 0.8, 1) infinite;
  }

  div:nth-child(2) {
    animation-delay: -0.5s;
  }

  @keyframes lds-ripple {
    0% {
      top: ${props => `${props.height/2}px`};
      left: ${props => `${props.height/2}px`};
      width: 0;
      height: 0;
      opacity: 1;
    }
    100% {
      top: 0px;
      left: 0px;
      width: ${props => `${(props.height)|| 64}px`};
      height: ${props => `${(props.height)|| 64}px`};
      opacity: 0;
    }
  }
`

const Ripple = (props) => (
  <RippleContainer {...props}>
    <div></div>
    <div></div>
  </RippleContainer>
)

const BaseButton = styled(Button)`
  padding: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 40px;
  width: 125px;

  &:disabled {
    opacity: 0.75;
    cursor: default;
  }
`

const StartButtonContainer = styled(BaseButton)`
  background-color: #5fb760;
  border-color: #50ad51;
  color: white;
`

const StartButton = (props) => (
  <StartButtonContainer {...props}>
    Start
  </StartButtonContainer>
)

const StartingButton = (props) => (
  <StartButtonContainer {...props} disabled={true}>
    <Ripple height={30}/>
  </StartButtonContainer>
)

const StopButtonContainer = styled(BaseButton)`
  color: #fff;
  background-color: #d9534f;
  border-color: #d43f3a;
`

const StopButton = (props) => (
  <StopButtonContainer {...props}>
    Stop
  </StopButtonContainer>
)

const StoppingButton = (props) => (
  <StopButtonContainer {...props} disabled={true}>
    <Ripple height={30}/>
  </StopButtonContainer>
)


class RunServerButton extends React.PureComponent {
  constructor(props) {
    super(props)
  }

  render() {
    const {state, ...others} = this.props;
    const Button = buttonForState(this.props.state);
    return (
      <Button {...others}/>
    )
  }
}

function buttonForState(state) {
  return {
    stopped: StartButton,
    starting: StartingButton,
    running: StopButton,
    stopping: StoppingButton
  }[state] || StartButton;
}

export {RunServerButton}
export default RunServerButton
