export function get(object, path, defaultValue) {
  if (!object) {
    return null
  }
  let paths = path.split(".")
  return doGet(object, paths, defaultValue)
}

function doGet(object, paths, defaultValue) {
  if (paths.length == 0) {
    return object
  }
  if (!object[paths[0]]) {
    return defaultValue
  }
  object = object[paths[0]]
  return doGet(object, paths.slice(1))
}
