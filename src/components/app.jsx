import React    from "react";
import Renderer from "./renderer";

export default React.createClass({
  render: function () {
    return (
      <div>
          <h1>Home</h1>
          <p>View <a href="/posts">posts</a>.</p>
          <Renderer renderer={this.props.renderer} />
      </div>
    );
  }
});
