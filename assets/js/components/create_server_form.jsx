import React from "react"
import {Redirect} from "react-router-dom"
import {servers_path} from "../remote_routes"
import {Input} from "./input"
import {TextArea} from "./text_area"
import {Submit} from "./submit"
import {Servers} from "../api"

class CreateServerForm extends React.PureComponent {
  constructor(props) {
    super(props)
    this.state = {name: '', path: '', description: '', created: false}
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
    Servers.create(this.state).then(() => {
      this.setState({created: true})
    })
  }

  render() {
    return this.state.created ? this.afterCreate() : this.generateForm()
  }

  generateForm() {
    return (
      <form onSubmit={this.onSubmit}>
        <Input type="text" name="name" icon="server" placeholder="Name"
               onChange={this.handleChange} value={this.state.name}/>

        <Input type="text" name="path" icon="code" placeholder="Path"
               onChange={this.handleChange} value={this.state.path}/>

        <TextArea name="description" placeholder="Description"
                  style={{marginBottom: "15px"}} onChange={this.handleChange}
                  value={this.state.value}/>

        <Submit/>
      </form>
    )
  }

  afterCreate() {
    return <Redirect to="/servers"/>
  }
}

export default CreateServerForm
