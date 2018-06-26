import React from "react"
import {Redirect} from "react-router-dom"
import {Input} from "input"
import {TextArea} from "./text_area"
import {Submit} from "./submit"

export default class CreateRouteForm extends React.PureComponent {
  render() {
    return (
      <form onSubmit={this.onSubmit}>
        <label>Method</label>
        <select name="method">
          <option value="GET">GET</option>
          <option value="POST">POST</option>
          <option value="PUT">PUT</option>
          <option value="PATCH">PATCH</option>
          <option value="DELETE">DELETE</option>
        </select>

        <Input type="text" name="path" icon="code" placeholder="/"/>
        <TextArea name="description"/>

        <Input type="text" name="status_code"/>

        <label>Response Type</label>
        <select name="response_type">
          <option value="application/json">JSON (application/json)</option>
          <option value="text/plain">Text (text/plain)</option>
          <option value="application/javascript">Javascript (application/javascript)</option>
          <option value="application/xml">XML (application/xml)</option>
          <option value="text/xml">XML (text/xml)</option>
          <option value="text/html">HTML</option>
        </select>

        <Submit/>
      </form>
    )
  }
}
