import React from "react"
import styled from "styled-components"

export const HighlightedCode = styled.code`
  background-color: #2c2c2c;
`

const CodeBlockContainer = styled.pre`
  background-color: #2c2c2c;
  padding: 1em;
`

export const CodeBlock = function ({children, ...otherProps}) {
  return (
    <CodeBlockContainer {...otherProps}>
      <code>
        {children}
      </code>
    </CodeBlockContainer>
  )
}

export const JsonBlock = function ({json}) {
  return (
    <CodeBlock>
      {JSON.stringify(JSON.parse(json), null, 2)}
    </CodeBlock>
  )
}
