import axios from "axios"

const Servers = {
  create({name, path, description}) {
    return axios.post("/api/servers", {name, path, description})
  },

  get(id) {
    return axios.get(`/api/servers/${id}`)
  }
}

export {Servers}
