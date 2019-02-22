export function serverPath(id) {
  return `/servers/${id}`
}

export function showRoutePath(serverId, routeId) {
  return `/servers/${serverId}/routes/${routeId}`
}
