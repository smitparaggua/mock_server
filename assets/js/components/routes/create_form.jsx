import React from "react"
import {Redirect} from "react-router-dom"
import {Input, GroupedInput} from "components/input"
import {TextArea} from "components/text_area"
import {Routes} from "api"
import {get} from "utils/object_utils"
import styled from "styled-components"
import {Dropdown} from "components/dropdown"
import Button from "components/button"

const Form = styled.div`
  div {
    width: 100%;
  }
`

const MethodDropdown = styled(Dropdown)`
  max-width: 7em;
`

const ResponseTypeDropdown = styled(Dropdown)`
  max-width: 20em;
`

const Error = styled.div`
  color: red;
`

const FormGroup = styled.div`
  margin: 20px 0;
  width: 100%;

  textarea {
    width: 100%;
  }
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
          <FormGroup>
            <GroupedInput>
              <MethodDropdown choices={httpMethods} onChange={this.handleChangeOf("method")}/>
              <Input icon="code" type="text" name="path" icon="code"
                placeholder="URL" onChange={this.handleChange}/>
            </GroupedInput>
            <Error>{errors.method}</Error>
            <Error>{errors.path}</Error>
          </FormGroup>

          <FormGroup>
            <GroupedInput>
              <ResponseTypeDropdown choices={responseTypes}
                onChange={this.handleChangeOf("responseType")}/>
              <Input type="text" name="statusCode"
                placeholder="Status Code" onChange={this.handleChange}/>
            </GroupedInput>
            <Error>{errors.responseType}</Error>
            <Error>{errors.statusCode}</Error>
          </FormGroup>

          <FormGroup>
            <TextArea name="responseBody" placeholder="Response Body" onChange={this.handleChange}/>
            <Error>{errors.responseBody}</Error>
          </FormGroup>

          <FormGroup>
            <TextArea name="description" placeholder="Description"
              onChange={this.handleChange}/>
            <Error>{errors.description}</Error>
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
