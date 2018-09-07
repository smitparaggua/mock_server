import axios from "axios"
import {camelizeKeys, decamelizeKeys} from "humps"
import {get} from "utils/object_utils"

const Servers = {
  create({name, path, description}) {
    return axios.post("/api/servers", {name, path, description})
  },

  get(id) {
    return axios.get(`/api/servers/${id}`)
  },

  start(id) {
    return axios.post(`/api/servers/${id}/start`)
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
      .catch(error => Promise.reject(camelizeKeys(get(error, "response.data"))))
      .then(response => camelizeKeys(response.data))
  }
}

function pick(keys) {
  return {
    ...(keys.reduce((mem, key) => ({ ...mem, [key]: obj[key] }), {}))
  }
}

export {Servers, Routes}
