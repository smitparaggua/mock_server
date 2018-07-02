import axios from "axios"
import {camelizeKeys, decamelizeKeys} from "humps"

const Servers = {
  create({name, path, description}) {
    return axios.post("/api/servers", {name, path, description})
  },

  get(id) {
    return axios.get(`/api/servers/${id}`)
  }
}

const Routes = {
  list(serverId) {
    return axios.get(`/api/servers/${serverId}/routes`)
      .then(response => response.data)
  },

  create(serverId, params) {
    params = decamelizeKeys(params)
    return axios.post(`/api/servers/${serverId}/routes`, params)
      .then(response => response.data)
  }
}

function pick(keys) {
  return {
    ...(keys.reduce((mem, key) => ({ ...mem, [key]: obj[key] }), {}))
  }
}

export {Servers, Routes}
