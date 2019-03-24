import React from "react"
import styled from "styled-components"
import {ButtonLink} from "components/button"
import {Link} from "react-router-dom"
import {showRoutePath} from "local_routes"

const RouteContainer = styled.li`
`

const Description = styled.div`
  font-size: smaller;
  color: gray;
`

export default function ({route, server}) {
  const path = showRoutePath(server.id, route.id)
  return (
    <RouteContainer>
      <Link to={{pathname: path, state: {route, server}}}>
        {route.method} {route.path}
      </Link>

      <Description>
        <div>{route.description}</div>
      </Description>
    </RouteContainer>
  )
}
