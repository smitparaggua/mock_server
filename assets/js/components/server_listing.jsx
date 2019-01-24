import React from "react"
import styled from "styled-components"
import Server from "components/server"

const ServerListing = ({servers, onDeleteSuccess, onDeleteFail}) => {
  const Listing = styled.div`
    list-style-type: none;
  `
  const ListItem = styled.li`
    margin-bottom: 1em;
  `
  return (
    <Listing>
      {servers.map(server => (
        <ListItem key={server.id}>
          <Server server={server} onDeleteSuccess={onDeleteSuccess} onDeleteFail={onDeleteFail}/>
        </ListItem>
      ))}
    </Listing>
  )
}

export default ServerListing
