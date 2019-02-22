import React from "react"
import {Redirect} from "react-router-dom"
import {Input} from "./input"
import {TextArea} from "./text_area"
import {Servers} from "../api"
import {Form, Error, FormGroup} from "components/forms"
import Button from "components/button"

class CreateServerForm extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {name: '', path: '', description: '', errors: {}, created: false}
    this.handleChange = this.handleChange.bind(this)
    this.onSubmit = this.onSubmit.bind(this)
    this.generateForm = this.generateForm.bind(this)
  }

  handleChange(event) {
    event.preventDefault()
    this.setState({[event.target.name]: event.target.value})
  }

  onSubmit(event) {
    event.preventDefault()
    Servers.create(this.state)
      .then(() => this.setState({created: true}))
      .catch(error => this.setState({errors: error.details}))
  }

  render() {
    return this.state.created ? this.afterCreate() : this.generateForm()
  }

  generateForm() {
    const errors = this.state.errors
    return (
      <form onSubmit={this.onSubmit}>
        <FormGroup errors={{Name: errors.name}}>
          <Input type="text" name="name" icon="server" placeholder="Name"
                 onChange={this.handleChange} value={this.state.name}/>
        </FormGroup>

        <FormGroup errors={{Path: errors.path}}>
          <Input type="text" name="path" icon="code" placeholder="Path"
                 onChange={this.handleChange} value={this.state.path}/>
        </FormGroup>

        <FormGroup errors={{Description: errors.description}}>
          <TextArea name="description" placeholder="Description"
                    onChange={this.handleChange} value={this.state.value}/>
        </FormGroup>

        <FormGroup>
          <Button>Submit</Button>
        </FormGroup>
      </form>
    )
  }

  afterCreate() {
    return <Redirect to="/servers"/>
  }
}

export default CreateServerForm
