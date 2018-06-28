import axios from "axios"

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
  },

  create(serverId, params) {
    console.log('hahahaha')
    console.log('hahahaha')
    console.log('hahahaha')
    console.log(serverId)
    console.log(params)
    return axios.post(`/api/servers/${serverId}/routes`, params)
  }
}

function pick(keys) {
  return {
    ...(keys.reduce((mem, key) => ({ ...mem, [key]: obj[key] }), {}))
  }
}

export {Servers, Routes}
