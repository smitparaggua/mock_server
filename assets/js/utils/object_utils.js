export function get(object, path) {
  if (!object) {
    return null
  }
  let paths = path.split(".")
  return doGet(object, paths)
}

function doGet(object, paths) {
  if (paths.length == 0) {
    return object
  }
  if (!object[paths[0]]) {
    return null
  }
  object = object[paths[0]]
  return doGet(object, paths.slice(1))
}
