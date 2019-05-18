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

export default function Route({route, server}) {
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

function RoutesContainer({routes, server}) {
  return (
    <div>
      {routes.map(route => <Route route={route} server={server} />)}
    </div>
  )
}

export const Routes = styled(RoutesContainer)`
  background-color: #1b2238;

  > div {
    padding: 0.8em;

    &:nth-child(even) {
      background-color: #252b41;
    }
  }
`
