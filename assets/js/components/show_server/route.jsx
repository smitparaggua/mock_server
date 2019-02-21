import React from "react"
import styled from "styled-components"
import {ButtonLink} from "components/button"
import {Link} from "react-router-dom"

const RouteContainer = styled.li`
  margin: 0.5em;
`

const Description = styled.div`
  font-size: smaller;
  color: gray;
`

export default function ({route, server}) {
  const showRoutePath = `/servers/${server.id}/routes/${route.id}`
  return (
    <RouteContainer>
      <Link to={{pathname: showRoutePath, state: {route, server}}}>
        {route.method} {route.path}
      </Link>

      <Description>
        <div>{route.description}</div>
      </Description>
    </RouteContainer>
  )
}
