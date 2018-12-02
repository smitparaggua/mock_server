import React from "react"
import {Redirect} from "react-router-dom"
import {Input, GroupedInput} from "components/input"
import {TextArea} from "components/text_area"
import {Routes} from "js/api"
import {get} from "utils/object_utils"
import styled from "styled-components"
import {Dropdown} from "components/dropdown"
import Button from "components/button"
import {Form, Error, FormGroup} from "components/forms"

export const MethodDropdown = styled(Dropdown)`
  max-width: 7em;
`

export const ResponseTypeDropdown = styled(Dropdown)`
  max-width: 20em;
`

const httpMethods = [
  {value: "GET", text: "GET"},
  {value: "POST", text: "POST"},
  {value: "PUT", text: "PUT"},
  {value: "PATCH", text: "PATCH"},
  {value: "DELETE", text: "DELETE"},
]

const responseTypes = [
  {value: "application/json", text: "JSON (application/json)"},
  {value: "text/plain", text: "Text (text/plain)"},
  {value: "application/javascript", text: "Javascript (application/javascript)"},
  {value: "application/xml", text: "XML (application/xml)"},
  {value: "text/xml", text: "XML (text/xml)"},
  {value: "text/html", text: "HTML (text/html)"}
]

export default class CreateRouteForm extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {
      method: "GET",
      path: "",
      description: "",
      responseType: "application/json",
      created: false,
      errors: {}
    }

    this.handleChange = this.handleChange.bind(this)
    this.handleChangeOf = this.handleChangeOf.bind(this)
    this.onSubmit = this.onSubmit.bind(this)
  }

  handleChangeOf(inputName) {
    return ({value}) => this.setState({[inputName]: value})
  }

  handleChange(event) {
    this.setState({[event.target.name]: event.target.value})
  }

  onSubmit(event) {
    const logError = error => {
      console.log(error)
      return error
    }
    event.preventDefault();
    return Routes.create(this.props.serverId, this.state)
      .then(() => this.setState({created: true}))
      .catch(error => this.setState({errors: error.details}))
  }

  render() {
    if (this.state.created) {
      return <Redirect to={`/servers/${this.props.serverId}`}/>
    }

    const errors = this.state.errors;
    return (
      <div>
        <form onSubmit={this.onSubmit}>
          <FormGroup errors={{Method: errors.method, Path: errors.path}}>
            <GroupedInput>
              <MethodDropdown choices={httpMethods} onChange={this.handleChangeOf("method")}/>
              <Input icon="code" type="text" name="path" icon="code"
                placeholder="URL" onChange={this.handleChange}/>
            </GroupedInput>
          </FormGroup>

          <FormGroup errors={{"Response Type": errors.responseType, "Status Code": errors.statusCode}}>
            <GroupedInput>
              <ResponseTypeDropdown choices={responseTypes}
                onChange={this.handleChangeOf("responseType")}/>
              <Input type="text" name="statusCode"
                placeholder="Status Code" onChange={this.handleChange}/>
            </GroupedInput>
          </FormGroup>

          <FormGroup errors={{"Response Body": errors.responseBody}}>
            <TextArea name="responseBody" placeholder="Response Body" onChange={this.handleChange}/>
          </FormGroup>

          <FormGroup errors={{Description: errors.description}}>
            <TextArea name="description" placeholder="Description"
              onChange={this.handleChange}/>
          </FormGroup>

          <FormGroup>
            <Button>Submit</Button>
          </FormGroup>
        </form>
      </div>
    )
  }
}


function noop() { }
