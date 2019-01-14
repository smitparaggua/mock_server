import axios from "axios"
import request from "utils/request"

const Servers = {
  create(params) {
    return request.post('/api/servers', params)
  },

  get(id) {
    return axios.get(`/api/servers/${id}`)
  },

  start(id) {
    return axios.post(`/api/servers/${id}/start`)
  },

  stop(id) {
    return axios.post(`/api/servers/${id}/stop`)
  },

  delete(id) {
    return request.delete(`/api/servers/${id}`)
  }
}

const Routes = {
  list(serverId) {
    return axios.get(`/api/servers/${serverId}/routes`)
      .then(response => response.data)
  },

  create(serverId, params) {
    return request.post(`/api/servers/${serverId}/routes`, params)
  }
}

function pick(keys) {
  return {
    ...(keys.reduce((mem, key) => ({ ...mem, [key]: obj[key] }), {}))
  }
}

export {Servers, Routes}
