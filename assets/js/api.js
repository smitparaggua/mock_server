import axios from "axios"
import request from "utils/request"

const Servers = {
  create(params) {
    return request.post('/api/servers', params)
  },

  get(id) {
    return request.get(`/api/servers/${id}`)
  },

  start(id) {
    return request.post(`/api/servers/${id}/start`)
  },

  stop(id) {
    return request.post(`/api/servers/${id}/stop`)
  },

  delete(id) {
    return request.delete(`/api/servers/${id}`)
  }
}

const Routes = {
  list(serverId) {
    return request.get(`/api/servers/${serverId}/routes`)
  },

  create(serverId, params) {
    return request.post(`/api/servers/${serverId}/routes`, params)
  },

  get(routeId) {
    return request.get(`/api/routes/${routeId}`)
  }
}

export {Servers, Routes}
