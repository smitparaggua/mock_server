import axios from "axios"
import {camelizeKeys, decamelizeKeys} from "humps"
import {get} from "utils/object_utils"

export default {
  get(url) {
    return handleResponse(axios.get(url))
  },

  post (url, params) {
    params = decamelizeKeys(params)
    return handleResponse(axios.post(url, params))
  },

  delete (url) {
    return handleResponse(axios.delete(url))
  }
}

function handleResponse(request) {
  return request
    .catch(error => Promise.reject(camelizeKeys(get(error, "response.data"))))
    .then(response => camelizeKeys(response.data))
}
