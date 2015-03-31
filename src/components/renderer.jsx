import React from "react";

export default React.createClass({
  render: function () {
    return <small className="debug">
        Rendered on the <strong>{this.props.renderer}</strong>
      </small>;
  },
});
