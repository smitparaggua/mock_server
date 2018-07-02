import React from "react"
import {Redirect} from "react-router-dom"
import {Input} from "components/input"
import {TextArea} from "components/text_area"
import {Submit} from "components/submit"
import {Routes} from "api"

export default class CreateRouteForm extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      method: "GET",
      path: "",
      description: "",
      responseType: "application/json"
    }

    this.handleChange = this.handleChange.bind(this)
    this.onSubmit = this.onSubmit.bind(this)
  }

  handleChange(event) {
    this.setState({[event.target.name]: event.target.value})
  }

  onSubmit(event) {
    event.preventDefault();
    return Routes.create(this.props.serverId, this.state)
  }

  render() {
    return (
      <form onSubmit={this.onSubmit}>
        <label>Method</label>
        <select name="method" onChange={this.handleChange}>
          <option value="GET">GET</option>
          <option value="POST">POST</option>
          <option value="PUT">PUT</option>
          <option value="PATCH">PATCH</option>
          <option value="DELETE">DELETE</option>
        </select>

        <Input type="text" name="path" icon="code" placeholder="URL"
               onChange={this.handleChange}/>

        <TextArea name="description" placeholder="Description"
                  onChange={this.handleChange}/>

        <Input type="text" name="statusCode" placeholder="Status Code"
               onChange={this.handleChange}/>

        <label>Response Type</label>
        <select name="responseType" onChange={this.handleChange}>
          <option value="application/json">JSON (application/json)</option>
          <option value="text/plain">Text (text/plain)</option>
          <option value="application/javascript">Javascript (application/javascript)</option>
          <option value="application/xml">XML (application/xml)</option>
          <option value="text/xml">XML (text/xml)</option>
          <option value="text/html">HTML</option>
        </select>

        <TextArea name="responseBody" placeholder="Response Body" onChange={this.handleChange}/>

        <div>
          <Submit/>
        </div>
      </form>
    )
  }
}
