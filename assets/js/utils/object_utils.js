const MAX_SAFE_INTEGER = 9007199254740991

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

export function isBlank(object) {
  if (isArrayLike(object)) {
    return object.length == 0
  }
  return isNil(object)
}

export function isNil(object) {
  return object == null
}

export function isArrayLike(value) {
  return value != null && isLength(value.length) && (typeof value != 'function')
}

export function isLength(value) {
  return typeof value == 'number' &&
    value > -1 && value % 1 == 0 && value <= MAX_SAFE_INTEGER;
}
