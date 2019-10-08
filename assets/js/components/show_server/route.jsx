import React from "react"
import styled from "styled-components"
import {ButtonLink} from "components/button"
import {Link} from "react-router-dom"
import {showRoutePath} from "local_routes"
import Icon from "components/icon"


const RouteContainerWithoutBackground = styled.li`
  display: flex;
  justify-content: space-between;
`

const RouteContainer = styled(RouteContainerWithoutBackground)`
  background-color: #2e364f;
  border-radius: 0.3em;
  padding: 0.8em;
  margin-bottom: 1em;
  list-style-type: none;
`

const Description = styled.div`
  font-size: smaller;
  color: gray;
`

export default function Route({route, server, withoutBackground}) {
  const path = showRoutePath(server.id, route.id)
  const Container = withoutBackground ? RouteContainerWithoutBackground : RouteContainer
  return (
    <Container>
      <div>
        <Link to={{pathname: path, state: {route, server}}}>
          {route.method} {route.path}
        </Link>

        <Description>
          <div>{route.description}</div>
        </Description>
      </div>

      <div>
        <Icon icon="edit"/>
        <Icon icon="trash"/>
      </div>
    </Container>
  )
}

function RoutesContainer({routes, server}) {
  return (
    <div>
      {routes.map(route => <Route key={route.id} route={route} server={server} />)}
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
