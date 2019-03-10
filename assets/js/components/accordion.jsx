import React from "react"
import styled from "styled-components"

export const Accordion = styled.details`
  overflow: scroll;
  transition: height 0.6s;

	&[open] {
    max-height: 40em;
	}

  summary {
    max-height: 3.5em;
    outline: none;
    cursor: pointer;
    background-color: #2e364f;
    padding: 0.8em;
    border-radius: 0.5em;

    ::-webkit-details-marker {
      display: none;
    }

    > div {
      align-items: center;
      display: flex;
      justify-content: space-between;
    }
  }
`
