import React from "react"

const styles = {
  position: "absolute",
  width: "50%",
  height: "200px",
  margin: "auto",
  top: 0,
  bottom: 0,
  left: 0,
  right: 0
}

const NotFound = () => {
  return (
    <div className="jumbotron" style={styles}>
      <h2>Page not found</h2>
      <p>You may have mistyped the address or the page may have moved</p>
    </div>
  )
}

export default NotFound
