import React from "react"
import {servers_path} from "../remote_routes"
import {Input} from "./input"
import {TextArea} from "./text_area"
import {Submit} from "./submit"

const CreateServerForm = () => {
  return (
    <form action="{servers_path()}">
      <Input type="text" name="name" icon="server" placeholder="Name"/>
      <Input type="text" name="path" icon="code" placeholder="Path"/>
      <TextArea name="description" placeholder="Description"
                style={{marginBottom: "15px"}}/>
      <Submit/>
    </form>
  )
}

export default CreateServerForm
