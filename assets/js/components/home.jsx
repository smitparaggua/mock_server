import React from "react"

const Home = () => {
  return (
    <div className="container">
      <header className="header">
        <nav role="navigation">
          <ul className="nav nav-pills pull-right">
            <li><a href="http://www.phoenixframework.org/docs">Get Started</a></li>
          </ul>
        </nav>
        <span className="logo"></span>
      </header>

      <main role="main">
        <div className="jumbotron">
          <h2>Welcome to Phoenix!</h2>
          <p className="lead">A productive web framework that<br />does not compromise speed and maintainability.</p>
        </div>

        <div className="row marketing">
          <div className="col-lg-6">
            <h4>Resources</h4>
            <ul>
              <li>
                <a href="http://phoenixframework.org/docs/overview">Guides</a>
              </li>
              <li>
                <a href="https://hexdocs.pm/phoenix">Docs</a>
              </li>
              <li>
                <a href="https://github.com/phoenixframework/phoenix">Source</a>
              </li>
            </ul>
          </div>

          <div className="col-lg-6">
            <h4>Help</h4>
            <ul>
              <li>
                <a href="http://groups.google.com/group/phoenix-talk">Mailing list</a>
              </li>
              <li>
                <a href="http://webchat.freenode.net/?channels=elixir-lang">#elixir-lang on freenode IRC</a>
              </li>
              <li>
                <a href="https://twitter.com/elixirphoenix">@elixirphoenix</a>
              </li>
            </ul>
          </div>
        </div>
      </main>
    </div>
  )
}

export default Home
