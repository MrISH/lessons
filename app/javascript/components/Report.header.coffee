import React from "react"
import PropTypes from "prop-types"
import axios from "axios"

const csrfToken = document.querySelector("meta[name=csrf-token]").content
axios.defaults.headers.common[‘X-CSRF-Token’] = csrfToken

class Report.header extends React.Component

  @propTypes =
    title: PropTypes.string
    teacher: PropTypes.string

  componentDidMount() {
      axios.get('http://localhost:3000/api/v1/students.json')
      .then(response => {
          console.log(response)
          this.setState({
              lists: response.data
          })
      })
      .catch(error => console.log(error))
  }

  render: ->
    `<React.Fragment>
      Title: {this.props.title}
      Teacher: {this.props.teacher}
    </React.Fragment>`

export default Report.header
