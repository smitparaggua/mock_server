import React from "react"
import styled from "styled-components"
import {isBlank} from "utils/object_utils"

const Details = styled.details`
  overflow: scroll;
  transition: all 0.5s;
  min-height: 4em;
  max-height: 5em;

	&[open] {
    min-height: 10em;
    max-height: 40em;

    summary {
      border-radius: 0.3em 0.3em 0 0;
    }
	}

  summary {
    outline: none;
    cursor: pointer;
    background-color: #2e364f;
    padding: 0.8em;
    border-radius: 0.3em;

    ::-webkit-details-marker {
      display: none;
    }
  }
`

export const ItemsContainer = styled.div`
  text-align: center;
  padding: 0.5em;
  font-style: italic;
  border: 1px solid #242a3d;
  border-top-width: 0px;
  border-radius: 0 0 0.3em 0.3em;
  background-color: #1b2238;
`

export default function ListAccordion({children, ...otherProps}) {
  const {itemKey, items, itemTemplate} = children;
  return (
    <Details {...otherProps}>
      <summary>
        {children.header}
      </summary>
      <Items items={items} itemKey={itemKey} itemTemplate={itemTemplate}/>
    </Details>
  )
}

function Items({items, itemKey, itemTemplate}) {
  if (isBlank(items)) {
    return (<ItemsContainer>No items</ItemsContainer>)
  }
  return (
    <ItemsContainer>
      {items.map(item => (
        <div key={itemKey(item)}>
          {itemTemplate(item)}
        </div>
      ))}
    </ItemsContainer>
  )
}
