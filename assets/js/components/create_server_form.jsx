import React from "react"

const CreateServerForm = () => {
  return (
    <form role="form">
      <div class="form-group has-feedback has-feedback-left">
        <label class="control-label">Name</label>
        <input type="text" name="name" placeholder="Name" className="form-control"/>
        <i class="glyphicon glyphicon-user form-control-feedback"></i>
      </div>

      <input type="text" name="name" placeholder="Name" className="form-control"/>
      <input type="text" name="path" placeholder="Path" className="form-control"/>
      <input type="text" name="description" placeholder="Description" className="form-control"/>
    </form>
  )
}

export default CreateServerForm
