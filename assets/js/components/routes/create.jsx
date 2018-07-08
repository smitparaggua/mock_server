import React from "react"
import CreateRouteForm from "routes/create_form"

const CreateRoute = (props) => {
  return (
    <div className="container">
      <h2>Create Route</h2>
      <CreateRouteForm serverId={props.match.params.serverId} />
    </div>
  )
}

export default CreateRoute
